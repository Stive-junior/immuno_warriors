// Model for storing notification data locally in Immuno Warriors.
import 'package:hive/hive.dart';
import 'package:immuno_warriors/domain/entities/notification.dart';

part 'notification_model.g.dart';

@HiveType(typeId: 18)
class NotificationModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String message;
  @HiveField(3)
  final DateTime timestamp;
  @HiveField(4)
  final bool isRead;
  @HiveField(5)
  final NotificationType type;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.message,
    required this.timestamp,
    required this.isRead,
    required this.type,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel.fromEntity(Notification.fromJson(json));

  Map<String, dynamic> toJson() => toEntity().toJson();

  factory NotificationModel.fromEntity(Notification entity) {
    return NotificationModel(
      id: entity.id,
      userId: entity.userId,
      message: entity.message,
      timestamp: entity.timestamp,
      isRead: entity.isRead,
      type: entity.type,
    );
  }

  Notification toEntity() {
    return Notification(
      id: id,
      userId: userId,
      message: message,
      timestamp: timestamp,
      isRead: isRead,
      type: type,
    );
  }

  // Inside NotificationModel class
  NotificationModel copyWith({
    String? id,
    String? userId,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    NotificationType? type,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      userId: userId ?? this.userId,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  /// Validates if the notification is displayable.
  bool get isValid => message.trim().isNotEmpty && id.isNotEmpty;
  set isRead(bool value) {
    isRead = value;
  }
}
