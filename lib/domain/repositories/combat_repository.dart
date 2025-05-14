import 'package:immuno_warriors/data/models/combat_report_model.dart';
import 'package:immuno_warriors/domain/entities/combat/pathogen_entity.dart';
import 'package:immuno_warriors/domain/entities/combat/antibody_entity.dart';

abstract class CombatRepository {
  /// Simulates a combat encounter.
  Future<CombatReportModel> simulateCombat({
    required List<AntibodyEntity> antibodies,
    required List<PathogenEntity> pathogens,
    required String baseId,
  });

  /// Generates a combat chronicle using the Gemini API.
  Future<String> generateCombatChronicle(CombatReportModel combatResult);

  /// Saves the combat result to history.
  Future<void> saveCombatResult(CombatReportModel combatResult);

  /// Retrieves combat history.
  Future<List<CombatReportModel>> getCombatHistory();

  Future<String?> getCombatTacticalAdvice({String? gameState, String? enemyBaseInfo});

}