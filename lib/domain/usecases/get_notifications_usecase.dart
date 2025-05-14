import 'package:immuno_warriors/domain/entities/notification.dart';
import 'package:immuno_warriors/domain/repositories/notification_repository.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

class GetNotificationsUseCase {
  final NotificationRepository _notificationRepository;

  GetNotificationsUseCase(this._notificationRepository);

  Future<List<Notification>> execute(String userId) async {
    try {
      return await _notificationRepository.getNotifications(userId);
    } catch (e) {
      AppLogger.error('Error getting notifications: $e');
      rethrow;
    }
  }
}