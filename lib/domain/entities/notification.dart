/// Represents a notification in Immuno Warriors.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';
import '../../core/constants/app_strings.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

enum NotificationType { combat, research, system, achievement }

@freezed
class Notification with _$Notification, EquatableMixin {
  const Notification._();

  const factory Notification({
    required String id,
    required String userId,
    required String message,
    required DateTime timestamp,
    @Default(false) bool isRead,
    @Default(NotificationType.system) NotificationType type,
  }) = _Notification;

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);

  /// Display title based on type.
  String get displayTitle {
    switch (type) {
      case NotificationType.combat:
        return AppStrings.combatTitle;
      case NotificationType.research:
        return AppStrings.research;
      case NotificationType.achievement:
        return AppStrings.achievement;
      case NotificationType.system:
        return AppStrings.system;
    }
  }

  @override
  List<Object?> get props => [id, userId, message, timestamp, isRead, type];
}
