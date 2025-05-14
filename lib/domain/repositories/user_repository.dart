// domain/repositories/user_repository.dart

import 'package:immuno_warriors/domain/entities/user_entity.dart';

abstract class UserRepository {
  /// Retrieves the current user's profile.
  Future<UserEntity?> getCurrentUser();

  /// Saves or updates the user's profile.
  Future<void> saveUser(UserEntity user);

  /// Retrieves the user's resources.
  Future<Map<String, dynamic>> getUserResources();

  /// Updates the user's resources.
  Future<void> updateUserResources(Map<String, dynamic> resources);

  /// Retrieves the user's inventory.
  Future<List<dynamic>> getUserInventory();

  /// Adds an item to the user's inventory.
  Future<void> addItemToInventory(dynamic item); // Adjust type as needed

  /// Removes an item from the user's inventory.
  Future<void> removeItemFromInventory(dynamic item); // Adjust type as needed

  /// Clears the user's data (e.g., during logout).
  Future<void> clearUser();

  /// Retrieves the user's game settings.
  Future<Map<String, dynamic>> getUserSettings();

  /// Updates the user's game settings.
  Future<void> updateUserSettings(Map<String, dynamic> settings);

  /// Retrieves the user's game progression.
  Future<Map<String, dynamic>> getUserProgression();

  /// Updates the user's game progression.
  Future<void> updateUserProgression(Map<String, dynamic> progression);

  /// Retrieves the user's achievements.
  Future<Map<String, bool>> getUserAchievements();

  /// Updates the user's achievements.
  Future<void> updateUserAchievements(Map<String, bool> achievements);


}