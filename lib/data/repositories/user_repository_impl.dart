// data/repositories/user_repository_impl.dart

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
      if (localUser != null && localUser.id == userId) {
        return localUser.toEntity();
      }
      final remoteUser = await remoteDataSource.getUserProfile(userId);
      localDataSource.saveUser(remoteUser);
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
      localDataSource.saveUser(model);
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
      // Optionally update local data
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
      // Optionally update local cache
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
      // Optionally update local cache
    } catch (e) {
      AppLogger.error('Error removing item from inventory: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      await localDataSource.clearUser();
      AppLogger.info('Local user data cleared.');
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

}