import 'package:hive/hive.dart';
import 'package:immuno_warriors/domain/entities/notification.dart';
import 'package:immuno_warriors/domain/repositories/notification_repository.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final Box<Notification> _notificationBox;

  NotificationRepositoryImpl(this._notificationBox);

  @override
  Future<List<Notification>> getNotifications(String userId) async {
    try {
      return _notificationBox.values
          .where((notification) => notification.userId == userId)
          .toList();
    } catch (e) {
      AppLogger.error('Error getting notifications: $e');
      rethrow;
    }
  }

  @override
  Future<void> createNotification(Notification notification) async {
    try {
      await _notificationBox.put(notification.id, notification);
    } catch (e) {
      AppLogger.error('Error creating notification: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteNotification(String id) async {
    try {
      await _notificationBox.delete(id);
    } catch (e) {
      AppLogger.error('Error deleting notification: $e');
      rethrow;
    }
  }

  @override
  Future<void> markNotificationAsRead(String id) async {
    try {
      final notification = _notificationBox.get(id);
      if (notification != null) {
        final updatedNotification = Notification(
          id: notification.id,
          userId: notification.userId,
          message: notification.message,
          timestamp: notification.timestamp,
          isRead: true,
        );
        await _notificationBox.put(id, updatedNotification);
      }
    } catch (e) {
      AppLogger.error('Error marking notification as read: $e');
      rethrow;
    }
  }
}