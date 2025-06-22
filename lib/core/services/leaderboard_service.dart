import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:immuno_warriors/core/exceptions/app_exception.dart';
import 'package:immuno_warriors/data/models/leaderboard_model.dart';
import 'package:uuid/uuid.dart';
import 'package:immuno_warriors/core/network/api_endpoints.dart';
import 'package:immuno_warriors/core/network/dio_client.dart';
import 'package:immuno_warriors/core/services/local_storage_service.dart';
import 'package:immuno_warriors/core/services/network_service.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

/// Service pour gérer les classements des utilisateurs.
/// Supporte le stockage local et l'accès hors ligne.
class LeaderboardService {
  final DioClient _dioClient;
  final LocalStorageService _localStorage;
  final NetworkService _networkService;
  DateTime? _lastSyncTime;
  static const _validCategories = {'combat', 'research', 'resources'};

  LeaderboardService(this._dioClient, this._localStorage, this._networkService);

  /// Met à jour le score de l'utilisateur dans une catégorie.
  /// - En ligne : Envoie au serveur et met en cache.
  /// - Hors ligne : Non supporté (requiert une connexion).
  Future<Either<ApiException, void>> updateScore(
    int score,
    String category,
  ) async {
    try {
      if (!await _networkService.isServerReachable()) {
        return Left(ApiException('Aucune connexion Internet disponible.'));
      }

      // Valider les données
      if (!_validCategories.contains(category)) {
        return Left(
          ApiException(
            'Catégorie invalide : doit être combat, research ou resources.',
          ),
        );
      }
      if (score < 0) {
        return Left(ApiException('Le score doit être supérieur ou égal à 0.'));
      }

      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      if (!Uuid.isValidUUID(fromString: userId)) {
        return Left(
          ApiException(
            'ID d\'utilisateur invalide : doit être un UUID valide.',
          ),
        );
      }

      await _dioClient.post(
        ApiEndpoints.updateLeaderboardScore,
        data: {'score': score, 'category': category},
      );
      final username =
          _localStorage.getCurrentUserCache('current_user')?.username ??
          'Anonyme';
      final leaderboardEntry = LeaderboardModel(
        userId: userId,
        username: username,
        score: score,
        rank: 0, // Rank sera mis à jour par le serveur
        category: category,
        updatedAt: DateTime.now().toIso8601String(),
      );
      await _localStorage.saveLeaderboard(userId, leaderboardEntry);
      await _queueSyncOperation(userId, {
        'type': 'update_score',
        'data': {'score': score, 'category': category},
        'timestamp': DateTime.now().toIso8601String(),
      });
      _lastSyncTime = DateTime.now();
      AppLogger.info('Score mis à jour pour la catégorie $category : $score');
      return const Right(null);
    } on DioException catch (e) {
      final error = ApiException(
        'Échec de la mise à jour du score : ${e.message}',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
      AppLogger.error('Erreur lors de la mise à jour du score : $e');
      return Left(error);
    } catch (e) {
      AppLogger.error('Erreur inattendue lors de la mise à jour du score : $e');
      return Left(ApiException('Erreur inattendue : $e'));
    }
  }

  /// Récupère le classement pour une catégorie.
  /// - En ligne : Récupère depuis le serveur et met en cache.
  /// - Hors ligne : Retourne le classement local si disponible.
  Future<Either<ApiException, List<LeaderboardModel>>> getLeaderboard(
    String category,
  ) async {
    const feature = 'leaderboard';
    final userId = _localStorage.getCurrentUserCache('current_user')?.id ?? '';

    if (!_validCategories.contains(category)) {
      return Left(
        ApiException(
          'Catégorie invalide : doit être combat, research ou resources.',
        ),
      );
    }

    if (await _networkService.isServerReachable()) {
      try {
        final response = await _dioClient.get(
          ApiEndpoints.getLeaderboard(category),
        );
        if (response.data['data'] is! List) {
          return Left(
            ApiException('Format de réponse invalide pour le classement.'),
          );
        }
        final responseData = response.data['data'] as List<dynamic>;
        final leaderboard =
            responseData
                .map(
                  (item) =>
                      LeaderboardModel.fromJson(item as Map<String, dynamic>),
                )
                .toList();
        for (var item in leaderboard) {
          await _localStorage.saveLeaderboard(userId, item);
        }
        await _queueSyncOperation(userId, {
          'type': 'get_leaderboard',
          'data': leaderboard.map((item) => item.toJson()).toList(),
          'timestamp': DateTime.now().toIso8601String(),
        });
        _lastSyncTime = DateTime.now();
        AppLogger.info(
          'Classement récupéré pour la catégorie $category : ${leaderboard.length} entrées',
        );
        return Right(leaderboard);
      } on DioException catch (e) {
        final error = ApiException(
          'Échec de la récupération du classement : ${e.message}',
          statusCode: e.response?.statusCode,
          error: e.response?.data,
        );
        AppLogger.error('Erreur lors de la récupération du classement : $e');
        return Left(error);
      } catch (e) {
        AppLogger.error(
          'Erreur inattendue lors de la récupération du classement : $e',
        );
        return Left(ApiException('Erreur inattendue : $e'));
      }
    }

    if (_networkService.isOfflineSupported(feature)) {
      try {
        final leaderboards = await _localStorage.getLeaderboard(userId);
        if (leaderboards!.isNotEmpty) {
          final filtered =
              leaderboards.where((item) => item.category == category).toList();
          if (filtered.isNotEmpty) {
            AppLogger.warning(
              'Classement récupéré hors ligne pour $category (données potentiellement non à jour)',
            );
            return Right(filtered);
          }
        }
      } catch (e) {
        AppLogger.error(
          'Erreur lors de la récupération du classement hors ligne : $e',
        );
        return Left(
          ApiException(
            'Erreur lors de la récupération des données locales : $e',
          ),
        );
      }
    }

    return Left(
      ApiException('Classement non trouvé ou données locales obsolètes.'),
    );
  }

  /// Récupère le rang de l'utilisateur dans une catégorie.
  /// - En ligne : Récupère depuis le serveur et met en cache.
  /// - Hors ligne : Retourne le rang local si disponible.
  Future<Either<ApiException, LeaderboardModel>> getUserRank(
    String category,
  ) async {
    const feature = 'leaderboard';
    final userId = _localStorage.getCurrentUserCache('current_user')?.id ?? '';
    final username =
        _localStorage.getCurrentUserCache('current_user')?.username ??
        'Anonyme';

    if (!_validCategories.contains(category)) {
      return Left(
        ApiException(
          'Catégorie invalide : doit être combat, research ou resources.',
        ),
      );
    }
    if (!Uuid.isValidUUID(fromString: userId)) {
      return Left(
        ApiException('ID d\'utilisateur invalide : doit être un UUID valide.'),
      );
    }

    if (await _networkService.isServerReachable()) {
      try {
        final response = await _dioClient.get(
          ApiEndpoints.getUserRank(category),
        );
        if (response.data['data'] is! Map<String, dynamic>) {
          return Left(ApiException('Format de réponse invalide pour le rang.'));
        }
        final responseData = response.data['data'] as Map<String, dynamic>;
        final rankInfo = LeaderboardModel(
          userId: userId,
          username: username,
          score: (responseData['score'] as num?)?.toInt() ?? 0,
          rank: (responseData['rank'] as num?)?.toInt() ?? 0,
          category: category,
          updatedAt: DateTime.now().toIso8601String(),
        );
        await _localStorage.saveLeaderboard(userId, rankInfo);
        await _queueSyncOperation(userId, {
          'type': 'get_user_rank',
          'data': rankInfo.toJson(),
          'timestamp': DateTime.now().toIso8601String(),
        });
        _lastSyncTime = DateTime.now();
        AppLogger.info(
          'Rang récupéré pour la catégorie $category : ${rankInfo.rank}',
        );
        return Right(rankInfo);
      } on DioException catch (e) {
        final error = ApiException(
          'Échec de la récupération du rang : ${e.message}',
          statusCode: e.response?.statusCode,
          error: e.response?.data,
        );
        AppLogger.error('Erreur lors de la récupération du rang : $e');
        return Left(error);
      } catch (e) {
        AppLogger.error(
          'Erreur inattendue lors de la récupération du rang : $e',
        );
        return Left(ApiException('Erreur inattendue : $e'));
      }
    }

    if (_networkService.isOfflineSupported(feature)) {
      try {
        final leaderboards = await _localStorage.getLeaderboard(userId);
        if (leaderboards!.isNotEmpty) {
          final userEntry = leaderboards.firstWhere(
            (item) => item.userId == userId && item.category == category,
            orElse: () => throw Exception('Aucune entrée trouvée'),
          );
          AppLogger.warning(
            'Rang récupéré hors ligne pour $category (données potentiellement non à jour)',
          );
          return Right(userEntry);
        }
      } catch (e) {
        AppLogger.error(
          'Erreur lors de la récupération du rang hors ligne : $e',
        );
        return Left(
          ApiException('Rang non trouvé ou données locales obsolètes.'),
        );
      }
    }

    return Left(ApiException('Rang non trouvé ou données locales obsolètes.'));
  }

  /// Ajoute une opération à la file d'attente de synchronisation.
  Future<void> _queueSyncOperation(
    String userId,
    Map<String, dynamic> operation,
  ) async {
    try {
      if (_lastSyncTime != null) {
        operation['lastSyncTime'] = _lastSyncTime!.toIso8601String();
      }
      await _localStorage.queueSyncOperation(userId, operation);
      AppLogger.info(
        'Opération ajoutée à la file d\'attente de synchronisation : ${operation['type']}',
      );
    } catch (e) {
      AppLogger.error(
        'Erreur lors de l\'ajout à la file de synchronisation : $e',
      );
      rethrow;
    }
  }
}
