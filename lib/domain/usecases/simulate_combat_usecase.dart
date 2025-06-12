import 'package:flutter/foundation.dart';
import 'package:immuno_warriors/domain/entities/antibody_entity.dart';
import 'package:immuno_warriors/domain/entities/pathogen_entity.dart';
import 'package:immuno_warriors/domain/entities/combat_report_entity.dart';
import 'package:immuno_warriors/domain/repositories/combat_repository.dart';
import 'package:immuno_warriors/data/models/combat_report_model.dart';

class SimulateCombatUseCase {
  final CombatRepository _combatRepository;

  SimulateCombatUseCase(this._combatRepository);

  Future<CombatReportEntity> execute({
    required List<AntibodyEntity> antibodies,
    required List<PathogenEntity> pathogens,
    required String baseId,
  }) async {
    try {
      final CombatReportModel combatReportModel = await _combatRepository
          .simulateCombat(
            antibodies: antibodies,
            pathogens: pathogens,
            baseId: baseId,
          );

      return CombatReportEntity(
        combatId: combatReportModel.combatId,
        date: combatReportModel.date,
        result: combatReportModel.result,
        log: combatReportModel.log,
        damageDealt: combatReportModel.damageDealt,
        damageTaken: combatReportModel.damageTaken,
        unitsDeployed: combatReportModel.unitsDeployed,
        unitsLost: combatReportModel.unitsLost,
        baseId: combatReportModel.baseId,
        antibodiesUsed: combatReportModel.antibodiesUsed,
        pathogenFought: combatReportModel.pathogenFought,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error simulating combat: $e');
      }
      rethrow;
    }
  }
}
