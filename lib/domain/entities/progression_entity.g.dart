// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progression_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProgressionEntityImpl _$$ProgressionEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$ProgressionEntityImpl(
      userId: json['userId'] as String,
      level: (json['level'] as num).toInt(),
      xp: (json['xp'] as num).toInt(),
      rank: json['rank'] as String?,
      missions: (json['missions'] as List<dynamic>)
          .map((e) => MissionEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ProgressionEntityImplToJson(
        _$ProgressionEntityImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'level': instance.level,
      'xp': instance.xp,
      'rank': instance.rank,
      'missions': instance.missions,
    };

_$MissionEntityImpl _$$MissionEntityImplFromJson(Map<String, dynamic> json) =>
    _$MissionEntityImpl(
      id: json['id'] as String,
      completed: json['completed'] as bool,
    );

Map<String, dynamic> _$$MissionEntityImplToJson(_$MissionEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'completed': instance.completed,
    };
