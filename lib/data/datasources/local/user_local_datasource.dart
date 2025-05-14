import 'package:immuno_warriors/core/services/local_storage_service.dart';
import 'package:immuno_warriors/data/models/user_model.dart';

/// Provides local data source for user-related data.
class UserLocalDataSource {
  final LocalStorageService _localStorageService;

  UserLocalDataSource(this._localStorageService);

  /// Saves the user data to local storage.
  Future<void> saveUser(UserModel user) async {
    await _localStorageService.saveUser(user);
  }

  /// Retrieves the user data from local storage.
  UserModel? getUser() {
    return _localStorageService.getUser();
  }

  /// Clears the user data from local storage.
  Future<void> clearUser() async {
    await _localStorageService.clearUser();
  }

  /// Saves a pathogen signature to local storage.
  Future<void> savePathogenSignature(String signature) async {
    await _localStorageService.savePathogenSignature(signature);
  }

  /// Retrieves all pathogen signatures from local storage.
  List<String> getPathogenSignatures() {
    return _localStorageService.getPathogenSignatures();
  }

  /// Clears all pathogen signatures from local storage.
  Future<void> clearPathogenSignatures() async {
    await _localStorageService.clearPathogenSignatures();
  }

  /// Saves research progress to local storage.
  Future<void> saveResearchProgress(Map<String, dynamic> progress) async {
    await _localStorageService.saveResearchProgress(progress);
  }

  /// Retrieves research progress from local storage.
  Map<String, dynamic>? getResearchProgress() {
    return _localStorageService.getResearchProgress();
  }

  /// Clears research progress from local storage.
  Future<void> clearResearchProgress() async {
    await _localStorageService.clearResearchProgress();
  }


}