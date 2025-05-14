import 'package:immuno_warriors/domain/entities/combat/antibody_entity.dart';
import 'package:immuno_warriors/domain/entities/combat/pathogen_entity.dart';

class CombatReportEntity {
  final String combatId;
  final DateTime date;
  final String result;
  final List<String> log;
  final int damageDealt;
  final int damageTaken;
  final List<String> unitsDeployed;
  final List<String> unitsLost;
  final String baseId;
  final List<AntibodyEntity>? antibodiesUsed; // Liste d'anticorps utilisés
  final PathogenEntity? pathogenFought; // Pathogène combattu

  CombatReportEntity({
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

  CombatReportEntity copyWith({
    String? combatId,
    DateTime? date,
    String? result,
    List<String>? log,
    int? damageDealt,
    int? damageTaken,
    List<String>? unitsDeployed,
    List<String>? unitsLost,
    String? baseId,
    List<AntibodyEntity>? antibodiesUsed,
    PathogenEntity? pathogenFought,
  }) {
    return CombatReportEntity(
      combatId: combatId ?? this.combatId,
      date: date ?? this.date,
      result: result ?? this.result,
      log: log ?? this.log,
      damageDealt: damageDealt ?? this.damageDealt,
      damageTaken: damageTaken ?? this.damageTaken,
      unitsDeployed: unitsDeployed ?? this.unitsDeployed,
      unitsLost: unitsLost ?? this.unitsLost,
      baseId: baseId ?? this.baseId,
      antibodiesUsed: antibodiesUsed ?? this.antibodiesUsed,
      pathogenFought: pathogenFought ?? this.pathogenFought,
    );
  }
}