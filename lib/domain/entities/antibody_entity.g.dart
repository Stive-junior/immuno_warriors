// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'antibody_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AntibodyEntityImpl _$$AntibodyEntityImplFromJson(Map<String, dynamic> json) =>
    _$AntibodyEntityImpl(
      id: json['id'] as String,
      type: $enumDecode(_$AntibodyTypeEnumMap, json['type']),
      attackType: $enumDecode(_$AttackTypeEnumMap, json['attackType']),
      damage: (json['damage'] as num).toInt(),
      range: (json['range'] as num).toInt(),
      cost: (json['cost'] as num).toInt(),
      efficiency: (json['efficiency'] as num).toDouble(),
      name: json['name'] as String,
      health: (json['health'] as num).toInt(),
      maxHealth: (json['maxHealth'] as num).toInt(),
      specialAbility: json['specialAbility'] as String?,
    );

Map<String, dynamic> _$$AntibodyEntityImplToJson(
        _$AntibodyEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$AntibodyTypeEnumMap[instance.type]!,
      'attackType': _$AttackTypeEnumMap[instance.attackType]!,
      'damage': instance.damage,
      'range': instance.range,
      'cost': instance.cost,
      'efficiency': instance.efficiency,
      'name': instance.name,
      'health': instance.health,
      'maxHealth': instance.maxHealth,
      'specialAbility': instance.specialAbility,
    };

const _$AntibodyTypeEnumMap = {
  AntibodyType.igG: 'igG',
  AntibodyType.igM: 'igM',
  AntibodyType.igA: 'igA',
  AntibodyType.igD: 'igD',
  AntibodyType.igE: 'igE',
  AntibodyType.custom: 'custom',
};

const _$AttackTypeEnumMap = {
  AttackType.physical: 'physical',
  AttackType.chemical: 'chemical',
  AttackType.energy: 'energy',
  AttackType.bio: 'bio',
};
