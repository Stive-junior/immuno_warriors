import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:immuno_warriors/core/exceptions/app_exception.dart';
import 'package:immuno_warriors/core/exceptions/network_exceptions.dart';
import 'package:immuno_warriors/core/network/api_endpoints.dart';
import 'package:immuno_warriors/core/network/dio_client.dart';
import 'package:immuno_warriors/core/services/local_storage_service.dart';
import 'package:immuno_warriors/core/services/network_service.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

/// Service pour gérer les opérations liées aux réalisations.
/// Supporte les modes en ligne et hors ligne avec synchronisation différée.
class AchievementService {
  final DioClient _dioClient;
  final LocalStorageService _localStorage;
  final NetworkService _networkService;
  DateTime? _lastSyncTime;

  AchievementService(this._dioClient, this._localStorage, this._networkService);

  /// Récupère toutes les réalisations disponibles.
  /// - En ligne : Appel API et mise en cache local.
  /// - Hors ligne : Retourne les données locales si disponibles.
  Future<Either<ApiException, List<dynamic>>> getAllAchievements() async {
    const feature = 'achievements';
    final userId = _localStorage.getCurrentUserCache('current_user')?.id ?? '';

    if (await _networkService.isServerReachable()) {
      try {
        final response = await _dioClient.get(ApiEndpoints.getAchievements);
        final achievements = response.data as List<dynamic>;
        await _queueSyncOperation(userId, {
          'type': 'get_all_achievements',
          'data': achievements,
          'timestamp': DateTime.now().toIso8601String(),
        });
        _lastSyncTime = DateTime.now();
        AppLogger.info(
          'Toutes les réalisations récupérées en ligne : ${achievements.length}',
        );
        return Right(achievements);
      } on DioException catch (e) {
        final error = ApiException(
          'Échec de la récupération des réalisations : ${e.message}',
          statusCode: e.response?.statusCode,
          error: e.response?.data,
        );
        AppLogger.error(
          'Erreur lors de la récupération des réalisations en ligne : $e',
        );
        return Left(error);
      }
    }

    if (_networkService.isOfflineSupported(feature)) {
      final achievements = await _localStorage.getAchievements(userId);
      if (achievements != null) {
        AppLogger.warning(
          'Réalisations récupérées hors ligne (données potentiellement non à jour) : $userId',
        );
        return Right(achievements);
      }
    }

    return Left(ApiException('Données locales obsolètes.'));
  }

  /// Récupère une réalisation spécifique.
  /// - En ligne : Appel API et mise en cache local.
  /// - Hors ligne : Retourne les données locales si disponibles.
  Future<Either<ApiException, Map<String, dynamic>>> getAchievement(
    String achievementId,
  ) async {
    const feature = 'achievements';
    final userId = _localStorage.getCurrentUserCache('current_user')?.id ?? '';

    if (await _networkService.isServerReachable()) {
      try {
        final response = await _dioClient.get(
          ApiEndpoints.getAchievement(achievementId),
        );
        final achievement = response.data as Map<String, dynamic>;
        await _localStorage.saveAchievement(userId, achievement);
        await _queueSyncOperation(userId, {
          'type': 'get_achievement',
          'data': achievement,
          'timestamp': DateTime.now().toIso8601String(),
        });
        _lastSyncTime = DateTime.now();
        AppLogger.info('Réalisation récupérée en ligne : $achievementId');
        return Right(achievement);
      } on DioException catch (e) {
        final error = ApiException(
          'Échec de la récupération de la réalisation : ${e.message}',
          statusCode: e.response?.statusCode,
          error: e.response?.data,
        );
        AppLogger.error(
          'Erreur lors de la récupération de la réalisation en ligne : $e',
        );
        return Left(error);
      }
    }

    if (_networkService.isOfflineSupported(feature)) {
      final achievement = await _localStorage.getAchievement(
        userId,
        achievementId,
      );
      if (achievement != null) {
        AppLogger.warning(
          'Réalisation récupérée hors ligne (données potentiellement non à jour) : $achievementId',
        );
        return Right(achievement);
      }
    }

    return Left(ApiException('Données locales obsolètes.'));
  }

