import 'package:dartz/dartz.dart';
import '../../domain/entities/user_entity.dart';
import '../../core/exceptions/app_exception.dart';
import '../../data/models/user_model.dart';

abstract class UserRepository {
  /// Retrieves the current authenticated user.
  Future<Either<AppException, UserEntity?>> getCurrentUser();

  /// Saves or updates a user's data.
  Future<Either<AppException, void>> saveUser(UserEntity user);

  /// Retrieves the user's resources.
  Future<Either<AppException, Map<String, dynamic>>> getUserResources();

  /// Updates the user's resources.
  Future<Either<AppException, void>> updateUserResources(
    Map<String, dynamic> resources,
  );

  /// Retrieves the user's inventory.
  Future<Either<AppException, List<dynamic>>> getUserInventory();

  /// Adds an item to the user's inventory.
  Future<Either<AppException, void>> addItemToInventory(dynamic item);

  /// Removes an item from the user's inventory.
  Future<Either<AppException, void>> removeItemFromInventory(dynamic item);

  /// Updates the entire user inventory.
  Future<Either<AppException, void>> updateUserInventory(
    String userId,
    List<dynamic> inventory,
  );

  /// Clears all user data.
  Future<Either<AppException, void>> clearUser();

  /// Retrieves the user's settings.
  Future<Either<AppException, Map<String, dynamic>>> getUserSettings();

  /// Updates the user's settings.
  Future<Either<AppException, void>> updateUserSettings(
    Map<String, dynamic> settings,
  );

  /// Retrieves the user's progression.
  Future<Either<AppException, Map<String, dynamic>>> getUserProgression();

  /// Updates the user's progression.
  Future<Either<AppException, void>> updateUserProgression(
    Map<String, dynamic> progression,
  );

  /// Retrieves the user's achievements.
  Future<Either<AppException, Map<String, bool>>> getUserAchievements();

  /// Updates the user's achievements.
  Future<Either<AppException, void>> updateUserAchievements(
    Map<String, bool> achievements,
  );

  /// Retrieves a list of all users (e.g., for leaderboards).
  Future<Either<AppException, List<UserEntity>>> getUsers();

  /// Retrieves a user by their ID.
  Future<Either<AppException, UserEntity?>> getUserById(String userId);

  /// Authenticates a user with ID and password.
  Future<Either<AppException, bool>> authenticateUser(
    String userId,
    String password,
  );

  /// Checks if a user's session is valid.
  Future<Either<AppException, bool>> checkSessionValidity(String userId);

  /// Fetches a session token for a user.
  Future<Either<AppException, String?>> fetchSessionToken(
    String userId,
    String password,
  );

  /// Verifies if a session token is valid.
  Future<Either<AppException, bool>> isSessionValid(String? token);

  /// Caches a user session locally.
  Future<Either<AppException, void>> cacheUserSession(
    String userId,
    String token,
  );

  /// Retrieves a cached session for a user.
  Future<Either<AppException, String?>> getCachedSession(String userId);

  /// Clears a cached session for a user.
  Future<Either<AppException, void>> clearCachedSession(String userId);

  /// Caches the current user's data locally.
  Future<Either<AppException, void>> cacheCurrentUser(UserModel user);

  /// Clears the cached current user data.
  Future<Either<AppException, void>> clearCurrentUserCache();

  /// Updates user profile (e.g., username, avatar).
  Future<Either<AppException, void>> updateUserProfile(
    String userId,
    Map<String, dynamic> profileData,
  );

  /// Retrieves a paginated list of users for social features.
  Future<Either<AppException, List<UserEntity>>> getPaginatedUsers({
    int page = 1,
    int limit = 20,
  });

  /// Refreshes a user's session token.
  Future<Either<AppException, String?>> refreshSessionToken(String userId);
}
