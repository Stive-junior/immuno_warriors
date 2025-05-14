import 'package:immuno_warriors/domain/repositories/notification_repository.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

class MarkNotificationAsReadUseCase {
  final NotificationRepository _notificationRepository;

  MarkNotificationAsReadUseCase(this._notificationRepository);

  Future<void> execute(String id) async {
    try {
      await _notificationRepository.markNotificationAsRead(id);
    } catch (e) {
      AppLogger.error('Error marking notification as read: $e');
      rethrow;
    }
  }
}