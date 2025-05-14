import 'package:immuno_warriors/data/models/combat_report_model.dart';
import 'package:immuno_warriors/core/services/gemini_service.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

class GeminiRemoteDataSource {
  final GeminiService _geminiService;

  GeminiRemoteDataSource(this._geminiService);

  Future<String> generateCombatChronicle(CombatReportModel combatReport) async {
    try {
      final combatSummary = 'Combat ID: ${combatReport.combatId}, Date: ${combatReport.date}, Résultat: ${combatReport.result}, Dommages infligés: ${combatReport.damageDealt}, Dommages subis: ${combatReport.damageTaken}, Unités déployées: ${combatReport.unitsDeployed}, Unités perdues: ${combatReport.unitsLost}, Base ID: ${combatReport.baseId}, Anticorps utilisés: ${combatReport.antibodiesUsed?.map((a) => a.toString()).toList() ?? []}, Pathogène combattu: ${combatReport.pathogenFought?.toString() ?? 'Aucun'}';
      final chronicle = await _geminiService.generateCombatChronicle(combatSummary.trim());
      return chronicle;
    } catch (e) {
      AppLogger.error('Error communicating with Gemini service: $e');
      rethrow;
    }
  }
}