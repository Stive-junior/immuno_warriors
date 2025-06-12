import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:immuno_warriors/core/exceptions/app_exception.dart';
import 'package:immuno_warriors/core/exceptions/network_exceptions.dart';
import 'package:immuno_warriors/core/network/api_endpoints.dart';
import 'package:immuno_warriors/core/network/dio_client.dart';
import 'package:immuno_warriors/core/services/local_storage_service.dart';
import 'package:immuno_warriors/core/services/network_service.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/data/models/inventory_item_model.dart';
import 'package:immuno_warriors/data/models/user_model.dart';
import 'package:immuno_warriors/domain/entities/user_entity.dart';

/// Service pour gérer les opérations liées aux utilisateurs.
/// Supporte les modes en ligne et hors ligne avec synchronisation différée.
class UserService {
  final DioClient _dioClient;
  final LocalStorageService _localStorage;
  final NetworkService _networkService;
  DateTime? _lastSyncTime;

  UserService(this._dioClient, this._localStorage, this._networkService);

  /// Récupère le profil de l'utilisateur connecté.
  /// - En ligne : Appel API et mise en cache local.
  /// - Hors ligne : Retourne les données locales si disponibles.
  Future<Either<ApiException, UserEntity>> getUserProfile() async {
    const feature = 'user_profile';
    final userId = _localStorage.getCurrentUserCache('current_user')?.id ?? '';

    if (await _networkService.isServerReachable()) {
      try {
        final response = await _dioClient.get(ApiEndpoints.userProfile);
        final userModel = UserModel.fromJson(response.data);
        final userEntity = userModel.toEntity();
        await _localStorage.saveUser(userModel);
        await _queueSyncOperation(userId, {
          'type': 'get_profile',
          'data': response.data,
          'timestamp': DateTime.now().toIso8601String(),
        });
        _lastSyncTime = DateTime.now();
        AppLogger.info('Profil utilisateur récupéré en ligne : $userId');
        return Right(userEntity);
      } on DioException catch (e) {
        final error = ApiException(
          'Échec de la récupération du profil : ${e.message}',
          statusCode: e.response?.statusCode,
          error: e.response?.data,
        );
        AppLogger.error(
          'Erreur lors de la récupération du profil en ligne : $e',
        );
        return Left(error);
      }
    }

    if (_networkService.isOfflineSupported(feature)) {
      final localUser = _localStorage.getUser(userId);
      if (localUser != null) {
        AppLogger.warning(
          'Profil utilisateur récupéré hors ligne (données potentiellement non à jour) : $userId',
        );
        return Right(localUser.toEntity());
      }
    }

    return Left(ApiException('Données locales obsolètes.'));
  }

  /// Met à jour le profil de l'utilisateur (nom d'utilisateur ou avatar).
  /// - Requiert une connexion réseau.
  /// - Met à jour le cache local après succès.
  Future<void> updateUserProfile({String? username, String? avatar}) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    final data = <String, dynamic>{};
    if (username != null) data['username'] = username;
    if (avatar != null) data['avatar'] = avatar;

