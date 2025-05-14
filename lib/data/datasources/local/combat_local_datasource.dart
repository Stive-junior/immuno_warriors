import 'package:immuno_warriors/core/services/local_storage_service.dart';
import 'package:immuno_warriors/data/models/combat_report_model.dart';

/// Provides local data source for combat-related data.
class CombatLocalDataSource {
  final LocalStorageService _localStorageService;

  CombatLocalDataSource(this._localStorageService);

  /// Saves the combat report to local storage.
  Future<void> saveCombatResult(CombatReportModel combatReport) async {
    await _localStorageService.saveCombatReport(combatReport);
  }

  /// Retrieves all combat reports from local storage.
  List<CombatReportModel> getCombatHistory() {
    return _localStorageService.getAllCombatReportsLocal();
  }

  /// Retrieves a specific combat report by its ID.
  CombatReportModel? getCombatReport(String combatId) {
    return _localStorageService.getCombatReport(combatId);
  }

  /// Clears all combat reports from local storage.
  Future<void> clearCombatHistory() async {
    await _localStorageService.clearCombatReports();
  }
}