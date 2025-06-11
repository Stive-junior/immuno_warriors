// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationImpl _$$NotificationImplFromJson(Map<String, dynamic> json) =>
    _$NotificationImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
      type: $enumDecodeNullable(_$NotificationTypeEnumMap, json['type']) ??
          NotificationType.system,
    );

Map<String, dynamic> _$$NotificationImplToJson(_$NotificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'message': instance.message,
      'timestamp': instance.timestamp.toIso8601String(),
      'isRead': instance.isRead,
      'type': _$NotificationTypeEnumMap[instance.type]!,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.combat: 'combat',
  NotificationType.research: 'research',
  NotificationType.system: 'system',
  NotificationType.achievement: 'achievement',
};
