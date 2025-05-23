import 'package:immuno_warriors/core/services/local_storage_service.dart';
import 'package:immuno_warriors/data/models/user_model.dart';
import 'package:immuno_warriors/domain/entities/user_entity.dart';
import 'package:immuno_warriors/data/models/cached_session.dart';
import 'package:immuno_warriors/core/services/auth_service.dart';

import '../../../core/utils/app_logger.dart';

/// Provides local data source for user-related data.
class UserLocalDataSource {
  final LocalStorageService _localStorageService;
  final AuthService _authService; // Instance of AuthService

  UserLocalDataSource(this._localStorageService, this._authService);

  String? get _currentUserId => _authService.currentUser?.uid;

  /// Saves the user data to local storage.
  Future<void> saveUser(UserModel user) async {
    final userId = _currentUserId;
    if (userId == null) {
      AppLogger.warning('No user ID available to save user data.');
      throw Exception('User not authenticated.');
    }
    await _localStorageService.saveUser(user); // Save with userId
  }

  /// Retrieves the user data from local storage.
  UserModel? getUser() {
    final userId = _currentUserId;
    if (userId == null) {
      AppLogger.warning('No user ID available to retrieve user data.');
      return null;
    }
    return _localStorageService.getUser(userId);
  }

  /// Clears the user data from local storage.
  Future<void> clearUser() async {
    final userId = _currentUserId;
    if (userId == null) {
      AppLogger.warning('No user ID available to clear user data.');
      throw Exception('User not authenticated.');
    }
    await _localStorageService.clearUser(userId); // Clear with userId
  }

  /// Saves a pathogen signature to local storage.
  Future<void> savePathogenSignature(String signature) async {
    final userId = _currentUserId;
    if (userId == null) {
      AppLogger.warning('No user ID available to save pathogen signature.');
      throw Exception('User not authenticated.');
    }
    await _localStorageService.savePathogenSignature(userId, signature); // Save with userId
  }

  /// Retrieves all pathogen signatures from local storage.
  Object getPathogenSignatures() {
    final userId = _currentUserId;
    if (userId == null) {
      AppLogger.warning('No user ID available to retrieve pathogen signatures.');
      return [];
    }
    return _localStorageService.getPathogenSignatures(userId) ?? []; // Retrieve with userId
  }

  /// Clears all pathogen signatures from local storage.
  Future<void> clearPathogenSignatures() async {
    final userId = _currentUserId;
    if (userId == null) {
      AppLogger.warning('No user ID available to clear pathogen signatures.');
      throw Exception('User not authenticated.');
    }
    await _localStorageService.clearPathogenSignatures(userId); // Clear with userId
  }

  /// Saves research progress to local storage.
  Future<void> saveResearchProgress(Map<String, dynamic> progress) async {
    final userId = _currentUserId;
    if (userId == null) {
      AppLogger.warning('No user ID available to save research progress.');
      throw Exception('User not authenticated.');
    }
    await _localStorageService.saveResearchProgress(userId, progress); // Save with userId
  }

  /// Retrieves research progress from local storage.
  Map<String, dynamic>? getResearchProgress() {
    final userId = _currentUserId;
    if (userId == null) {
      AppLogger.warning('No user ID available to retrieve research progress.');
      return null;
    }
    return _localStorageService.getResearchProgress(userId); // Retrieve with userId
  }

  /// Clears research progress from local storage.
  Future<void> clearResearchProgress() async {
    final userId = _currentUserId;
    if (userId == null) {
      AppLogger.warning('No user ID available to clear research progress.');
      throw Exception('User not authenticated.');
    }
    await _localStorageService.clearResearchProgress(userId); // Clear with userId
  }

  /// Caches a list of users.
  Future<void> cacheUsers(List<UserEntity> users) async {
    final userId = _currentUserId;
    if (userId == null) {
      AppLogger.warning('No user ID available to cache users.');
      throw Exception('User not authenticated.');
    }
    await _localStorageService.cacheUsers(userId, users); // Cache with userId
  }

  /// Retrieves the cached list of users.
  Future<Object> getUsers() async {
    final userId = _currentUserId;
    if (userId == null) {
      AppLogger.warning('No user ID available to retrieve cached users.');
      return [];
    }
    return _localStorageService.getUsers(userId) ?? [];
  }

  /// Retrieves a user by their ID from the cache.
  Future<UserEntity?> getUserById(String userIdToFind) async {
    final userId = _currentUserId;
    if (userId == null) {
      AppLogger.warning('No user ID available to retrieve user by ID from cache.');
      return null;
    }
    return _localStorageService.getUserById(userId, userIdToFind); // Retrieve with current userId
  }

  /// Saves a user session to local storage.
  Future<void> saveSession(String userId, String token, DateTime expiryTime) async {
    await _localStorageService.saveSession(userId, token, expiryTime); // Save with userId
  }

  /// Retrieves a user session from local storage.
  Future<CachedSession?> getSession(String userId) async {
    return _localStorageService.getSession(userId); // Retrieve with userId
  }

  /// Clears a user session from local storage.
  Future<void> clearSession(String userId) async {
    await _localStorageService.clearSession(userId); // Clear with userId
  }

  /// Checks if a session is valid.
  Future<bool> checkSessionValidity(String userId) async {
    return await _localStorageService.checkSessionValidity(userId); // Check with userId
  }

  /// Caches the current user.
  Future<void> saveCurrentUser(UserEntity user) async {
    final userId = _currentUserId;
    if (userId == null) {
      AppLogger.warning('No user ID available to save current user cache.');
      throw Exception('User not authenticated.');
    }
    await _localStorageService.saveCurrentUser(userId, user); // Save with userId
  }

  /// Retrieves the cached current user.
  Future<UserEntity?> getCurrentUserCache() async {
    final userId = _currentUserId;
    if (userId == null) {
      AppLogger.warning('No user ID available to retrieve current user cache.');
      return null;
    }
    return _localStorageService.getCurrentUserCache(userId); // Retrieve with userId
  }

  /// Clears the cached current user.
  Future<void> clearCurrentUser() async {
    final userId = _currentUserId;
    if (userId == null) {
      AppLogger.warning('No user ID available to clear current user cache.');
      throw Exception('User not authenticated.');
    }
    await _localStorageService.clearCurrentUser(userId); // Clear with userId
  }


}