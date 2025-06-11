// Repository for managing combat-related operations in Immuno Warriors.
import 'package:dartz/dartz.dart';
import '../../data/models/combat_report_model.dart';
import '../../domain/entities/combat/pathogen_entity.dart';
import '../../domain/entities/combat/antibody_entity.dart';
import '../../core/exceptions/app_exception.dart';

abstract class CombatRepository {
  /// Simulates a combat encounter.
  Future<Either<AppException, CombatReportModel>> simulateCombat({
    required List<AntibodyEntity> antibodies,
    required List<PathogenEntity> pathogens,
    required String baseId,
  });

  /// Generates a combat chronicle using AI.
  Future<Either<AppException, String>> generateCombatChronicle(
    CombatReportModel combatResult,
  );

  /// Saves a combat result to history.
  Future<Either<AppException, void>> saveCombatResult(
    CombatReportModel combatResult,
  );

  /// Retrieves combat history with pagination.
  Future<Either<AppException, List<CombatReportModel>>>
  getPaginatedCombatHistory({int page = 1, int limit = 10});

  /// Retrieves tactical advice for combat.
  Future<Either<AppException, String>> getCombatTacticalAdvice({
    String? gameState,
    String? enemyBaseId,
  });

  /// Initiates a real-time combat session.
  Future<Either<AppException, String>> startRealTimeCombat({
    required String baseId,
    required List<AntibodyEntity> antibodies,
  });

  /// Caches a combat report locally.
  Future<Either<AppException, void>> cacheCombatReport(
    CombatReportModel report,
  );

  /// Retrieves a cached combat report by ID.
  Future<Either<AppException, CombatReportModel?>> getCachedCombatReport(
    String combatId,
  );

  /// Clears cached combat reports.
  Future<Either<AppException, void>> clearCachedCombatReports();
}
