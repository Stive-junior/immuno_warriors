import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:immuno_warriors/core/exceptions/app_exception.dart';
import 'package:immuno_warriors/core/exceptions/network_exceptions.dart';
import 'package:immuno_warriors/core/network/api_endpoints.dart';
import 'package:immuno_warriors/core/network/dio_client.dart';
import 'package:immuno_warriors/core/services/local_storage_service.dart';
import 'package:immuno_warriors/core/services/network_service.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

/// Service pour gérer les opérations liées au scanner de menaces.
/// Supporte les modes en ligne et hors ligne avec synchronisation différée.
class ThreatScannerService {
  final DioClient _dioClient;
  final LocalStorageService _localStorage;
  final NetworkService _networkService;
  DateTime? _lastSyncTime;

  ThreatScannerService(
    this._dioClient,
    this._localStorage,
    this._networkService,
  );

  /// Ajoute une nouvelle menace.
  /// - Requiert une connexion réseau.
  /// - Enregistre l'opération pour synchronisation.
  Future<void> addThreat(
    String name,
    String type,
    int threatLevel,
    Map<String, dynamic>? details,
  ) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    final data = {
      'name': name,
      'type': type,
      'threatLevel': threatLevel,
      if (details != null) 'details': details,
    };
    try {
      await _dioClient.post(ApiEndpoints.addThreat, data: data);
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _localStorage.saveThreat(userId, data);
      await _queueSyncOperation(userId, {
        'type': 'add_threat',
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
      });
      AppLogger.info('Menace ajoutée : $name');
    } on DioException catch (e) {
      // Corrected: `DioException` as a type
      AppLogger.error('Erreur lors de l\'ajout de la menace : $e');
      throw ApiException(
        'Échec de l\'ajout de la menace.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }

  /// Récupère une menace spécifique.
  /// - En ligne : Appel API et mise en cache local.
  /// - Hors ligne : Retourne les données locales si disponibles.
  Future<Either<ApiException, Map<String, dynamic>>> getThreat(
    String threatId,
  ) async {
    const feature = 'threats';
    final userId = _localStorage.getCurrentUserCache('current_user')?.id ?? '';

    if (await _networkService.isServerReachable()) {
      try {
        final response = await _dioClient.get(ApiEndpoints.getThreat(threatId));
        final threat = response.data as Map<String, dynamic>;
        await _localStorage.saveThreat(userId, threat);
        await _queueSyncOperation(userId, {
          'type': 'get_threat',
          'data': threat,
          'timestamp': DateTime.now().toIso8601String(),
        });
        _lastSyncTime = DateTime.now();
        AppLogger.info('Menace récupérée en ligne : $threatId');
        return Right(threat);
      } on DioException catch (e) {
        // Corrected: `DioException` as a type
        final error = ApiException(
          'Échec de la récupération de la menace : ${e.message}',
          statusCode: e.response?.statusCode,
          error: e.response?.data,
        );
        AppLogger.error(
          'Erreur lors de la récupération de la menace en ligne : $e',
        );
        return Left(error);
      }
    }

    if (_networkService.isOfflineSupported(feature)) {
      final threat = await _localStorage.getThreat(userId, threatId);
      if (threat != null) {
        AppLogger.warning(
          'Menace récupérée hors ligne (données potentiellement non à jour) : $threatId',
        );
        return Right(threat);
      }
    }

    return Left(ApiException('Données locales obsolètes.'));
  }

  /// Analyse une cible pour détecter des menaces.
  /// - Requiert une connexion réseau.
  /// - Enregistre l'opération pour la synchronisation.
  Future<Either<ApiException, Map<String, dynamic>>> scanThreat(
    String targetId,
  ) async {
    // Corrected: Return type to `Map<String, dynamic>`
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    try {
      final response = await _dioClient.get(
        ApiEndpoints.threatScannerScanUrl(targetId),
      );
      final result = response.data as Map<String, dynamic>;
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _queueSyncOperation(userId, {
        'type': 'scan_threat',
        'data': {
          'targetId': targetId,
          'result': result,
        }, // Corrected: proper map structure
        'timestamp': DateTime.now().toIso8601String(),
      });
      AppLogger.info('Analyse de menace effectuée pour la cible : $targetId');
      return Right(result);
    } on DioException catch (e) {
      // Corrected: `DioException` as a type
      final error = ApiException(
        'Échec de l\'analyse de la menace : ${e.message}',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
      AppLogger.error('Erreur lors de l\'analyse de la menace : $e');
      return Left(error);
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
