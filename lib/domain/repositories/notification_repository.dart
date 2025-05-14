import 'package:immuno_warriors/domain/entities/notification.dart';

abstract class NotificationRepository {
  Future<List<Notification>> getNotifications(String userId);

  Future<void> createNotification(Notification notification);

  Future<void> deleteNotification(String id);

  Future<void> markNotificationAsRead(String id);
}