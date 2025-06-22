import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:immuno_warriors/core/exceptions/app_exception.dart';
import 'package:immuno_warriors/core/exceptions/network_exceptions.dart';
import 'package:immuno_warriors/data/models/progression_model.dart';
import 'package:uuid/uuid.dart';
import 'package:immuno_warriors/core/network/api_endpoints.dart';
import 'package:immuno_warriors/core/network/dio_client.dart';
import 'package:immuno_warriors/core/services/local_storage_service.dart';
import 'package:immuno_warriors/core/services/network_service.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

/// Service pour gérer la progression des utilisateurs (pathogènes).
/// Supporte le stockage local et l'accès hors ligne.
class ProgressionService {
  final DioClient _dioClient;
  final LocalStorageService _localStorage;
  final NetworkService _networkService;
  DateTime? _lastSyncTime;

  ProgressionService(this._dioClient, this._localStorage, this._networkService);

  /// Récupère la progression de l'utilisateur.
  /// - En ligne : Récupère depuis le serveur et met en cache.
  /// - Hors ligne : Retourne la progression locale si disponible.
  Future<Either<ApiException, ProgressionModel>> getProgression() async {
    const feature = 'progression';
    final userId = _localStorage.getCurrentUserCache('current_user')?.id ?? '';

    if (!Uuid.isValidUUID(fromString: userId)) {
      return Left(
        ApiException('ID d\'utilisateur invalide : doit être un UUID valide.'),
      );
    }

    if (await _networkService.isServerReachable()) {
      try {
        final response = await _dioClient.get(ApiEndpoints.getProgression);
        final responseData = response.data['data'] as Map<String, dynamic>;
        final progression = ProgressionModel.fromJson(responseData);
        await _localStorage.saveProgression(userId, progression);
        await _queueSyncOperation(userId, {
          'type': 'get_progression',
          'data': progression.toJson(),
          'timestamp': DateTime.now().toIso8601String(),
        });
        _lastSyncTime = DateTime.now();
        AppLogger.info('Progression récupérée pour l\'utilisateur $userId');
        return Right(progression);
      } on DioException catch (e) {
        final error = ApiException(
          'Échec de la récupération de la progression : ${e.message}',
          statusCode: e.response?.statusCode,
          error: e.response?.data,
        );
        AppLogger.error(
          'Erreur lors de la récupération de la progression : $e',
        );
        return Left(error);
      }
    }

    if (_networkService.isOfflineSupported(feature)) {
      final progression = await _localStorage.getProgression(userId);
      if (progression != null) {
        AppLogger.warning(
          'Progression récupérée hors ligne (données potentiellement non à jour)',
        );
        return Right(progression);
      }
    }

    return Left(
      ApiException('Progression non trouvée ou données locales obsolètes.'),
    );
  }

  /// Ajoute de l'expérience (XP) à l'utilisateur.
  /// - En ligne : Envoie au serveur et met en cache.
  /// - Hors ligne : Non supporté (requiert une connexion).
  Future<Either<ApiException, ProgressionModel>> addXP(int xp) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    if (xp <= 0) {
      return Left(ApiException('XP doit être un entier positif.'));
    }

    try {
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      if (!Uuid.isValidUUID(fromString: userId)) {
        return Left(
          ApiException(
            'ID d\'utilisateur invalide : doit être un UUID valide.',
          ),
        );
      }

      final response = await _dioClient.post(
        ApiEndpoints.addXP,
        data: {'xp': xp},
      );
      final responseData = response.data['data'] as Map<String, dynamic>;
      final progression = ProgressionModel.fromJson(responseData);
      await _localStorage.saveProgression(userId, progression);
      await _queueSyncOperation(userId, {
        'type': 'add_xp',
        'data': progression.toJson(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      _lastSyncTime = DateTime.now();
      AppLogger.info('Ajout de $xp XP pour l\'utilisateur $userId');
      return Right(progression);
    } on DioException catch (e) {
      final error = ApiException(
        'Échec de l\'ajout d\'XP : ${e.message}',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
      AppLogger.error('Erreur lors de l\'ajout d\'XP : $e');
      return Left(error);
    }
  }

  /// Complète une mission pour l'utilisateur.
  /// - En ligne : Envoie au serveur et met en cache.
  /// - Hors ligne : Non supporté (requiert une connexion).
  Future<Either<ApiException, ProgressionModel>> completeMission(
    String missionId,
  ) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    if (!Uuid.isValidUUID(fromString: missionId)) {
      return Left(
        ApiException('ID de mission invalide : doit être un UUID valide.'),
      );
    }

    try {
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      if (!Uuid.isValidUUID(fromString: userId)) {
        return Left(
          ApiException(
            'ID d\'utilisateur invalide : doit être un UUID valide.',
          ),
        );
      }

      final response = await _dioClient.post(
        ApiEndpoints.completeMission(missionId),
      );
      final responseData = response.data['data'] as Map<String, dynamic>;
      final progression = ProgressionModel.fromJson(responseData);
      await _localStorage.saveProgression(userId, progression);
      await _queueSyncOperation(userId, {
        'type': 'complete_mission',
        'data': progression.toJson(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      _lastSyncTime = DateTime.now();
      AppLogger.info(
        'Mission $missionId complétée pour l\'utilisateur $userId',
      );
      return Right(progression);
    } on DioException catch (e) {
      final error = ApiException(
        'Échec de la complétion de la mission : ${e.message}',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
      AppLogger.error('Erreur lors de la complétion de la mission : $e');
      return Left(error);
    }
  }

  /// Ajoute une opération à la file d'attente de synchronisation.
  Future<void> _queueSyncOperation(
    String userId,
    Map<String, dynamic> operation,
  ) async {
    if (_lastSyncTime != null) {
      operation['lastSyncTime'] = _lastSyncTime!.toIso8601String();
    }
    await _localStorage.queueSyncOperation(userId, operation);
    AppLogger.info(
      'Opération ajoutée à la file d\'attente de synchronisation : ${operation['type']}',
    );
  }
}
