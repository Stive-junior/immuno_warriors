// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'research_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ResearchEntityImpl _$$ResearchEntityImplFromJson(Map<String, dynamic> json) =>
    _$ResearchEntityImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      researchCost: (json['cost'] as num).toInt(),
      prerequisites: (json['prerequisites'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      effects: json['effects'] as Map<String, dynamic>,
      level: (json['level'] as num).toInt(),
      isUnlocked: json['isUnlocked'] as bool? ?? false,
    );

Map<String, dynamic> _$$ResearchEntityImplToJson(
        _$ResearchEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'cost': instance.researchCost,
      'prerequisites': instance.prerequisites,
      'effects': instance.effects,
      'level': instance.level,
      'isUnlocked': instance.isUnlocked,
    };
