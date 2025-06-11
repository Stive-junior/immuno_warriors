import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';
import './combat/antibody_entity.dart';
import './combat/pathogen_entity.dart';

part 'combat_report_entity.freezed.dart';
part 'combat_report_entity.g.dart';

enum CombatResult { victory, defeat, draw }

const combatResultConverter = CombatResultConverter();

@freezed
class CombatReportEntity with _$CombatReportEntity, EquatableMixin {
  const CombatReportEntity._();

  const factory CombatReportEntity({
    required String combatId,
    required DateTime date,
    @combatResultConverter required CombatResult result,
    required List<String> log,
    required int damageDealt,
    required int damageTaken,
    required List<String> unitsDeployed,
    required List<String> unitsLost,
    required String baseId,
    List<AntibodyEntity>? antibodiesUsed,
    PathogenEntity? pathogenFought,
  }) = _CombatReportEntity;

  factory CombatReportEntity.fromJson(Map<String, dynamic> json) =>
      _$CombatReportEntityFromJson(json);

  /// Calculates efficiency of the combat (damage dealt vs taken).
  double get combatEfficiency =>
      damageTaken > 0 ? damageDealt / damageTaken : double.infinity;

  // Remove these static methods, they are replaced by the converter
  // static CombatResult _resultFromJson(String value) => CombatResult.values
  //     .firstWhere((e) => e.toString().split('.').last == value);

  // static String _resultToJson(CombatResult result) =>
  //     result.toString().split('.').last;

  @override
  List<Object?> get props => [
    combatId,
    date,
    result,
    log,
    damageDealt,
    damageTaken,
    unitsDeployed,
    unitsLost,
    baseId,
    antibodiesUsed,
    pathogenFought,
  ];
}

class CombatResultConverter implements JsonConverter<CombatResult, String> {
  const CombatResultConverter();

  @override
  CombatResult fromJson(String json) {
    return CombatResult.values.firstWhere(
      (e) => e.toString().split('.').last == json,
      orElse: () => CombatResult.draw,
    );
  }

  @override
  String toJson(CombatResult object) {
    return object.toString().split('.').last;
  }
}
