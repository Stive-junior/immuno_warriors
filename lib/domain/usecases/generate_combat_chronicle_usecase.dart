import 'package:flutter/foundation.dart';
import 'package:immuno_warriors/domain/repositories/combat_repository.dart';
import 'package:immuno_warriors/data/models/combat_report_model.dart';

class GenerateCombatChronicleUseCase {
  final CombatRepository _combatRepository;

  GenerateCombatChronicleUseCase(this._combatRepository);

  Future<String> execute(CombatReportModel combatReport) async {
    try {
      return await _combatRepository.generateCombatChronicle(combatReport);
    } catch (e) {
      if (kDebugMode) {
        print('Error generating combat chronicle: $e');
      }
      rethrow;
    }
  }
}