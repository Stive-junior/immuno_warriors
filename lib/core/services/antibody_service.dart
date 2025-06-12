import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:immuno_warriors/core/exceptions/app_exception.dart';

import 'package:immuno_warriors/core/exceptions/network_exceptions.dart';
import 'package:immuno_warriors/core/network/api_endpoints.dart';
import 'package:immuno_warriors/core/network/dio_client.dart';
import 'package:immuno_warriors/core/services/local_storage_service.dart';
import 'package:immuno_warriors/core/services/network_service.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/data/models/antibody_model.dart';

/// Service pour gérer les opérations liées aux anticorps.
/// Supporte les modes en ligne et hors ligne avec synchronisation différée.
class AntibodyService {
  final DioClient _dioClient;
  final LocalStorageService _localStorage;
  final NetworkService _networkService;
  DateTime? _lastSyncTime;

  AntibodyService(this._dioClient, this._localStorage, this._networkService);

  /// Récupère tous les anticorps disponibles.
  /// - En ligne : Appel API et mise en cache local.
  /// - Hors ligne : Retourne les données locales si disponibles.
  Future<Either<ApiException, List<dynamic>>> getAllAntibodies() async {
    const feature = 'antibodies';
    final userId = _localStorage.getCurrentUserCache('current_user')?.id ?? '';

    if (await _networkService.isServerReachable()) {
      try {
        final response = await _dioClient.get(ApiEndpoints.getAllAntibodies);
        final antibodies = response.data as List<dynamic>;
        for (final antibodyJson in antibodies) {
          final antibodyModel = AntibodyModel.fromJson(
            antibodyJson as Map<String, dynamic>,
          );
          await _localStorage.saveAntibody(userId, antibodyModel);
        }
        await _queueSyncOperation(userId, {
          'type': 'get_all_antidodies',
          'data': antibodies,
          'timestamp': DateTime.now().toIso8601String(),
        });
        _lastSyncTime = DateTime.now();
        AppLogger.info('Anticorps récupérés en ligne : ${antibodies.length}');
        return Right(antibodies);
      } on DioException catch (e) {
        final error = ApiException(
          'Échec de la récupération des anticorps : ${e.message}',
          statusCode: e.response?.statusCode,
          error: e.response?.data,
        );
        AppLogger.error(
          'Erreur lors de la récupération des anticorps en ligne : $e',
        );
        return Left(error);
      }
    }

    if (_networkService.isOfflineSupported(feature)) {
      final antibodies = await _localStorage.getAntibodies(userId);
      if (antibodies != null) {
        final antibodyMaps = antibodies.map((model) => model.toJson()).toList();
        AppLogger.warning(
          'Anticorps récupérés hors ligne (données potentiellement non à jour) : ${antibodyMaps.length}',
        );
        return Right(antibodyMaps);
      }
    }

    return Left(ApiException('Données locales obsolètes.'));
  }

