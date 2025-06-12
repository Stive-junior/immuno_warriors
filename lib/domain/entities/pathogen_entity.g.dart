// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pathogen_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PathogenEntityImpl _$$PathogenEntityImplFromJson(Map<String, dynamic> json) =>
    _$PathogenEntityImpl(
      id: json['id'] as String,
      type: $enumDecode(_$PathogenTypeEnumMap, json['type']),
      name: json['name'] as String,
      health: (json['health'] as num).toInt(),
      attack: (json['attack'] as num).toInt(),
      attackType: $enumDecode(_$AttackTypeEnumMap, json['attackType']),
      resistanceType:
          $enumDecode(_$ResistanceTypeEnumMap, json['resistanceType']),
      rarity: $enumDecode(_$PathogenRarityEnumMap, json['rarity']),
      mutationRate: (json['mutationRate'] as num).toDouble(),
      abilities: (json['abilities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$PathogenEntityImplToJson(
        _$PathogenEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$PathogenTypeEnumMap[instance.type]!,
      'name': instance.name,
      'health': instance.health,
      'attack': instance.attack,
      'attackType': _$AttackTypeEnumMap[instance.attackType]!,
      'resistanceType': _$ResistanceTypeEnumMap[instance.resistanceType]!,
      'rarity': _$PathogenRarityEnumMap[instance.rarity]!,
      'mutationRate': instance.mutationRate,
      'abilities': instance.abilities,
    };

const _$PathogenTypeEnumMap = {
  PathogenType.virus: 'virus',
  PathogenType.bacteria: 'bacteria',
  PathogenType.fungus: 'fungus',
};

const _$AttackTypeEnumMap = {
  AttackType.physical: 'physical',
  AttackType.chemical: 'chemical',
  AttackType.energy: 'energy',
};

const _$ResistanceTypeEnumMap = {
  ResistanceType.physical: 'physical',
  ResistanceType.chemical: 'chemical',
  ResistanceType.energy: 'energy',
};

const _$PathogenRarityEnumMap = {
  PathogenRarity.common: 'common',
  PathogenRarity.uncommon: 'uncommon',
  PathogenRarity.rare: 'rare',
  PathogenRarity.epic: 'epic',
  PathogenRarity.legendary: 'legendary',
};