    try {
      await _dioClient.put(ApiEndpoints.updateUserProfile, data: data);
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      final user = _localStorage.getUser(userId);
      if (user != null) {
        final updatedUser = user.copyWith(username: username, avatar: avatar);
        await _localStorage.saveUser(updatedUser);
      }
      await _queueSyncOperation(userId, {
        'type': 'update_profile',
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
      });
      AppLogger.info('Profil utilisateur mis à jour : $userId');
    } on DioException catch (e) {
      AppLogger.error('Erreur lors de la mise à jour du profil : $e');
      throw ApiException(
        'Échec de la mise à jour du profil.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }

  /// Ajoute des ressources (crédits ou énergie) à l'utilisateur.
  /// - Requiert une connexion réseau.
  /// - Enregistre l'opération pour synchronisation.
  Future<void> addUserResources({int? credits, int? energy}) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    final data = <String, dynamic>{};
    if (credits != null) data['credits'] = credits;
    if (energy != null) data['energy'] = energy;

    try {
      await _dioClient.post(ApiEndpoints.addUserResources, data: data);
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _queueSyncOperation(userId, {
        'type': 'add_resources',
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
      });
      AppLogger.info('Ressources ajoutées pour l\'utilisateur : $userId');
    } on DioException catch (e) {
      AppLogger.error('Erreur lors de l\'ajout des ressources : $e');
      throw ApiException(
        'Échec de l\'ajout des ressources.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }

  /// Récupère les ressources de l'utilisateur (crédits, énergie, etc.).
  /// - En ligne : Appel API et mise en cache local.
  /// - Hors ligne : Retourne les données locales si disponibles.
  Future<Either<ApiException, Map<String, dynamic>>> getUserResources() async {
    const feature = 'user_profile';
    final userId = _localStorage.getCurrentUserCache('current_user')?.id ?? '';

    if (await _networkService.isServerReachable()) {
      try {
        final response = await _dioClient.get(ApiEndpoints.userResources);
        final resources = response.data as Map<String, dynamic>;
        final user = _localStorage.getUser(userId);
        if (user != null) {
          final updatedUser = user.copyWith(resources: resources);
          await _localStorage.saveUser(updatedUser);
        }
        await _queueSyncOperation(userId, {
          'type': 'get_resources',
          'data': resources,
          'timestamp': DateTime.now().toIso8601String(),
        });
        _lastSyncTime = DateTime.now();
        AppLogger.info('Ressources utilisateur récupérées en ligne : $userId');
        return Right(resources);
      } on DioException catch (e) {
        final error = ApiException(
          'Échec de la récupération des ressources : ${e.message}',
          statusCode: e.response?.statusCode,
          error: e.response?.data,
        );
        AppLogger.error(
          'Erreur lors de la récupération des ressources en ligne : $e',
        );
        return Left(error);
      }
    }

    if (_networkService.isOfflineSupported(feature)) {
      final user = _localStorage.getUser(userId);
      if (user!.resources != null) {
        AppLogger.warning(
          'Ressources utilisateur récupérées hors ligne (données potentiellement non à jour) : $userId',
        );
        return Right(user.resources!);
      }
    }

    return Left(ApiException('Données locales obsolètes.'));
  }

  /// Ajoute un élément à l'inventaire de l'utilisateur.
  /// - Requiert une connexion réseau.
  /// - Met à jour le cache local après succès.
  Future<void> addInventoryItem(
    String id,
    String type,
    String name,
    int quantity,
    Map<String, dynamic> properties,
  ) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    final item = InventoryItemModel(
      id: id,
      type: type,
      name: name,
      quantity: quantity,
      properties: properties,
    );

    try {
      await _dioClient.post(ApiEndpoints.addInventoryItem, data: item);
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _localStorage.saveInventoryItem(userId, item);
      await _queueSyncOperation(userId, {
        'type': 'add_inventory',
        'data': item,
        'timestamp': DateTime.now().toIso8601String(),
      });
      AppLogger.info('Élément ajouté à l\'inventaire : $id');
    } on DioException catch (e) {
      AppLogger.error(
        'Erreur lors de l\'ajout de l\'élément à l\'inventaire : $e',
      );
      throw ApiException(
        'Échec de l\'ajout de l\'élément à l\'inventaire.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }

  /// Supprime un élément de l'inventaire de l'utilisateur.
  /// - Requiert une connexion réseau.
  /// - Met à jour le cache local après succès.
  Future<void> removeInventoryItem(String itemId) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    try {
      await _dioClient.delete(ApiEndpoints.removeInventoryItem(itemId));
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _localStorage.removeInventoryItem(userId, itemId);
      await _queueSyncOperation(userId, {
        'type': 'remove_inventory',
        'data': {'itemId': itemId},
        'timestamp': DateTime.now().toIso8601String(),
      });
      AppLogger.info('Élément supprimé de l\'inventaire : $itemId');
    } on DioException catch (e) {
      AppLogger.error(
        'Erreur lors de la suppression de l\'élément de l\'inventaire : $e',
      );
      throw ApiException(
        'Échec de la suppression de l\'élément de l\'inventaire.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }

  /// Récupère l'inventaire de l'utilisateur.
  /// - En ligne : Appel API et mise en cache local via saveInventoryItem.
  /// - Hors ligne : Retourne les données locales si disponibles.
  Future<Either<ApiException, List<dynamic>>> getUserInventory() async {
    const feature = 'inventory';
    final userId = _localStorage.getCurrentUserCache('current_user')?.id ?? '';

    if (await _networkService.isServerReachable()) {
      try {
        final response = await _dioClient.get(ApiEndpoints.userInventory);
        final inventory = response.data as List<dynamic>;
        // Supprime l'inventaire existant pour éviter les doublons
        await _localStorage.removeInventoryItem(userId, 'all');
        // Sauvegarde chaque élément individuellement
        for (var item in inventory) {
          await _localStorage.saveInventoryItem(
            userId,
            item as InventoryItemModel,
          );
        }
        await _queueSyncOperation(userId, {
          'type': 'get_inventory',
          'data': inventory,
          'timestamp': DateTime.now().toIso8601String(),
        });
        _lastSyncTime = DateTime.now();
        AppLogger.info('Inventaire utilisateur récupéré en ligne : $userId');
        return Right(inventory);
      } on DioException catch (e) {
        final error = ApiException(
          'Échec de la récupération de l\'inventaire : ${e.message}',
          statusCode: e.response?.statusCode,
          error: e.response?.data,
        );
        AppLogger.error(
          'Erreur lors de la récupération de l\'inventaire en ligne : $e',
        );
        return Left(error);
      }
    }

    if (_networkService.isOfflineSupported(feature)) {
      final inventory = await _localStorage.getInventory(userId);
      if (inventory != null) {
        AppLogger.warning(
          'Inventaire utilisateur récupéré hors ligne (données potentiellement non à jour) : $userId',
        );
        return Right(inventory);
      }
    }

    return Left(ApiException('Données locales obsolètes.'));
  }

  /// Met à jour les paramètres de l'utilisateur (notifications, son, langue).
  /// - Requiert une connexion réseau.
  /// - Enregistre l'opération pour synchronisation.
  Future<void> updateUserSettings({
    bool? notifications,
    bool? sound,
    String? language,
  }) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    final data = <String, dynamic>{};
    if (notifications != null) data['notifications'] = notifications;
    if (sound != null) data['sound'] = sound;
    if (language != null) data['language'] = language;

    try {
      await _dioClient.put(ApiEndpoints.updateUserSettings, data: data);
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _queueSyncOperation(userId, {
        'type': 'update_settings',
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
      });
      AppLogger.info('Paramètres utilisateur mis à jour : $userId');
    } on DioException catch (e) {
      AppLogger.error('Erreur lors de la mise à jour des paramètres : $e');
      throw ApiException(
        'Échec de la mise à jour des paramètres.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }

  /// Récupère les paramètres de l'utilisateur.
  /// - En ligne : Appel API et enregistrement pour synchronisation.
  /// - Hors ligne : Retourne une erreur (paramètres non stockés localement).
  Future<Either<ApiException, Map<String, dynamic>>> getUserSettings() async {
    const feature = 'user_settings';
    final userId = _localStorage.getCurrentUserCache('current_user')?.id ?? '';

    if (await _networkService.isServerReachable()) {
      try {
        final response = await _dioClient.get(ApiEndpoints.userSettings);
        final settings = response.data as Map<String, dynamic>;
        await _queueSyncOperation(userId, {
          'type': 'get_settings',
          'data': settings,
          'timestamp': DateTime.now().toIso8601String(),
        });
        _lastSyncTime = DateTime.now();
        AppLogger.info('Paramètres utilisateur récupérés en ligne : $userId');
        return Right(settings);
      } on DioException catch (e) {
        final error = ApiException(
          'Échec de la récupération des paramètres : ${e.message}',
          statusCode: e.response?.statusCode,
          error: e.response?.data,
        );
        AppLogger.error(
          'Erreur lors de la récupération des paramètres en ligne : $e',
        );
        return Left(error);
      }
    }

    if (_networkService.isOfflineSupported(feature)) {
      // Note : Les paramètres ne sont pas stockés localement dans cet exemple.
      // Si vous souhaitez ajouter un stockage local, implémentez une méthode dans LocalStorageService.
      return Left(ApiException('Paramètres non disponibles hors ligne.'));
    }

    return Left(ApiException('Données locales obsolètes.'));
  }

  /// Supprime le compte de l'utilisateur.
  /// - Requiert une connexion réseau.
  /// - Nettoie le cache local après succès.
  Future<void> deleteUser() async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    try {
      await _dioClient.delete(ApiEndpoints.deleteUser);
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _localStorage.clearUser(userId);
      await _localStorage.clearCurrentUser(userId);
      await _localStorage.clearSession(userId);
      AppLogger.info('Compte utilisateur supprimé : $userId');
    } on DioException catch (e) {
      AppLogger.error('Erreur lors de la suppression du compte : $e');
      throw ApiException(
        'Échec de la suppression du compte.',
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
