import 'package:flutter/foundation.dart';
import 'package:immuno_warriors/domain/entities/combat_report_entity.dart';
import 'package:immuno_warriors/domain/repositories/combat_repository.dart';
import 'package:immuno_warriors/data/models/combat_report_model.dart';

class GetCombatHistoryUseCase {
  final CombatRepository _combatRepository;

  GetCombatHistoryUseCase(this._combatRepository);

  Future<List<CombatReportEntity>> execute() async {
    try {
      final List<CombatReportModel> combatHistoryModels = await _combatRepository.getCombatHistory();
      return combatHistoryModels.map((model) => CombatReportEntity(
        combatId: model.combatId,
        date: model.date,
        result: model.result,
        log: model.log,
        damageDealt: model.damageDealt,
        damageTaken: model.damageTaken,
        unitsDeployed: model.unitsDeployed,
        unitsLost: model.unitsLost,
        baseId: model.baseId,
        antibodiesUsed: model.antibodiesUsed,
        pathogenFought: model.pathogenFought,
      )).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting combat history: $e');
      }
      rethrow;
    }
  }
}