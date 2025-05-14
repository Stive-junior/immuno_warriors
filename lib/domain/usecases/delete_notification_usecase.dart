import 'package:immuno_warriors/domain/repositories/notification_repository.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

class DeleteNotificationUseCase {
  final NotificationRepository _notificationRepository;

  DeleteNotificationUseCase(this._notificationRepository);

  Future<void> execute(String id) async {
    try {
      await _notificationRepository.deleteNotification(id);
    } catch (e) {
      AppLogger.error('Error deleting notification: $e');
      rethrow;
    }
  }
}