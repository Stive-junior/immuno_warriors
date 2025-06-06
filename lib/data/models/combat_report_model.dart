import 'package:hive/hive.dart';
import '../../../domain/entities/combat_report_entity.dart';
import '../../domain/entities/combat/antibody_entity.dart';
import '../../domain/entities/combat/pathogen_entity.dart';

part 'combat_report_model.g.dart';

@HiveType(typeId: 5)
class CombatReportModel extends HiveObject {
  @HiveField(0)
  final String combatId;
  @HiveField(1)
  final DateTime date;
  @HiveField(2)
  final String result;
  @HiveField(3)
  final List<String> log;
  @HiveField(4)
  final int damageDealt;
  @HiveField(5)
  final int damageTaken;
  @HiveField(6)
  final List<String> unitsDeployed;
  @HiveField(7)
  final List<String> unitsLost;
  @HiveField(8)
  final String baseId;
  @HiveField(9)
  final List<AntibodyEntity>? antibodiesUsed;
  @HiveField(10)
  final PathogenEntity? pathogenFought;

  CombatReportModel({
    required this.combatId,
    required this.date,
    required this.result,
    required this.log,
    required this.damageDealt,
    required this.damageTaken,
    required this.unitsDeployed,
    required this.unitsLost,
    required this.baseId,
    this.antibodiesUsed,
    this.pathogenFought,
  });

  factory CombatReportModel.fromJson(Map<String, dynamic> json) {
    return CombatReportModel(
      combatId: json['combatId'] as String,
      date: DateTime.parse(json['date'] as String),
      result: json['result'] as String,
      log: (json['log'] as List<dynamic>).cast<String>(),
      damageDealt: json['damageDealt'] as int,
      damageTaken: json['damageTaken'] as int,
      unitsDeployed: (json['unitsDeployed'] as List<dynamic>).cast<String>(),
      unitsLost: (json['unitsLost'] as List<dynamic>).cast<String>(),
      baseId: json['baseId'] as String,
      antibodiesUsed: (json['antibodiesUsed'] as List<dynamic>?)?.map((item) => AntibodyEntity.fromJson(item as Map<String, dynamic>)).toList(),
      pathogenFought: json['pathogenFought'] == null ? null : PathogenEntity.fromJson(json['pathogenFought'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'combatId': combatId,
    'date': date.toIso8601String(),
    'result': result,
    'log': log,
    'damageDealt': damageDealt,
    'damageTaken': damageTaken,
    'unitsDeployed': unitsDeployed,
    'unitsLost': unitsLost,
    'baseId': baseId,
    'antibodiesUsed': antibodiesUsed?.map((e) => e.toJson()).toList(),
    'pathogenFought': pathogenFought?.toJson(),
  };

  factory CombatReportModel.fromEntity(CombatReportEntity entity) {
    return CombatReportModel(
      combatId: entity.combatId,
      date: entity.date,
      result: entity.result,
      log: entity.log,
      damageDealt: entity.damageDealt,
      damageTaken: entity.damageTaken,
      unitsDeployed: entity.unitsDeployed,
      unitsLost: entity.unitsLost,
      baseId: entity.baseId,
      antibodiesUsed: entity.antibodiesUsed,
      pathogenFought: entity.pathogenFought,
    );
  }

  CombatReportEntity toEntity() {
    return CombatReportEntity(
      combatId: combatId,
      date: date,
      result: result,
      log: log,
      damageDealt: damageDealt,
      damageTaken: damageTaken,
      unitsDeployed: unitsDeployed,
      unitsLost: unitsLost,
      baseId: baseId,
      antibodiesUsed: antibodiesUsed,
      pathogenFought: pathogenFought,
    );
  }
}