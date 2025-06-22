// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combat_report_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CombatReportEntityImpl _$$CombatReportEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$CombatReportEntityImpl(
      combatId: json['combatId'] as String,
      date: DateTime.parse(json['date'] as String),
      result: combatResultConverter.fromJson(json['result'] as String),
      log: (json['log'] as List<dynamic>).map((e) => e as String).toList(),
      damageDealt: (json['damageDealt'] as num).toInt(),
      damageTaken: (json['damageTaken'] as num).toInt(),
      unitsDeployed: (json['unitsDeployed'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      unitsLost:
          (json['unitsLost'] as List<dynamic>).map((e) => e as String).toList(),
      baseId: json['baseId'] as String,
      antibodiesUsed: (json['antibodiesUsed'] as List<dynamic>?)
          ?.map((e) => AntibodyEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      pathogenFought: json['pathogenFought'] == null
          ? null
          : PathogenEntity.fromJson(
              json['pathogenFought'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CombatReportEntityImplToJson(
        _$CombatReportEntityImpl instance) =>
    <String, dynamic>{
      'combatId': instance.combatId,
      'date': instance.date.toIso8601String(),
      'result': combatResultConverter.toJson(instance.result),
      'log': instance.log,
      'damageDealt': instance.damageDealt,
      'damageTaken': instance.damageTaken,
      'unitsDeployed': instance.unitsDeployed,
      'unitsLost': instance.unitsLost,
      'baseId': instance.baseId,
      'antibodiesUsed': instance.antibodiesUsed,
      'pathogenFought': instance.pathogenFought,
    };
