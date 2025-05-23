import 'package:immuno_warriors/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity?> getCurrentUser();
  Future<void> saveUser(UserEntity user);
  Future<Map<String, dynamic>> getUserResources();
  Future<void> updateUserResources(Map<String, dynamic> resources);
  Future<List<dynamic>> getUserInventory();
  Future<void> addItemToInventory(dynamic item);
  Future<void> removeItemFromInventory(dynamic item);
  Future<void> clearUser();
  Future<Map<String, dynamic>> getUserSettings();
  Future<void> updateUserSettings(Map<String, dynamic> settings);
  Future<Map<String, dynamic>> getUserProgression();
  Future<void> updateUserProgression(Map<String, dynamic> progression);
  Future<Map<String, bool>> getUserAchievements();
  Future<void> updateUserAchievements(Map<String, bool> achievements);
  Future<List<UserEntity>> getUsers();


  Future<UserEntity?> getUserById(String userId);
 


  Future<bool> authenticateUser(String userId, String password);
  Future<bool> checkSessionValidity(String userId);
  Future<String?> fetchSessionToken(String userId, String password);
  Future<bool> isSessionValid(String? token);
  Future<void> cacheUserSession(String userId, String token);
  Future<String?> getCachedSession(String userId);
  Future<void> clearCachedSession(String userId);
  Future<void> cacheCurrentUser(UserEntity user);
  Future<void> clearCurrentUserCache();



  Future<void> updateUserInventory(String userId, List<dynamic> inventory);

}