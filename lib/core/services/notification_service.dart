import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:immuno_warriors/core/exceptions/app_exception.dart';
import 'package:uuid/uuid.dart';
import 'package:immuno_warriors/core/network/api_endpoints.dart';
import 'package:immuno_warriors/core/network/dio_client.dart';
import 'package:immuno_warriors/core/services/local_storage_service.dart';
import 'package:immuno_warriors/core/services/network_service.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/data/models/notification_model.dart';

class NotificationService {
  final DioClient _dioClient;
  final LocalStorageService _localStorage;
  final NetworkService _networkService;

  NotificationService(
    this._dioClient,
    this._localStorage,
    this._networkService,
  );

  Future<Either<ApiException, NotificationModel>> createNotification({
    required String message,
    required String type,
  }) async {
    try {
      if (!await _networkService.isServerReachable()) {
        return Left(ApiException('Aucune connexion Internet disponible.'));
      }

      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      if (!Uuid.isValidUUID(fromString: userId)) {
        return Left(ApiException('ID d\'utilisateur invalide.'));
      }

      final response = await _dioClient.post(
        ApiEndpoints.createNotification,
        data: {'message': message, 'type': type},
      );
      if (response.data['data'] is! Map<String, dynamic>) {
        return Left(
          ApiException(
            'Format de réponse invalide pour la création de notification.',
          ),
        );
      }
      final notification = NotificationModel.fromJson(response.data['data']);
      await _localStorage.saveNotification(userId, notification);
      AppLogger.info('Notification créée pour l\'utilisateur $userId');
      return Right(notification);
    } on DioException catch (e) {
      final error = ApiException(
        'Échec de la création de la notification : ${e.message}',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
      AppLogger.error('Erreur lors de la création de la notification : $e');
      return Left(error);
    } catch (e) {
      AppLogger.error(
        'Erreur inattendue lors de la création de la notification : $e',
      );
      return Left(ApiException('Erreur inattendue : $e'));
    }
  }

  Future<Either<ApiException, List<NotificationModel>>> getUserNotifications({
    int page = 1,
    int limit = 10,
  }) async {
    const feature = 'notifications';
    final userId = _localStorage.getCurrentUserCache('current_user')?.id ?? '';

    if (await _networkService.isServerReachable()) {
      try {
        if (!Uuid.isValidUUID(fromString: userId)) {
          return Left(ApiException('ID d\'utilisateur invalide.'));
        }

        final response = await _dioClient.get(
          ApiEndpoints.getNotifications,
          queryParameters: {'page': page, 'limit': limit},
        );
        if (response.data['data'] is! List) {
          return Left(
            ApiException('Format de réponse invalide pour les notifications.'),
          );
        }
        final notifications =
            (response.data['data'] as List)
                .map((json) => NotificationModel.fromJson(json))
                .toList();
        await _localStorage.saveNotifications(userId, notifications);
        AppLogger.info(
          'Notifications récupérées pour l\'utilisateur $userId : ${notifications.length}',
        );
        return Right(notifications);
      } on DioException catch (e) {
        final error = ApiException(
          'Échec de la récupération des notifications : ${e.message}',
          statusCode: e.response?.statusCode,
          error: e.response?.data,
        );
        AppLogger.error(
          'Erreur lors de la récupération des notifications : $e',
        );
        return Left(error);
      } catch (e) {
        AppLogger.error(
          'Erreur inattendue lors de la récupération des notifications : $e',
        );
        return Left(ApiException('Erreur inattendue : $e'));
      }
    }

    if (_networkService.isOfflineSupported(feature)) {
      try {
        if (!Uuid.isValidUUID(fromString: userId)) {
          return Left(ApiException('ID d\'utilisateur invalide.'));
        }
        final notifications =
            await _localStorage.getNotifications(userId) ?? [];
        AppLogger.warning(
          'Notifications récupérées hors ligne (données potentiellement non à jour) : ${notifications.length}',
        );
        return Right(
          notifications.skip((page - 1) * limit).take(limit).toList(),
        );
      } catch (e) {
        AppLogger.error(
          'Erreur lors de la récupération des notifications hors ligne : $e',
        );
        return Left(
          ApiException(
            'Erreur lors de la récupération des données locales : $e',
          ),
        );
      }
    }

    return Left(
      ApiException('Notifications non trouvées ou données locales obsolètes.'),
    );
  }

  Future<Either<ApiException, void>> markAsNotificationRead(
    String notificationId,
  ) async {
    try {
      if (!await _networkService.isServerReachable()) {
        return Left(ApiException('Aucune connexion Internet disponible.'));
      }

      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      if (!Uuid.isValidUUID(fromString: userId) ||
          !Uuid.isValidUUID(fromString: notificationId)) {
        return Left(ApiException('ID invalide (utilisateur ou notification).'));
      }

      await _dioClient.put(ApiEndpoints.markNotificationAsRead(notificationId));
      final notifications = await _localStorage.getNotifications(userId) ?? [];
      final updatedNotifications =
          notifications.map((n) {
            if (n.id == notificationId) {
              return n.copyWith(isRead: true);
            }
            return n;
          }).toList();
      await _localStorage.saveNotifications(userId, updatedNotifications);
      AppLogger.info('Notification $notificationId marquée comme lue');
      return const Right(null);
    } on DioException catch (e) {
      final error = ApiException(
        'Échec du marquage de la notification : ${e.message}',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
      AppLogger.error('Erreur lors du marquage de la notification : $e');
      return Left(error);
    } catch (e) {
      AppLogger.error(
        'Erreur inattendue lors du marquage de la notification : $e',
      );
      return Left(ApiException('Erreur inattendue : $e'));
    }
  }

  Future<Either<ApiException, void>> markBatchAsNotificationsRead(
    List<String> notificationIds,
  ) async {
    try {
      if (!await _networkService.isServerReachable()) {
        return Left(ApiException('Aucune connexion Internet disponible.'));
      }

      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      if (!Uuid.isValidUUID(fromString: userId)) {
        return Left(ApiException('ID d\'utilisateur invalide.'));
      }
      for (final id in notificationIds) {
        if (!Uuid.isValidUUID(fromString: id)) {
          return Left(ApiException('ID de notification invalide : $id'));
        }
      }

      await _dioClient.put(
        ApiEndpoints.markBatchNotificationsAsRead,
        data: {'notificationIds': notificationIds},
      );
      final notifications = await _localStorage.getNotifications(userId) ?? [];
      final updatedNotifications =
          notifications.map((n) {
            if (notificationIds.contains(n.id)) {
              return n.copyWith(isRead: true);
            }
            return n;
          }).toList();
      await _localStorage.saveNotifications(userId, updatedNotifications);
      AppLogger.info(
        '${notificationIds.length} notifications marquées comme lues',
      );
      return const Right(null);
    } on DioException catch (e) {
      final error = ApiException(
        'Échec du marquage des notifications : ${e.message}',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
      AppLogger.error('Erreur lors du marquage des notifications : $e');
      return Left(error);
    } catch (e) {
      AppLogger.error(
        'Erreur inattendue lors du marquage des notifications : $e',
      );
      return Left(ApiException('Erreur inattendue : $e'));
    }
  }

  Future<Either<ApiException, void>> deleteUserNotification(
    String notificationId,
  ) async {
    try {
      if (!await _networkService.isServerReachable()) {
        return Left(ApiException('Aucune connexion Internet disponible.'));
      }

      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      if (!Uuid.isValidUUID(fromString: userId) ||
          !Uuid.isValidUUID(fromString: notificationId)) {
        return Left(ApiException('ID invalide (utilisateur ou notification).'));
      }

      await _dioClient.delete(ApiEndpoints.deleteNotification(notificationId));
      await _localStorage.removeNotification(userId, notificationId);
      AppLogger.info('Notification $notificationId supprimée');
      return const Right(null);
    } on DioException catch (e) {
      final error = ApiException(
        'Échec de la suppression de la notification : ${e.message}',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
      AppLogger.error('Erreur lors de la suppression de la notification : $e');
      return Left(error);
    } catch (e) {
      AppLogger.error(
        'Erreur inattendue lors de la suppression de la notification : $e',
      );
      return Left(ApiException('Erreur inattendue : $e'));
    }
  }

  Future<Either<ApiException, void>> deleteBatchNotifications(
    List<String> notificationIds,
  ) async {
    try {
      if (!await _networkService.isServerReachable()) {
        return Left(ApiException('Aucune connexion Internet disponible.'));
      }

      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      if (!Uuid.isValidUUID(fromString: userId)) {
        return Left(ApiException('ID d\'utilisateur invalide.'));
      }
      for (final id in notificationIds) {
        if (!Uuid.isValidUUID(fromString: id)) {
          return Left(ApiException('ID de notification invalide : $id'));
        }
      }

      await _dioClient.delete(
        ApiEndpoints.deleteBatchNotifications,
        data: {'notificationIds': notificationIds},
      );
      final notifications = await _localStorage.getNotifications(userId) ?? [];
      final updated =
          notifications.where((n) => !notificationIds.contains(n.id)).toList();
      await _localStorage.saveNotifications(userId, updated);
      AppLogger.info('${notificationIds.length} notifications supprimées');
      return const Right(null);
    } on DioException catch (e) {
      final error = ApiException(
        'Échec de la suppression des notifications : ${e.message}',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
      AppLogger.error('Erreur lors de la suppression des notifications : $e');
      return Left(error);
    } catch (e) {
      AppLogger.error(
        'Erreur inattendue lors de la suppression des notifications : $e',
      );
      return Left(ApiException('Erreur inattendue : $e'));
    }
  }
}
