import 'package:flutter/cupertino.dart';
import 'package:immuno_warriors/data/datasources/local/user_local_datasource.dart';
import 'package:immuno_warriors/data/datasources/remote/user_remote_datasource.dart';
import 'package:immuno_warriors/domain/entities/user_entity.dart';
import 'package:immuno_warriors/domain/repositories/user_repository.dart';
import 'package:immuno_warriors/data/models/user_model.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/core/services/auth_service.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final AuthService authService;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.authService,
  });

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final userId = authService.currentUser?.uid;
      if (userId == null) {
        AppLogger.warning('No user ID found.');
        return null;
      }
      final localUser = localDataSource.getUser();
      if (localUser != null && localUser.id == userId) {return localUser.toEntity();
      }
      final remoteUser = await remoteDataSource.getUserProfile(userId);
      await localDataSource.saveUser(UserModel.fromEntity(remoteUser.toEntity()));
          return remoteUser.toEntity();
    } catch (e) {
      AppLogger.error('Error getting current user: $e');
      rethrow;
    }
  }

  @override
  Future<void> saveUser(UserEntity user) async {
    try {
      final model = UserModel.fromEntity(user);
      await remoteDataSource.updateUserSettings(user.id, model.toJson());
      await localDataSource.saveUser(model);
    } catch (e) {
      AppLogger.error('Error saving user: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getUserResources() async {
    try {
      final userId = authService.currentUser?.uid;
      if (userId == null) {
        AppLogger.warning('No user ID found. Cannot fetch resources.');
        throw StateError('User is not authenticated.');
      }
      return await remoteDataSource.getUserResources(userId);
    } catch (e) {
      AppLogger.error('Error getting user resources: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateUserResources(Map<String, dynamic> resources) async {
    try {
      final userId = authService.currentUser?.uid;
      if (userId == null) {
        AppLogger.warning('No user ID found. Cannot update resources.');
        throw StateError('User is not authenticated.');
      }
      await remoteDataSource.updateUserResources(userId, resources);
      // Optionally update local data if needed, but getCurrentUser handles sync
    } catch (e) {
      AppLogger.error('Error updating user resources: $e');
      rethrow;
    }
  }

  @override
  Future<List<dynamic>> getUserInventory() async {
    try {
      final userId = authService.currentUser?.uid;
      if (userId == null) {
        AppLogger.warning('No user ID found. Cannot fetch inventory.');
        throw StateError('User is not authenticated.');
      }
      return await remoteDataSource.getUserInventory(userId);
    } catch (e) {
      AppLogger.error('Error getting user inventory: $e');
      rethrow;
    }
  }

  @override
  Future<void> addItemToInventory(dynamic item) async {
    try {
      final userId = authService.currentUser?.uid;
      if (userId == null) {
        AppLogger.warning('No user ID found. Cannot add item to inventory.');
        throw StateError('User is not authenticated.');
      }
      await remoteDataSource.addItemToInventory(userId, item);
      // Optionally update local cache if needed
    } catch (e) {
      AppLogger.error('Error adding item to inventory: $e');
      rethrow;
    }
  }

  @override
  Future<void> removeItemFromInventory(dynamic item) async {
    try {
      final userId = authService.currentUser?.uid;
      if (userId == null) {
        AppLogger.warning('No user ID found. Cannot remove item from inventory.');
        throw StateError('User is not authenticated.');
      }
      await remoteDataSource.removeItemFromInventory(userId, item);
      // Optionally update local cache if needed
    } catch (e) {
      AppLogger.error('Error removing item from inventory: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      final userId = authService.currentUser?.uid;
      if (userId != null) {
        await localDataSource.clearUser(); // Clears the 'currentUser' key
        await localDataSource.clearSession(userId);
        await localDataSource.clearCurrentUser();
        AppLogger.info('Local user data cleared for user: $userId.');
      } else {
        AppLogger.warning('No user ID to clear local data for.');
      }
    } catch (e) {
      AppLogger.error('Error clearing user data: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getUserSettings() async {
    try {
      final userId = authService.currentUser?.uid;
      if (userId == null) {
        AppLogger.warning('No user ID found. Cannot fetch settings.');
        throw StateError('User is not authenticated.');
      }
      return await remoteDataSource.getUserSettings(userId);
    } catch (e) {
      AppLogger.error('Error getting user settings: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateUserSettings(Map<String, dynamic> settings) async {
    try {
      final userId = authService.currentUser?.uid;
      if (userId == null) {
        AppLogger.warning('No user ID found. Cannot update settings.');
        throw StateError('User is not authenticated.');
      }
      await remoteDataSource.updateUserSettings(userId, settings);
      // Optionally update local cache
    } catch (e) {
      AppLogger.error('Error updating user settings: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getUserProgression() async {
    try {
      final userId = authService.currentUser?.uid;
      if (userId == null) {
        AppLogger.warning('No user ID found. Cannot fetch progression.');
        throw StateError('User is not authenticated.');
      }
      return await remoteDataSource.getUserProgression(userId);
    } catch (e) {
      AppLogger.error('Error getting user progression: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateUserProgression(Map<String, dynamic> progression) async {
    try {
      final userId = authService.currentUser?.uid;
      if (userId == null) {
        AppLogger.warning('No user ID found. Cannot update progression.');
        throw StateError('User is not authenticated.');
      }
      await remoteDataSource.updateUserProgression(userId, progression);
      // Optionally update local cache
    } catch (e) {
      AppLogger.error('Error updating user progression: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, bool>> getUserAchievements() async {
    try {
      final userId = authService.currentUser?.uid;
      if (userId == null) {
        AppLogger.warning('No user ID found. Cannot fetch achievements.');
        throw StateError('User is not authenticated.');
      }
      return await remoteDataSource.getUserAchievements(userId);
    } catch (e) {
      AppLogger.error('Error getting user achievements: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateUserAchievements(Map<String, bool> achievements) async {
    try {
      final userId = authService.currentUser?.uid;
      if (userId == null) {
        AppLogger.warning('No user ID found. Cannot update achievements.');
        throw StateError('User is not authenticated.');
      }
      await remoteDataSource.updateUserAchievements(userId, achievements);
      // Optionally update local cache
    } catch (e) {
      AppLogger.error('Error updating user achievements: $e');
      rethrow;
    }
  }

  @override
  Future<List<UserEntity>> getUsers() async {
    try {
      final remoteUsers = await remoteDataSource.getUsers();
      final userId = authService.currentUser?.uid;
      if (userId != null) {
        await localDataSource.cacheUsers(remoteUsers); // Cache for the current user
      } else {
        AppLogger.warning('No user ID to cache fetched users for.');
      }
      return remoteUsers;
    } catch (e) {
      final userId = authService.currentUser?.uid;
      if (userId != null) {
        final localUsers = await localDataSource.getUsers() as List<UserEntity>;
        if (localUsers.isNotEmpty) return localUsers;
      }
      throw Exception('Failed to load users: $e');
    }
  }

  @override
  Future<UserEntity?> getUserById(String userIdToFind) async {
    try {
      final currentUserId = authService.currentUser?.uid;
      UserEntity? localUser;
      if (currentUserId != null) {
        localUser = await localDataSource.getUserById(userIdToFind);
        if (localUser != null) return localUser;
      }
      final remoteUser = await remoteDataSource.getUserById(userIdToFind);
      return remoteUser;
    } catch (e) {
      AppLogger.error('Error getting user by ID: $e');
      return null;
    }
  }





  @override
  Future<bool> authenticateUser(String email, String password) async {
    try {

      final remoteValid = await remoteDataSource.authenticateUser(email, password);


      return remoteValid;
    } catch (e) {

      debugPrint('Authentication error: $e');
      rethrow;
    }
  }


  @override
  Future<bool> checkSessionValidity(String userId) async {
    try {
      return await localDataSource.checkSessionValidity(userId);
    } catch (e) {
      AppLogger.error('Error checking session validity: $e');
      return false;
    }
  }

  @override
  Future<String?> fetchSessionToken(String userId, String password) async {
    try {
      final token = await remoteDataSource.fetchSessionToken(userId, password);
      if (token != null) {
        await localDataSource.saveSession(
            userId, token, DateTime.now().add(const Duration(hours: 24)));
      }
      return token;
    } catch (e) {
      AppLogger.error('Error fetching session token: $e');
      return null;
    }
  }




  @override
  Future<bool> isSessionValid(String? token) async {
    if (token == null || token.isEmpty) {
      return false;
    }
    // Ideally, also verify on the backend
    return true;
  }

  @override
  Future<void> cacheUserSession(String userId, String token) async {
    await localDataSource.saveSession(
        userId, token, DateTime.now().add(const Duration(hours: 24)));
  }

  @override
  Future<String?> getCachedSession(String userId) async {
    final sessionData = await localDataSource.getSession(userId);
    if (sessionData != null && sessionData.expiryTime.isAfter(DateTime.now())) {
      return sessionData.token;
    }
    return null;
  }

  @override
  Future<void> clearCachedSession(String userId) async {
    await localDataSource.clearSession(userId);
  }

  @override
  Future<void> cacheCurrentUser(UserEntity user) async {
    final userId = authService.currentUser?.uid;
    if (userId != null) {
      await localDataSource.saveCurrentUser(user);
    } else {
      AppLogger.warning('No user ID to cache current user.');
    }
  }

  @override
  Future<void> clearCurrentUserCache() async {
    final userId = authService.currentUser?.uid;
    if (userId != null) {
      await localDataSource.clearCurrentUser();
    } else {
      AppLogger.warning('No user ID to clear current user cache.');
    }
  }

  @override
  Future<void> updateUserInventory(String userId, List inventory) {
    // TODO: implement updateUserInventory
    throw UnimplementedError();
  }
}