// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_virale_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BaseViraleEntityImpl _$$BaseViraleEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$BaseViraleEntityImpl(
      id: json['id'] as String,
      playerId: json['playerId'] as String,
      name: json['name'] as String,
      level: (json['level'] as num).toInt(),
      pathogens: (json['pathogens'] as List<dynamic>)
          .map((e) => PathogenEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      defenses: (json['defenses'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry($enumDecode(_$DefenseTypeEnumMap, k), (e as num).toInt()),
      ),
    );

Map<String, dynamic> _$$BaseViraleEntityImplToJson(
        _$BaseViraleEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'playerId': instance.playerId,
      'name': instance.name,
      'level': instance.level,
      'pathogens': instance.pathogens,
      'defenses': instance.defenses
          .map((k, e) => MapEntry(_$DefenseTypeEnumMap[k]!, e)),
    };

const _$DefenseTypeEnumMap = {
  DefenseType.wall: 'wall',
  DefenseType.trap: 'trap',
  DefenseType.shield: 'shield',
  DefenseType.turret: 'turret',
  DefenseType.barrier: 'barrier',
};