  /// Crée un nouvel anticorps.
  /// - Requiert une connexion réseau.
  /// - Enregistre l'opération pour synchronisation.
  Future<void> createAntibody(
    String name,
    String type,
    Map<String, dynamic> stats,
  ) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    final data = {'name': name, 'type': type, 'stats': stats};
    try {
      final response = await _dioClient.post(
        ApiEndpoints.createAntibody,
        data: data,
      );
      final antibodyModel = AntibodyModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _localStorage.saveAntibody(userId, antibodyModel);
      await _queueSyncOperation(userId, {
        'type': 'create_antibody',
        'data': response.data,
        'timestamp': DateTime.now().toIso8601String(),
      });
      AppLogger.info('Anticorps créé : $name');
    } on DioException catch (e) {
      AppLogger.error('Erreur lors de la création de l\'anticorps : $e');
      throw ApiException(
        'Échec de la création de l\'anticorps.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }

  /// Récupère un anticorps spécifique par ID.
  /// - En ligne : Appel API et mise en cache local.
  /// - Hors ligne : Retourne les données locales si disponibles.
  Future<Either<ApiException, Map<String, dynamic>>> getAntibody(
    String antibodyId,
  ) async {
    const feature = 'antibodies';
    final userId = _localStorage.getCurrentUserCache('current_user')?.id ?? '';

    if (await _networkService.isServerReachable()) {
      try {
        final response = await _dioClient.get(
          ApiEndpoints.getAntibody(antibodyId),
        );
        final antibodyModel = AntibodyModel.fromJson(
          response.data as Map<String, dynamic>,
        );
        await _localStorage.saveAntibody(userId, antibodyModel);
        await _queueSyncOperation(userId, {
          'type': 'get_antibody',
          'data': response.data,
          'timestamp': DateTime.now().toIso8601String(),
        });
        _lastSyncTime = DateTime.now();
        AppLogger.info('Anticorps récupéré en ligne : $antibodyId');
        return Right(response.data as Map<String, dynamic>);
      } on DioException catch (e) {
        final error = ApiException(
          'Échec de la récupération de l\'anticorps : ${e.message}',
          statusCode: e.response?.statusCode,
          error: e.response?.data,
        );
        AppLogger.error(
          'Erreur lors de la récupération de l\'anticorps en ligne : $e',
        );
        return Left(error);
      }
    }

    if (_networkService.isOfflineSupported(feature)) {
      final antibody = await _localStorage.getAntibody(userId, antibodyId);
      if (antibody != null) {
        AppLogger.warning(
          'Anticorps récupéré hors ligne (données potentiellement non à jour) : $antibodyId',
        );
        return Right(antibody.toJson());
      }
    }

    return Left(ApiException('Données locales obsolètes.'));
  }

  /// Récupère les anticorps par type.
  /// - En ligne : Appel API et mise en cache local.
  /// - Hors ligne : Retourne les données locales si disponibles.
  Future<Either<ApiException, List<dynamic>>> getAntibodiesByType(
    String type,
  ) async {
    const feature = 'antibodies';
    final userId = _localStorage.getCurrentUserCache('current_user')?.id ?? '';

    if (await _networkService.isServerReachable()) {
      try {
        final response = await _dioClient.get(
          ApiEndpoints.antibodiesByType(type),
        );
        final antibodies = response.data as List<dynamic>;
        for (final antibodyJson in antibodies) {
          final antibodyModel = AntibodyModel.fromJson(
            antibodyJson as Map<String, dynamic>,
          );
          await _localStorage.saveAntibody(userId, antibodyModel);
        }
        await _queueSyncOperation(userId, {
          'type': 'get_antibodies_by_type',
          'data': antibodies,
          'timestamp': DateTime.now().toIso8601String(),
        });
        _lastSyncTime = DateTime.now();
        AppLogger.info(
          'Anticorps de type $type récupérés en ligne : ${antibodies.length}',
        );
        return Right(antibodies);
      } on DioException catch (e) {
        final error = ApiException(
          'Échec de la récupération des anticorps par type : ${e.message}',
          statusCode: e.response?.statusCode,
          error: e.response?.data,
        );
        AppLogger.error(
          'Erreur lors de la récupération des anticorps par type en ligne : $e',
        );
        return Left(error);
      }
    }

    if (_networkService.isOfflineSupported(feature)) {
      final antibodies = await _localStorage.getAntibodiesByType(userId, type);
      if (antibodies != null) {
        final antibodyMaps = antibodies.map((model) => model.toJson()).toList();
        AppLogger.warning(
          'Anticorps de type $type récupérés hors ligne (données potentiellement non à jour) : ${antibodyMaps.length}',
        );
        return Right(antibodyMaps);
      }
    }

    return Left(ApiException('Données locales obsolètes.'));
  }

  /// Met à jour les statistiques d'un anticorps.
  /// - Requiert une connexion réseau.
  /// - Met à jour le cache local.
  Future<void> updateAntibodyStats(
    String antibodyId,
    Map<String, dynamic> stats,
  ) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    try {
      await _dioClient.put(
        ApiEndpoints.updateAntibodyStats(antibodyId),
        data: stats,
      );
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      final antibody = await _localStorage.getAntibody(userId, antibodyId);
      if (antibody != null) {
        final updatedModel = AntibodyModel.fromJson({
          ...antibody.toJson(),
          'stats': stats,
        });
        await _localStorage.saveAntibody(userId, updatedModel);
      }
      await _queueSyncOperation(userId, {
        'type': 'update_antibody_stats',
        'data': {'antibodyId': antibodyId, 'stats': stats},
        'timestamp': DateTime.now().toIso8601String(),
      });
      AppLogger.info('Statistiques de l\'anticorps mises à jour : $antibodyId');
    } on DioException catch (e) {
      AppLogger.error(
        'Erreur lors de la mise à jour des statistiques de l\'anticorps : $e',
      );
      throw ApiException(
        'Échec de la mise à jour des statistiques de l\'anticorps.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }

  /// Supprime un anticorps.
  /// - Requiert une connexion réseau.
  /// - Supprime également l'anticorps localement.
  Future<void> deleteAntibody(String antibodyId) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    try {
      await _dioClient.delete(ApiEndpoints.deleteAntibody(antibodyId));
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _localStorage.removeAntibody(userId, antibodyId);
      await _queueSyncOperation(userId, {
        'type': 'delete_antibody',
        'data': {'antibodyId': antibodyId},
        'timestamp': DateTime.now().toIso8601String(),
      });
      AppLogger.info('Anticorps supprimé : $antibodyId');
    } on DioException catch (e) {
      AppLogger.error('Erreur lors de la suppression de l\'anticorps : $e');
      throw ApiException(
        'Échec de la suppression de l\'anticorps.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }

  /// Assigne une capacité spéciale à un anticorps.
  /// - Requiert une connexion réseau.
  /// - Met à jour le cache local.
  Future<void> assignSpecialAbility(String antibodyId, String ability) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    try {
      await _dioClient.put(
        ApiEndpoints.assignSpecialAbility(antibodyId),
        data: {'ability': ability},
      );
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      final antibody = await _localStorage.getAntibody(userId, antibodyId);
      if (antibody != null) {
        final updatedModel = AntibodyModel.fromJson({
          ...antibody.toJson(),
          'specialAbility': ability,
        });
        await _localStorage.saveAntibody(userId, updatedModel);
      }
      await _queueSyncOperation(userId, {
        'type': 'assign_special_ability',
        'data': {'antibodyId': antibodyId, 'ability': ability},
        'timestamp': DateTime.now().toIso8601String(),
      });
      AppLogger.info('Capacité spéciale assignée à l\'anticorps : $antibodyId');
    } on DioException catch (e) {
      AppLogger.error(
        'Erreur lors de l\'assignation de la capacité spéciale : $e',
      );
      throw ApiException(
        'Échec de l\'assignation de la capacité spéciale.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }

  /// Simule l'effet d'un anticorps en combat.
  /// - Requiert une connexion réseau.
  /// - Enregistre l'opération pour synchronisation.
  Future<Either<ApiException, Map<String, dynamic>>> simulateCombatEffect(
    String antibodyId,
    Map<String, dynamic> target,
  ) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    try {
      final response = await _dioClient.post(
        ApiEndpoints.simulateCombatEffect(antibodyId),
        data: {'target': target},
      );
      final result = response.data as Map<String, dynamic>;
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _queueSyncOperation(userId, {
        'type': 'simulate_combat_effect',
        'data': {'antibodyId': antibodyId, 'target': target, 'result': result},
        'timestamp': DateTime.now().toIso8601String(),
      });
      AppLogger.info('Effet de combat simulé pour l\'anticorps : $antibodyId');
      return Right(result);
    } on DioException catch (e) {
      final error = ApiException(
        'Échec de la simulation de l\'effet de combat : ${e.message}',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
      AppLogger.error(
        'Erreur lors de la simulation de l\'effet de combat : $e',
      );
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
