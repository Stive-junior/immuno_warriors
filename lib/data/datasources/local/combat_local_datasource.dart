import 'package:immuno_warriors/core/services/local_storage_service.dart';
import 'package:immuno_warriors/data/models/combat_report_model.dart';
import 'package:immuno_warriors/core/services/auth_service.dart'; // Import AuthService
import 'package:immuno_warriors/core/utils/app_logger.dart'; // Import AppLogger

/// Provides local data source for combat-related data.
class CombatLocalDataSource {
  final LocalStorageService _localStorageService;
  final AuthService _authService; // Instance of AuthService

  CombatLocalDataSource(this._localStorageService, this._authService);

  String? get _currentUserId => _authService.currentUser?.uid;

  /// Saves the combat report to local storage.
  Future<void> saveCombatResult(CombatReportModel combatReport) async {
    final userId = _currentUserId;
    if (userId == null) {
      AppLogger.warning('No user ID available to save combat report.');
      throw Exception('User not authenticated.');
    }
    await _localStorageService.saveCombatReport(
      userId,
      combatReport,
    ); // Save with userId
  }

  /// Retrieves all combat reports from local storage for the current user.
  Object getCombatHistory() {
    final userId = _currentUserId;
    if (userId == null) {
      AppLogger.warning('No user ID available to retrieve combat history.');
      return [];
    }
    return _localStorageService.getAllCombatReportsLocal(
      userId,
    ); // Retrieve with userId
  }

  /// Retrieves a specific combat report by its ID for the current user.
  CombatReportModel? getCombatReport(String combatId) {
    final userId = _currentUserId;
    if (userId == null) {
      AppLogger.warning('No user ID available to retrieve combat report.');
      return null;
    }
    return _localStorageService.getCombatReport(
      userId,
      combatId,
    ); // Retrieve with userId and combatId
  }

  /// Clears all combat reports from local storage for the current user.
  Future<void> clearCombatHistory() async {
    final userId = _currentUserId;
    if (userId == null) {
      AppLogger.warning('No user ID available to clear combat history.');
      throw Exception('User not authenticated.');
    }
    await _localStorageService.clearCombatReports(userId); // Clear with userId
  }
}
