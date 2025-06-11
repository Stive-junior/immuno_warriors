// Repository for managing notification-related operations in Immuno Warriors.
import 'package:dartz/dartz.dart';
import '../../domain/entities/notification.dart';
import '../../data/models/notification_model.dart';
import '../../core/exceptions/app_exception.dart';

abstract class NotificationRepository {
  /// Retrieves notifications for a user.
  Future<Either<AppException, List<Notification>>> getNotifications(
    String userId,
  );

  /// Creates a new notification.
  Future<Either<AppException, void>> createNotification(
    Notification notification,
  );

  /// Deletes a notification by ID.
  Future<Either<AppException, void>> deleteNotification(String id);

  /// Marks a notification as read.
  Future<Either<AppException, void>> markNotificationAsRead(String id);

  /// Retrieves notifications by type.
  Future<Either<AppException, List<Notification>>> getNotificationsByType(
    String userId,
    NotificationType type,
  );

  /// Marks multiple notifications as read.
  Future<Either<AppException, void>> markBatchNotificationsAsRead(
    List<String> ids,
  );

  /// Deletes multiple notifications.
  Future<Either<AppException, void>> deleteBatchNotifications(List<String> ids);

  /// Caches a notification locally.
  Future<Either<AppException, void>> cacheNotification(
    NotificationModel notification,
  );

  /// Retrieves cached notifications for a user.
  Future<Either<AppException, List<NotificationModel>>> getCachedNotifications(
    String userId,
  );

  /// Clears cached notifications.
  Future<Either<AppException, void>> clearCachedNotifications(String userId);
}