  /// Récupère les réalisations de l'utilisateur.
  /// - En ligne : collecte les données par API et met en cache localement.
  /// - Hors ligne : Retourne les données locales si disponibles.
  Future<Either<ApiException, List<dynamic>>> getUserAchievements() async {
    const feature = 'achievements';
    final userId = _localStorage.getCurrentUserCache('current_user')?.id ?? '';

    if (await _networkService.isServerReachable()) {
      try {
        final response = await _dioClient.get(ApiEndpoints.userAchievements);
        final achievements = response.data as List<dynamic>;
        for (final achievement in achievements) {
          await _localStorage.saveAchievement(
            userId,
            achievement as Map<String, dynamic>,
          );
        }
        await _queueSyncOperation(userId, {
          'type': 'get_user_achievements',
          'data': achievements,
          'timestamp': DateTime.now().toIso8601String(),
        });
        _lastSyncTime = DateTime.now();
        AppLogger.info(
          'Réalisations de l\'utilisateur récupérées en ligne : ${achievements.length}',
        );
        return Right(achievements);
      } on DioException catch (e) {
        final error = ApiException(
          'Échec de la récupération des réalisations de l\'utilisateur : ${e.message}',
          statusCode: e.response?.statusCode,
          error: e.response?.data,
        );
        AppLogger.error(
          'Erreur lors de la récupération des réalisations de l\'utilisateur en ligne : $e',
        );
        return Left(error);
      }
    }

    if (_networkService.isOfflineSupported(feature)) {
      final achievements = await _localStorage.getAchievements(userId);
      if (achievements != null) {
        AppLogger.warning(
          'Réalisations de l\'utilisateur récupérées hors ligne (données potentiellement non à jour) : $userId',
        );
        return Right(achievements);
      }
    }

    return Left(ApiException('Données locales obsolètes.'));
  }

  /// Récupère les réalisations par catégorie.
  /// - En ligne : Appel API et mise en cache local.
  /// - Hors ligne : Retourne les données locales filtrées par catégorie si disponibles.
  Future<Either<ApiException, List<dynamic>>> getAchievementsByCategory(
    String category,
  ) async {
    const feature = 'achievements';
    final userId = _localStorage.getCurrentUserCache('current_user')?.id ?? '';

    if (await _networkService.isServerReachable()) {
      try {
        final response = await _dioClient.get(
          ApiEndpoints.achievementsByCategory(category),
        );
        final achievements = response.data as List<dynamic>;
        await _queueSyncOperation(userId, {
          'type': 'get_achievements_by_category',
          'data': achievements,
          'timestamp': DateTime.now().toIso8601String(),
        });
        _lastSyncTime = DateTime.now();
        AppLogger.info(
          'Réalisations par catégorie récupérées en ligne : $category',
        );
        return Right(achievements);
      } on DioException catch (e) {
        final error = ApiException(
          'Échec de la récupération des réalisations par catégorie : ${e.message}',
          statusCode: e.response?.statusCode,
          error: e.response?.data,
        );
        AppLogger.error(
          'Erreur lors de la récupération des réalisations par catégorie en ligne : $e',
        );
        return Left(error);
      }
    }

    if (_networkService.isOfflineSupported(feature)) {
      final achievements = await _localStorage.getAchievements(userId);
      if (achievements != null) {
        final filteredAchievements =
            achievements
                .where((achievement) => achievement['category'] == category)
                .toList();
        AppLogger.warning(
          'Réalisations par catégorie récupérées hors ligne (données potentiellement non à jour) : $category',
        );
        return Right(filteredAchievements);
      }
    }

    return Left(ApiException('Données locales obsolètes.'));
  }

