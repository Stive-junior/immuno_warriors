import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:immuno_warriors/core/exceptions/app_exception.dart';
import 'package:immuno_warriors/core/exceptions/network_exceptions.dart';
import 'package:uuid/uuid.dart';
import 'package:immuno_warriors/core/network/api_endpoints.dart';
import 'package:immuno_warriors/core/network/dio_client.dart';
import 'package:immuno_warriors/core/services/local_storage_service.dart';
import 'package:immuno_warriors/core/services/network_service.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/data/models/inventory_item_model.dart';

/// Service pour gérer l'inventaire des utilisateurs.
/// Supporte le stockage local et l'accès hors ligne.
class InventoryService {
  final DioClient _dioClient;
  final LocalStorageService _localStorage;
  final NetworkService _networkService;
  DateTime? _lastSyncTime;

  InventoryService(this._dioClient, this._localStorage, this._networkService);

  /// Ajoute un élément à l'inventaire.
  /// - En ligne : Envoie au serveur et met en cache.
  /// - Hors ligne : Non supporté (requiert une connexion).
  Future<Either<ApiException, InventoryItemModel>> addInventoryItem(
    InventoryItemModel item,
  ) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    try {
      // Valider l'UUID
      if (!Uuid.isValidUUID(fromString: item.id)) {
        throw ApiException(
          'ID d\'élément invalide : doit être un UUID valide.',
        );
      }
      // Valider la quantité
      if (item.quantity < 0) {
        throw ApiException('La quantité doit être supérieure ou égale à 0.');
      }

      final response = await _dioClient.post(
        ApiEndpoints.addInventory,
        data: item.toJson(),
      );
      final responseData = response.data['data'] as Map<String, dynamic>;
      final newItem = InventoryItemModel.fromJson(responseData);
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _localStorage.saveInventoryItem(userId, newItem);
      await _queueSyncOperation(userId, {
        'type': 'add_inventory_item',
        'data': newItem.toJson(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      _lastSyncTime = DateTime.now();
      AppLogger.info('Élément d\'inventaire ajouté : ${newItem.id}');
      return Right(newItem);
    } on DioException catch (e) {
      final error = ApiException(
        'Échec de l\'ajout de l\'élément d\'inventaire : ${e.message}',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
      AppLogger.error(
        'Erreur lors de l\'ajout de l\'élément d\'inventaire : $e',
      );
      return Left(error);
    }
  }

  /// Récupère un élément spécifique de l'inventaire.
  /// - En ligne : Récupère depuis le serveur et met en cache.
  /// - Hors ligne : Retourne l'élément local si disponible.
  Future<Either<ApiException, InventoryItemModel>> getInventoryItem(
    String itemId,
  ) async {
    const feature = 'inventory';
    final userId = _localStorage.getCurrentUserCache('current_user')?.id ?? '';

    if (!Uuid.isValidUUID(fromString: itemId)) {
      return Left(
        ApiException('ID d\'élément invalide : doit être un UUID valide.'),
      );
    }

    if (await _networkService.isServerReachable()) {
      try {
        final response = await _dioClient.get(
          ApiEndpoints.getInventoryItem(itemId),
        );
        final responseData = response.data['data'] as Map<String, dynamic>;
        final item = InventoryItemModel.fromJson(responseData);
        await _localStorage.saveInventoryItem(userId, item);
        await _queueSyncOperation(userId, {
          'type': 'get_inventory_item',
          'data': item.toJson(),
          'timestamp': DateTime.now().toIso8601String(),
        });
        _lastSyncTime = DateTime.now();
        AppLogger.info('Élément d\'inventaire récupéré : $itemId');
        return Right(item);
      } on DioException catch (e) {
        final error = ApiException(
          'Échec de la récupération de l\'élément d\'inventaire : ${e.message}',
          statusCode: e.response?.statusCode,
          error: e.response?.data,
        );
        AppLogger.error(
          'Erreur lors de la récupération de l\'élément d\'inventaire : $e',
        );
        return Left(error);
      } catch (e) {
        AppLogger.error(
          'Erreur inattendue lors de la récupération de l\'élément : $e',
        );
        return Left(ApiException('Erreur inattendue : $e'));
      }
    }

    if (_networkService.isOfflineSupported(feature)) {
      try {
        final inventory = await _localStorage.getInventory(userId);
        if (inventory!.isNotEmpty) {
          final item = inventory.firstWhere(
            (i) => i.id == itemId,
            orElse: () => throw Exception('Élément non trouvé'),
          );
          AppLogger.warning(
            'Élément d\'inventaire récupéré hors ligne (données potentiellement non à jour) : $itemId',
          );
          return Right(item);
        }
      } catch (e) {
        AppLogger.error(
          'Erreur lors de la récupération de l\'élément hors ligne : $e',
        );
        return Left(
          ApiException('Élément non trouvé ou données locales obsolètes.'),
        );
      }
    }

    return Left(
      ApiException('Élément non trouvé ou données locales obsolètes.'),
    );
  }

  /// Récupère l'inventaire complet de l'utilisateur.
  /// - En ligne : Récupère depuis le serveur et met en cache.
  /// - Hors ligne : Retourne l'inventaire local si disponible.
  Future<Either<ApiException, List<InventoryItemModel>>>
  getUserInventory() async {
    const feature = 'inventory';
    final userId = _localStorage.getCurrentUserCache('current_user')?.id ?? '';

    if (await _networkService.isServerReachable()) {
      try {
        final response = await _dioClient.get(ApiEndpoints.getUserInventory);
        final responseData = response.data['data'] as List<dynamic>;
        final inventory =
            responseData
                .map((item) => InventoryItemModel.fromJson(item))
                .toList();
        await _localStorage.saveInventory(
          userId,
          inventory.map((item) => item).toList(),
        );
        await _queueSyncOperation(userId, {
          'type': 'get_user_inventory',
          'data': inventory.map((item) => item.toJson()).toList(),
          'timestamp': DateTime.now().toIso8601String(),
        });
        _lastSyncTime = DateTime.now();
        AppLogger.info(
          'Inventaire utilisateur récupéré : ${inventory.length} éléments',
        );
        return Right(inventory);
      } on DioException catch (e) {
        final error = ApiException(
          'Échec de la récupération de l\'inventaire : ${e.message}',
          statusCode: e.response?.statusCode,
          error: e.response?.data,
        );
        AppLogger.error('Erreur lors de la récupération de l\'inventaire : $e');
        return Left(error);
      }
    }

    if (_networkService.isOfflineSupported(feature)) {
      final inventory = await _localStorage.getInventory(userId);
      if (inventory != null && inventory.isNotEmpty) {
        AppLogger.warning(
          'Inventaire utilisateur récupéré hors ligne (données potentiellement non à jour) : ${inventory.length} éléments',
        );
        return Right(inventory.map((item) => item).toList());
      }
    }

    return Left(
      ApiException('Inventaire non trouvé ou données locales obsolètes.'),
    );
  }

  /// Met à jour un élément de l'inventaire.
  /// - En ligne : Envoie les mises à jour au serveur et met en cache.
  /// - Hors ligne : Non supporté (requiert une connexion).
  Future<Either<ApiException, InventoryItemModel>> updateInventoryItem(
    String itemId,
    Map<String, dynamic> updates,
  ) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    if (!Uuid.isValidUUID(fromString: itemId)) {
      return Left(
        ApiException('ID d\'élément invalide : doit être un UUID valide.'),
      );
    }

    // Valider les mises à jour
    if (updates.containsKey('quantity') && (updates['quantity'] as int) < 0) {
      return Left(
        ApiException('La quantité doit être supérieure ou égale à 0.'),
      );
    }
    if (updates.isEmpty ||
        !updates.keys.every((key) => ['name', 'quantity'].contains(key))) {
      return Left(
        ApiException(
          'Mises à jour invalides : seules name et quantity sont autorisées.',
        ),
      );
    }

    try {
      final response = await _dioClient.put(
        ApiEndpoints.updateInventoryItem(itemId),
        data: updates,
      );
      final responseData = response.data['data'] as Map<String, dynamic>;
      final updatedItem = InventoryItemModel.fromJson({
        'id': itemId,
        'type': responseData['type'] ?? '',
        'name': responseData['name'] ?? '',
        'quantity': responseData['quantity'] ?? 0,
        'properties': responseData['properties'] ?? {},
      });
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _localStorage.removeInventoryItem(userId, itemId);
      await _localStorage.saveInventoryItem(userId, updatedItem);
      await _queueSyncOperation(userId, {
        'type': 'update_inventory_item',
        'data': updatedItem.toJson(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      _lastSyncTime = DateTime.now();
      AppLogger.info('Élément d\'inventaire mis à jour : $itemId');
      return Right(updatedItem);
    } on DioException catch (e) {
      final error = ApiException(
        'Échec de la mise à jour de l\'élément d\'inventaire : ${e.message}',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
      AppLogger.error(
        'Erreur lors de la mise à jour de l\'élément d\'inventaire : $e',
      );
      return Left(error);
    }
  }

  /// Supprime un élément de l'inventaire.
  /// - En ligne : Supprime sur le serveur et met à jour le cache.
  /// - Hors ligne : Non supporté (requiert une connexion).
  Future<void> deleteInventoryItem(String itemId) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    if (!Uuid.isValidUUID(fromString: itemId)) {
      throw Exception('ID d\'élément invalide : doit être un UUID valide.');
    }

    try {
      await _dioClient.delete(ApiEndpoints.deleteInventoryItem(itemId));
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _localStorage.removeInventoryItem(userId, itemId);
      await _queueSyncOperation(userId, {
        'type': 'delete_inventory_item',
        'data': {'itemId': itemId},
        'timestamp': DateTime.now().toIso8601String(),
      });
      _lastSyncTime = DateTime.now();
      AppLogger.info('Élément d\'inventaire supprimé : $itemId');
    } catch (e) {
      AppLogger.error(
        'Erreur lors de la suppression de l\'élément d\'inventaire : $e',
      );
      throw Exception(
        'Échec de la suppression de l\'élément d\'inventaire : ${e.toString()}',
      );
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
