import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:immuno_warriors/core/exceptions/app_exception.dart';
import 'package:immuno_warriors/core/exceptions/network_exceptions.dart';
import 'package:immuno_warriors/core/network/api_endpoints.dart';
import 'package:immuno_warriors/core/network/dio_client.dart';
import 'package:immuno_warriors/core/services/local_storage_service.dart';
import 'package:immuno_warriors/core/services/network_service.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/data/models/base_viral_model.dart';

/// Service pour gérer les opérations des bases virales.
/// Supporte les modes en ligne et hors ligne avec synchronisation différée.
class BaseViraleService {
  final DioClient _dioClient;
  final LocalStorageService _localStorage;
  final NetworkService _networkService;
  DateTime? _lastSyncTime;

  BaseViraleService(this._dioClient, this._localStorage, this._networkService);

  /// Crée une nouvelle base virale.
  /// - Requiert une connexion réseau.
  /// - Met en cache localement.
  Future<void> createBase(String name, Map<String, dynamic> location) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    final data = {'name': name, 'location': location};
    try {
      final response = await _dioClient.post(
        ApiEndpoints.createBase,
        data: data,
      );
      final baseModel = BaseViraleModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      final userId = _localStorage.getCurrentUserCache('userId')?.id ?? '';
      await _localStorage.saveBaseVirale(userId, baseModel);
      await _queueSyncOperation(userId, {
        'type': 'create_base_virale',
        'data': response.data,
        'timestamp': DateTime.now().toIso8601String(),
      });
      AppLogger.info('Base virale créée : $name}');
    } on DioException catch (e) {
      AppLogger.error('Erreur lors de la création de la base virale : $e');
      throw ApiException(
        'Échec de la création de la base virale.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }

  /// Récupère une base virale spécifique.
  /// - En ligne : collecte les données par API et met en cache.
  /// - Hors ligne : Retourne les données locales si disponibles.
  Future<Either<ApiException, Map<String, dynamic>>> getBase(
    String baseId,
  ) async {
    const feature = 'base_virale';
    final userId = _localStorage.getCurrentUserCache('userId')?.id ?? '';

    if (await _networkService.isServerReachable()) {
      try {
        final response = await _dioClient.get(ApiEndpoints.getBase(baseId));
        final baseModel = BaseViraleModel.fromJson(
          response.data as Map<String, dynamic>,
        );
        await _localStorage.saveBaseVirale(userId, baseModel);
        await _queueSyncOperation(userId, {
          'type': 'get_base_virale',
          'data': response.data,
          'timestamp': DateTime.now().toIso8601String(),
        });
        _lastSyncTime = DateTime.now();
        AppLogger.info('Base virale récupérée : $baseId');
        return Right(response.data as Map<String, dynamic>);
      } on DioException catch (e) {
        final error = ApiException(
          'Échec de la récupération de la base virale : ${e.message}',
          statusCode: e.response?.statusCode,
          error: e.response?.data,
        );
        AppLogger.error(
          'Erreur lors de la récupération de la base virale en ligne : $e',
        );
        return Left(error);
      }
    }

    if (_networkService.isOfflineSupported(feature)) {
      final base = await _localStorage.getBaseVirale(userId, baseId);
      if (base != null) {
        AppLogger.warning(
          'Base virale récupérée hors ligne (données potentiellement non à jour) : $baseId',
        );
        return Right(base.toJson());
      }
    }

    return Left(ApiException('Données locales obsolètes.'));
  }

  /// Récupère toutes les bases virales du joueur.
  /// - En ligne : collecte les données par API et met en cache.
  /// - Hors ligne : Retourne les données locales si disponibles.
  Future<Either<ApiException, List<dynamic>>> getPlayerBases() async {
    const feature = 'base_virale';
    final userId = _localStorage.getCurrentUserCache('userId')?.id ?? '';

    if (await _networkService.isServerReachable()) {
      try {
        final response = await _dioClient.get(ApiEndpoints.getPlayerBases);
        final bases = response.data as List<dynamic>;
        for (final base in bases) {
          final baseModel = BaseViraleModel.fromJson(
            base as Map<String, dynamic>,
          );
          await _localStorage.saveBaseVirale(userId, baseModel);
        }
        await _queueSyncOperation(userId, {
          'type': 'get_player_bases',
          'data': bases,
          'timestamp': DateTime.now().toIso8601String(),
        });
        _lastSyncTime = DateTime.now();
        AppLogger.info('Bases du joueur récupérées en ligne : ${bases.length}');
        return Right(bases);
      } on DioException catch (e) {
        final error = ApiException(
          'Échec de la récupération des bases du joueur : ${e.message}',
          statusCode: e.response?.statusCode,
          error: e.response?.data,
        );
        AppLogger.error(
          'Erreur lors de la récupération des bases du joueur : $e',
        );
        return Left(error);
      }
    }

    if (_networkService.isOfflineSupported(feature)) {
      final bases = await _localStorage.getAllBasesVirales(userId);
      if (bases.isNotEmpty) {
        AppLogger.warning(
          'Bases du joueur récupérées hors ligne (données potentiellement non à jour) : ${bases.length}',
        );
        return Right(bases.map((base) => base.toJson()).toList());
      }
    }

    return Left(ApiException('Données locales obsolètes.'));
  }

  /// Récupère toutes les bases virales.
  /// - En ligne : collecte les données par API.
  /// - Hors ligne : Retourne les données locales si disponibles.
  Future<Either<ApiException, List<dynamic>>> getAllBases() async {
    const feature = 'base_virale';
    final userId = _localStorage.getCurrentUserCache('userId')?.id ?? '';

    if (await _networkService.isServerReachable()) {
      try {
        final response = await _dioClient.get(ApiEndpoints.getAllBases);
        final bases = response.data as List<dynamic>;
        await _queueSyncOperation(userId, {
          'type': 'get_all_bases',
          'data': bases,
          'timestamp': DateTime.now().toIso8601String(),
        });
        _lastSyncTime = DateTime.now();
        AppLogger.info(
          'Toutes les bases virales récupérées en ligne : ${bases.length}',
        );
        return Right(bases);
      } on DioException catch (e) {
        final error = ApiException(
          'Échec de la récupération de toutes les bases virales : ${e.message}',
          statusCode: e.response?.statusCode,
          error: e.response?.data,
        );
        AppLogger.error(
          'Erreur lors de la récupération de toutes les bases virales : $e',
        );
        return Left(error);
      }
    }

    if (_networkService.isOfflineSupported(feature)) {
      final bases = await _localStorage.getAllBasesVirales(userId);
      if (bases.isNotEmpty) {
        AppLogger.warning(
          'Toutes les bases virales récupérées hors ligne (données potentiellement non à jour) : ${bases.length}',
        );
        return Right(bases.map((base) => base.toJson()).toList());
      }
    }

    return Left(ApiException('Données locales obsolètes.'));
  }

  /// Met à jour une base virale.
  /// - Requiert une connexion réseau.
  /// - Met à jour le cache local.
  Future<void> updateBase(
    String baseId, {
    String? name,
    Map<String, dynamic>? location,
  }) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (location != null) data['location'] = location;

    try {
      await _dioClient.put(ApiEndpoints.updateBase(baseId), data: data);
      final userId = _localStorage.getCurrentUserCache('userId')?.id ?? '';
      final base = await _localStorage.getBaseVirale(userId, baseId);
      if (base != null) {
        final updatedJson = {...base.toJson(), ...data};
        final updatedModel = BaseViraleModel.fromJson(updatedJson);
        await _localStorage.saveBaseVirale(userId, updatedModel);
      }
      await _queueSyncOperation(userId, {
        'type': 'update_base_virale',
        'data': {'baseId': baseId, ...data},
        'timestamp': DateTime.now().toIso8601String(),
      });
      AppLogger.info('Base virale mise à jour : $baseId');
    } on DioException catch (e) {
      AppLogger.error('Erreur lors de la mise à jour de la base virale : $e');
      throw ApiException(
        'Échec de la mise à jour de la base virale.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }

  /// Supprime une base virale.
  /// - Requiert une connexion réseau.
  /// - Supprime également localement.
  Future<void> deleteBase(String baseId) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    try {
      await _dioClient.delete(ApiEndpoints.deleteBase(baseId));
      final userId = _localStorage.getCurrentUserCache('userId')?.id ?? '';
      await _localStorage.clearBasesVirales(userId);
      await _queueSyncOperation(userId, {
        'type': 'delete_base_virale',
        'data': {'baseId': baseId},
        'timestamp': DateTime.now().toIso8601String(),
      });
      AppLogger.info('Base virale supprimée : $baseId');
    } on DioException catch (e) {
      AppLogger.error('Erreur lors de la suppression de la base virale : $e');
      throw ApiException(
        'Échec de la suppression de la base virale.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }

  /// Ajoute un pathogène à une base virale.
  /// - Requiert une connexion réseau.
  /// - Met à jour le cache local.
  Future<void> addPathogen(String baseId, String pathogenId) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    try {
      await _dioClient.post(
        ApiEndpoints.addPathogen(baseId),
        data: {'pathogenId': pathogenId},
      );
      final userId = _localStorage.getCurrentUserCache('userId')?.id ?? '';
      await _queueSyncOperation(userId, {
        'type': 'add_pathogen',
        'data': {'baseId': baseId, 'pathogenId': pathogenId},
        'timestamp': DateTime.now().toIso8601String(),
      });
      AppLogger.info('Pathogène ajouté à la base virale : $baseId');
    } on DioException catch (e) {
      AppLogger.error('Erreur lors de l\'ajout du pathogène : $e');
      throw ApiException(
        'Échec de l\'ajout du pathogène.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }

  /// Supprime un pathogène d'une base virale.
  /// - Requiert une connexion réseau.
  /// - Met à jour le cache local.
  Future<void> removePathogen(String baseId, String pathogenId) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    try {
      await _dioClient.delete(
        ApiEndpoints.removePathogen(baseId),
        data: {'pathogenId': pathogenId},
      );
      final userId = _localStorage.getCurrentUserCache('userId')?.id ?? '';
      await _queueSyncOperation(userId, {
        'type': 'remove_pathogen',
        'data': {'baseId': baseId, 'pathogenId': pathogenId},
        'timestamp': DateTime.now().toIso8601String(),
      });
      AppLogger.info('Pathogène supprimé de la base virale : $baseId');
    } on DioException catch (e) {
      AppLogger.error('Erreur lors de la suppression du pathogène : $e');
      throw ApiException(
        'Échec de la suppression du pathogène.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }

  /// Met à jour les défenses d'une base virale.
  /// - Requiert une connexion réseau.
  /// - Met à jour le cache local.
  Future<void> updateDefenses(
    String baseId,
    Map<String, dynamic> defenses,
  ) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    try {
      await _dioClient.put(
        ApiEndpoints.updateDefenses(baseId),
        data: {'defenses': defenses},
      );
      final userId = _localStorage.getCurrentUserCache('userId')?.id ?? '';
      final base = await _localStorage.getBaseVirale(userId, baseId);
      if (base != null) {
        final updatedJson = {...base.toJson(), 'defenses': defenses};
        final updatedModel = BaseViraleModel.fromJson(updatedJson);
        await _localStorage.saveBaseVirale(userId, updatedModel);
      }
      await _queueSyncOperation(userId, {
        'type': 'update_defenses',
        'data': {'baseId': baseId, 'defenses': defenses},
        'timestamp': DateTime.now().toIso8601String(),
      });
      AppLogger.info('Défenses de la base virale mises à jour : $baseId');
    } on DioException catch (e) {
      AppLogger.error('Erreur lors de la mise à jour des défenses : $e');
      throw ApiException(
        'Échec de la mise à jour des défenses.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }

  /// Augmente le niveau d'une base virale.
  /// - Requiert une connexion réseau.
  /// - Met à jour le cache local.
  Future<void> levelUpBase(String baseId) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    try {
      await _dioClient.post(ApiEndpoints.levelUpBase(baseId));
      final userId = _localStorage.getCurrentUserCache('userId')?.id ?? '';
      final base = await _localStorage.getBaseVirale(userId, baseId);
      if (base != null) {
        final updatedJson = {...base.toJson(), 'level': (base.level + 1)};
        final updatedModel = BaseViraleModel.fromJson(updatedJson);
        await _localStorage.saveBaseVirale(userId, updatedModel);
      }
      await _queueSyncOperation(userId, {
        'type': 'level_up_base',
        'data': {'baseId': baseId},
        'timestamp': DateTime.now().toIso8601String(),
      });
      AppLogger.info('Niveau de la base virale augmenté : $baseId');
    } on DioException catch (e) {
      AppLogger.error(
        'Erreur lors de l\'augmentation du niveau de la base : $e',
      );
      throw ApiException(
        'Échec de l\'augmentation du niveau de la base.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }

  /// Valide une base pour le combat.
  /// - En ligne : Appel API.
  /// - Hors ligne : Non supporté.
  Future<Either<ApiException, Map<String, dynamic>>> validateForCombat(
    String baseId,
  ) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    try {
      final response = await _dioClient.get(
        ApiEndpoints.validateForCombat(baseId),
      );
      final result = response.data as Map<String, dynamic>;
      final userId = _localStorage.getCurrentUserCache('userId')?.id ?? '';
      await _queueSyncOperation(userId, {
        'type': 'validate_for_combat',
        'data': {'baseId': baseId, 'result': result},
        'timestamp': DateTime.now().toIso8601String(),
      });
      AppLogger.info('Validation pour le combat effectuée : $baseId');
      return Right(result);
    } on DioException catch (e) {
      final error = ApiException(
        'Échec de la validation pour le combat : ${e.message}',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
      AppLogger.error('Erreur lors de la validation pour le combat : $e');
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