  /// Crée une nouvelle réalisation (réservé aux administrateurs).
  /// - Requiert une connexion réseau.
  /// - Enregistre l'action pour synchronisation.
  Future<void> createAchievement({
    required String name,
    required String description,
    required String category,
    required Map<String, dynamic> reward,
  }) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    final data = {
      'name': name,
      'description': description,
      'category': category,
      'reward': reward,
    };
    try {
      await _dioClient.post(ApiEndpoints.createAchievement, data: data);
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _queueSyncOperation(userId, {
        'type': 'create_achievement',
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
      });
      AppLogger.info('Réalisation créée : $name');
    } on DioException catch (e) {
      AppLogger.error('Erreur lors de la création de la réalisation : $e');
      throw ApiException(
        'Échec de la création de la réalisation.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }

  /// Met à jour une réalisation (réservé aux administrateurs).
  /// - Requiert une connexion réseau.
  /// - Enregistre l'action pour synchronisation.
  Future<void> updateAchievement({
    required String achievementId,
    String? name,
    String? description,
    Map<String, dynamic>? reward,
  }) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (description != null) data['description'] = description;
    if (reward != null) data['reward'] = reward;

    try {
      await _dioClient.put(
        ApiEndpoints.updateAchievement(achievementId),
        data: data,
      );
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _queueSyncOperation(userId, {
        'type': 'update_achievement',
        'data': {'achievementId': achievementId, ...data},
        'timestamp': DateTime.now().toIso8601String(),
      });
      AppLogger.info('Réalisation mise à jour : $achievementId');
    } on DioException catch (e) {
      AppLogger.error('Erreur lors de la mise à jour de la réalisation : $e');
      throw ApiException(
        'Échec de la mise à jour de la réalisation.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }

  /// Supprime une réalisation (réservé aux administrateurs).
  /// - Requiert une connexion réseau.
  /// - Supprime également la réalisation localement.
  Future<void> deleteAchievement(String achievementId) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    try {
      await _dioClient.delete(ApiEndpoints.deleteAchievement(achievementId));
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _localStorage.removeAchievement(userId, achievementId);
      await _queueSyncOperation(userId, {
        'type': 'delete_achievement',
        'data': {'achievementId': achievementId},
        'timestamp': DateTime.now().toIso8601String(),
      });
      AppLogger.info('Réalisation supprimée : $achievementId');
    } on DioException catch (e) {
      AppLogger.error('Erreur lors de la suppression de la réalisation : $e');
      throw ApiException(
        'Échec de la suppression de la réalisation.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }

  /// Déverrouille une réalisation pour l'utilisateur.
  /// - Requiert une connexion réseau.
  /// - Met à jour le cache local.
  Future<void> unlockAchievement(String achievementId) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    try {
      await _dioClient.post(
        ApiEndpoints.unlockAchievement,
        data: {'achievementId': achievementId},
      );
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      final achievement = await _localStorage.getAchievement(
        userId,
        achievementId,
      );
      if (achievement != null) {
        await _localStorage.saveAchievement(userId, {
          ...achievement,
          'unlocked': true,
        });
      }
      await _queueSyncOperation(userId, {
        'type': 'unlock_achievement',
        'data': {'achievementId': achievementId},
        'timestamp': DateTime.now().toIso8601String(),
      });
      AppLogger.info('Réalisation déverrouillée : $achievementId');
    } on DioException catch (e) {
      AppLogger.error('Erreur lors du déverrouillage de la réalisation : $e');
      throw ApiException(
        'Échec du déverrouillage de la réalisation.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }

  /// Met à jour la progression d'une réalisation.
  /// - Requiert une connexion réseau.
  /// - Met à jour le cache local.
  Future<void> updateAchievementProgress(
    String achievementId,
    int progress,
  ) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    try {
      await _dioClient.put(
        ApiEndpoints.updateAchievementProgress(achievementId),
        data: {'progress': progress},
      );
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      final achievement = await _localStorage.getAchievement(
        userId,
        achievementId,
      );
      if (achievement != null) {
        await _localStorage.saveAchievement(userId, {
          ...achievement,
          'progress': progress,
        });
      }
      await _queueSyncOperation(userId, {
        'type': 'update_achievement_progress',
        'data': {'achievementId': achievementId, 'progress': progress},
        'timestamp': DateTime.now().toIso8601String(),
      });
      AppLogger.info(
        'Progression de la réalisation mise à jour : $achievementId',
      );
    } on DioException catch (e) {
      AppLogger.error('Erreur lors de la mise à jour de la progression : $e');
      throw ApiException(
        'Échec de la mise à jour de la progression de la réalisation.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }

  /// Réclame la récompense d'une réalisation.
  /// - Requiert une connexion réseau.
  /// - Enregistre l'opération pour synchronisation.
  Future<void> claimAchievementReward(String achievementId) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    try {
      await _dioClient.post(
        ApiEndpoints.claimAchievementReward,
        data: {'achievementId': achievementId},
      );
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _queueSyncOperation(userId, {
        'type': 'claim_achievement_reward',
        'data': {'achievementId': achievementId},
        'timestamp': DateTime.now().toIso8601String(),
      });
      AppLogger.info('Récompense de la réalisation réclamée : $achievementId');
    } on DioException catch (e) {
      AppLogger.error('Erreur lors de la réclamation de la récompense : $e');
      throw ApiException(
        'Échec de la réclamation de la récompense.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }

  /// Notifie l'utilisateur d'une réalisation déverrouillée.
  /// - Requiert une connexion réseau.
  /// - Enregistre l'opération pour synchronisation.
  Future<void> notifyAchievementUnlocked(String achievementId) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    try {
      await _dioClient.post(
        ApiEndpoints.notifyAchievementUnlocked(achievementId),
      );
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _queueSyncOperation(userId, {
        'type': 'notify_achievement_unlocked',
        'data': {'achievementId': achievementId},
        'timestamp': DateTime.now().toIso8601String(),
      });
      AppLogger.info(
        'Notification envoyée pour la réalisation : $achievementId',
      );
    } on DioException catch (e) {
      AppLogger.error('Erreur lors de l\'envoi de la notification : $e');
      throw ApiException(
        'Échec de l\'envoi de la notification.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }

  /// Ajoute une opération à la file d'attente de synchronisation.
  /// Inclut un horodatage pour suivre la fraîcheur des données.
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
