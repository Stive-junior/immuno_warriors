import 'package:dio/dio.dart';
import 'package:immuno_warriors/core/exceptions/app_exception.dart';
import 'package:immuno_warriors/core/exceptions/network_exceptions.dart';
import 'package:immuno_warriors/core/network/api_endpoints.dart';
import 'package:immuno_warriors/core/network/dio_client.dart';
import 'package:immuno_warriors/core/services/local_storage_service.dart';
import 'package:immuno_warriors/core/services/network_service.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

/// Service pour gérer la synchronisation entre les données locales et en ligne.
class SyncService {
  final DioClient _dioClient;
  final LocalStorageService _localStorage;
  final NetworkService _networkService;

  SyncService(this._dioClient, this._localStorage, this._networkService);

  /// Synchronise les données utilisateur.
  Future<Map<String, dynamic>> synchronizeUserData(
    Map<String, dynamic> localData, {
    String? lastSyncTimestamp,
  }) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    try {
      final response = await _dioClient.post(
        ApiEndpoints.syncUserData,
        data: {'localData': localData, 'lastSyncTimestamp': lastSyncTimestamp},
      );
      final syncedData = response.data as Map<String, dynamic>;
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _localStorage.clearSyncQueue(userId);
      AppLogger.info('Données utilisateur synchronisées : $userId');
      return syncedData;
    } on DioException catch (e) {
      AppLogger.error(
        'Erreur lors de la synchronisation des données utilisateur : $e',
      );
      throw ApiException(
        'Échec de la synchronisation des données utilisateur.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }

  /// Synchronise l'inventaire.
  Future<Map<String, dynamic>> synchronizeInventory(
    List<Map<String, dynamic>> localItems, {
    String? lastSyncTimestamp,
  }) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    try {
      final response = await _dioClient.post(
        ApiEndpoints.syncInventory,
        data: {
          'localItems': localItems,
          'lastSyncTimestamp': lastSyncTimestamp,
        },
      );
      final syncedData = response.data as Map<String, dynamic>;
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _localStorage.saveInventory(userId, syncedData['items']);
      await _localStorage.clearSyncQueue(userId);
      AppLogger.info('Inventaire synchronisé : $userId');
      return syncedData;
    } on DioException catch (e) {
      AppLogger.error(
        'Erreur lors de la synchronisation de l\'inventaire : $e',
      );
      throw ApiException(
        'Échec de la synchronisation de l\'inventaire.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }

  /// Synchronise les menaces.
  Future<Map<String, dynamic>> synchronizeThreats(
    List<Map<String, dynamic>> localThreats, {
    String? lastSyncTimestamp,
  }) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    try {
      final response = await _dioClient.post(
        ApiEndpoints.syncThreats,
        data: {
          'localThreats': localThreats,
          'lastSyncTimestamp': lastSyncTimestamp,
        },
      );
      final syncedData = response.data as Map<String, dynamic>;
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _localStorage.saveThreats(userId, syncedData['threats']);
      await _localStorage.clearSyncQueue(userId);
      AppLogger.info('Menaces synchronisées : $userId');
      return syncedData;
    } on DioException catch (e) {
      AppLogger.error('Erreur lors de la synchronisation des menaces : $e');
      throw ApiException(
        'Échec de la synchronisation des menaces.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }

  /// Synchronise les signatures de mémoire.
  Future<Map<String, dynamic>> synchronizeMemorySignatures(
    List<Map<String, dynamic>> localSignatures, {
    String? lastSyncTimestamp,
  }) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    try {
      final response = await _dioClient.post(
        ApiEndpoints.syncMemorySignatures,
        data: {
          'localSignatures': localSignatures,
          'lastSyncTimestamp': lastSyncTimestamp,
        },
      );
      final syncedData = response.data as Map<String, dynamic>;
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _localStorage.saveMemorySignatures(
        userId,
        syncedData['signatures'],
      );
      await _localStorage.clearSyncQueue(userId);
      AppLogger.info('Signatures de mémoire synchronisées : $userId');
      return syncedData;
    } on DioException catch (e) {
      AppLogger.error(
        'Erreur lors de la synchronisation des signatures de mémoire : $e',
      );
      throw ApiException(
        'Échec de la synchronisation des signatures de mémoire.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }

  /// Synchronise les sessions multijoueurs.
  Future<Map<String, dynamic>> synchronizeMultiplayerSessions(
    List<Map<String, dynamic>> localSessions, {
    String? lastSyncTimestamp,
  }) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    try {
      final response = await _dioClient.post(
        ApiEndpoints.syncMultiplayerSessions,
        data: {
          'localSessions': localSessions,
          'lastSyncTimestamp': lastSyncTimestamp,
        },
      );
      final syncedData = response.data as Map<String, dynamic>;
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _localStorage.saveMultiplayerSessions(
        userId,
        syncedData['sessions'],
      );
      await _localStorage.clearSyncQueue(userId);
      AppLogger.info('Sessions multijoueurs synchronisées : $userId');
      return syncedData;
    } on DioException catch (e) {
      AppLogger.error(
        'Erreur lors de la synchronisation des sessions multijoueurs : $e',
      );
      throw ApiException(
        'Échec de la synchronisation des sessions multijoueurs.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }

  /// Synchronise les notifications.
  Future<Map<String, dynamic>> synchronizeNotifications(
    List<Map<String, dynamic>> localNotifications, {
    String? lastSyncTimestamp,
  }) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    try {
      final response = await _dioClient.post(
        ApiEndpoints.syncNotifications,
        data: {
          'localNotifications': localNotifications,
          'lastSyncTimestamp': lastSyncTimestamp,
        },
      );
      final syncedData = response.data as Map<String, dynamic>;
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _localStorage.saveNotifications(
        userId,
        syncedData['notifications'],
      );
      await _localStorage.clearSyncQueue(userId);
      AppLogger.info('Notifications synchronisées : $userId');
      return syncedData;
    } on DioException catch (e) {
      AppLogger.error(
        'Erreur lors de la synchronisation des notifications : $e',
      );
      throw ApiException(
        'Échec de la synchronisation des notifications.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }

  /// Synchronise les pathogènes.
  Future<Map<String, dynamic>> synchronizePathogens(
    List<Map<String, dynamic>> localPathogens, {
    String? lastSyncTimestamp,
  }) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    try {
      final response = await _dioClient.post(
        ApiEndpoints.syncPathogens,
        data: {
          'localPathogens': localPathogens,
          'lastSyncTimestamp': lastSyncTimestamp,
        },
      );
      final syncedData = response.data as Map<String, dynamic>;
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _localStorage.savePathogens(userId, syncedData['pathogens']);
      await _localStorage.clearSyncQueue(userId);
      AppLogger.info('Pathogènes synchronisés : $userId');
      return syncedData;
    } on DioException catch (e) {
      AppLogger.error('Erreur lors de la synchronisation des pathogènes : $e');
      throw ApiException(
        'Échec de la synchronisation des pathogènes.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }

  /// Synchronise les recherches.
  Future<Map<String, dynamic>> synchronizeResearches(
    List<Map<String, dynamic>> localResearches, {
    String? lastSyncTimestamp,
  }) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    try {
      final response = await _dioClient.post(
        ApiEndpoints.syncResearches,
        data: {
          'localResearches': localResearches,
          'lastSyncTimestamp': lastSyncTimestamp,
        },
      );
      final syncedData = response.data as Map<String, dynamic>;
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _localStorage.saveResearchTree(userId, syncedData['researches']);
      await _localStorage.clearSyncQueue(userId);
      AppLogger.info('Recherches synchronisées : $userId');
      return syncedData;
    } on DioException catch (e) {
      AppLogger.error('Erreur lors de la synchronisation des recherches : $e');
      throw ApiException(
        'Échec de la synchronisation des recherches.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }
}
