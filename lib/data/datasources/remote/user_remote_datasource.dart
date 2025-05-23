import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/data/models/user_model.dart';
import 'package:immuno_warriors/domain/entities/user_entity.dart';

/// Provides services for interacting with the user data in Firestore.
class UserRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  static const String _usersCollection = 'users';

  // Use constructor injection for better testability
  UserRemoteDataSource({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  /// Retrieves a user's profile from Firestore.
  Future<UserModel> getUserProfile(String userId) async {
    try {
      final snapshot =
      await _firestore.collection(_usersCollection).doc(userId).get();
      if (snapshot.exists && snapshot.data() != null) {
        // Ensure 'id' is in the data for UserModel.fromJson
        final userData = snapshot.data()!..['id'] = snapshot.id;
        return UserModel.fromJson(userData);
      }
      throw Exception('User not found');
    } catch (e) {
      AppLogger.error('Error getting user profile: $e');
      rethrow; // Important: rethrow the original exception
    }
  }

  /// Retrieves a specific user by their ID from Firestore.
  Future<UserEntity?> getUserById(String userId) async {
    try {
      final snapshot =
      await _firestore.collection(_usersCollection).doc(userId).get();
      if (snapshot.exists && snapshot.data() != null) {
        final userData = snapshot.data()!..['id'] = snapshot.id;
        return UserEntity.fromJson(userData);
      }
      return null; // User not found
    } catch (e) {
      AppLogger.error('Error getting user by ID: $e');
      return null; // Return null in case of an error as well
    }
  }


  /// Retrieves all users from Firestore.
  Future<List<UserEntity>> getUsers() async {
    try {
      final snapshot = await _firestore.collection(_usersCollection).get();
      return snapshot.docs.map((doc) {
        // Ensure 'id' is in the data for UserEntity.fromJson
        final userData = doc.data()..['id'] = doc.id;
        return UserEntity.fromJson(userData);
      }).toList();
    } catch (e) {
      AppLogger.error('Error getting users: $e');
      rethrow;
    }
  }

  /// Authenticates a user using email and password.
  /// This method only checks credentials against Firebase Auth.
  /// It does NOT handle custom authentication or session management.
  Future<bool> authenticateUser(String email, String password) async {
    try {
      // Sign in with email and password using Firebase Auth
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true; // Authentication successful
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors
      AppLogger.error('Authentication error: ${e.message}');
      //  Rethrow the FirebaseAuthException to be handled by the caller.
      throw e;
    } catch (e) {
      // Handle other types of errors
      AppLogger.error('Authentication error: $e');
      throw Exception('Authentication failed: $e'); // Wrap for consistency
    }
  }

  /// Fetches a session token for a user.  This is for custom authentication.
  Future<String?> fetchSessionToken(String userId, String password) async {
    try {
      // Simulate a custom authentication check against Firestore.
      //  DO NOT STORE PASSWORDS IN FIRESTORE IN REAL APPLICATION.
      final userDoc = await _firestore.collection(_usersCollection).doc(userId).get();
      if (!userDoc.exists) {
        AppLogger.warning('User not found during session token fetch.');
        return null;
      }

      final storedPassword = userDoc.data()?['password'] as String?; // Get stored password
      if (storedPassword == null || storedPassword != password) {
        // DO NOT COMPARE PASSWORDS DIRECTLY IN PRODUCTION
        AppLogger.warning('Incorrect password for user: $userId');
        return null;
      }

      // In a real app, you would generate a secure session token here,
      //  and potentially store it in Firestore.  This is a SIMULATION.
      final sessionToken =
          '${userId}_session_${DateTime.now().millisecondsSinceEpoch}'; // Insecure
      return sessionToken;
    } catch (e) {
      AppLogger.error('Error fetching session token: $e');
      rethrow;
    }
  }

  /// Retrieves a user's settings from Firestore.
  Future<Map<String, dynamic>> getUserSettings(String userId) async {
    try {
      final snapshot =
      await _firestore.collection(_usersCollection).doc(userId).get();
      if (snapshot.exists &&
          snapshot.data() != null &&
          snapshot.data()!.containsKey('settings')) {
        return Map<String, dynamic>.from(
            snapshot.data()!['settings'] as Map);
      } else {
        return {};
      }
    } catch (e) {
      AppLogger.error('Error getting user settings from Firestore: $e');
      rethrow;
    }
  }

  /// Updates a user's settings in Firestore.
  Future<void> updateUserSettings(
      String userId, Map<String, dynamic> settings) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).update(settings);
    } catch (e) {
      AppLogger.error('Error updating user settings in Firestore: $e');
      rethrow;
    }
  }

  /// Retrieves a user's resources from Firestore.
  Future<Map<String, dynamic>> getUserResources(String userId) async {
    try {
      final snapshot =
      await _firestore.collection(_usersCollection).doc(userId).get();
      if (snapshot.exists &&
          snapshot.data() != null &&
          snapshot.data()!.containsKey('resources')) {
        return Map<String, dynamic>.from(snapshot.data()!['resources'] as Map);
      } else {
        return {};
      }
    } catch (e) {
      AppLogger.error('Error getting user resources from Firestore: $e');
      rethrow;
    }
  }

  /// Updates a user's resources in Firestore.
  Future<void> updateUserResources(
      String userId, Map<String, dynamic> resources) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).update({
        'resources': resources
      }); // Ensure you update the 'resources' field.
    } catch (e) {
      AppLogger.error('Error updating user resources in Firestore: $e');
      rethrow;
    }
  }

  /// Retrieves a user's inventory from Firestore.
  Future<List<dynamic>> getUserInventory(String userId) async {
    try {
      final snapshot =
      await _firestore.collection(_usersCollection).doc(userId).get();
      if (snapshot.exists &&
          snapshot.data() != null &&
          snapshot.data()!.containsKey('inventory')) {
        return List<dynamic>.from(snapshot.data()!['inventory'] as List);
      } else {
        return [];
      }
    } catch (e) {
      AppLogger.error('Error getting user inventory from Firestore: $e');
      rethrow;
    }
  }

  /// Adds an item to a user's inventory in Firestore.
  Future<void> addItemToInventory(String userId, dynamic item) async {
    try {
      final userDocRef = _firestore.collection(_usersCollection).doc(userId);

      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(userDocRef);
        if (snapshot.exists && snapshot.data() != null) {
          final currentInventory =
          List<dynamic>.from(snapshot.data()!['inventory'] as List? ?? []);
          currentInventory.add(item);
          transaction.update(userDocRef, {'inventory': currentInventory});
        } else {
          transaction.set(userDocRef, {'inventory': [item]},
              SetOptions(merge: true));
        }
      });
    } catch (e) {
      AppLogger.error('Error adding item to inventory in Firestore: $e');
      rethrow;
    }
  }

  /// Removes an item from a user's inventory in Firestore.
  Future<void> removeItemFromInventory(String userId, dynamic item) async {
    try {
      final userDocRef = _firestore.collection(_usersCollection).doc(userId);

      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(userDocRef);
        if (snapshot.exists && snapshot.data() != null) {
          final currentInventory =
          List<dynamic>.from(snapshot.data()!['inventory'] as List? ?? []);
          //  Use where to create a new list without the item.
          final updatedInventory =
          currentInventory.where((element) => element != item).toList();

          transaction.update(userDocRef, {'inventory': updatedInventory});
        }
      });
    } catch (e) {
      AppLogger.error(
          'Error removing item from inventory in Firestore: $e');
      rethrow;
    }
  }

  /// Retrieves a user's progression data from Firestore.
  Future<Map<String, dynamic>> getUserProgression(String userId) async {
    try {
      final snapshot =
      await _firestore.collection(_usersCollection).doc(userId).get();
      if (snapshot.exists &&
          snapshot.data() != null &&
          snapshot.data()!.containsKey('progression')) {
        return Map<String, dynamic>.from(
            snapshot.data()!['progression'] as Map);
      } else {
        return {};
      }
    } catch (e) {
      AppLogger.error('Error getting user progression from Firestore: $e');
      rethrow;
    }
  }

  /// Updates a user's progression data in Firestore.
  Future<void> updateUserProgression(
      String userId, Map<String, dynamic> progression) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).update({
        'progression': progression
      }); // Ensure you update the 'progression' field
    } catch (e) {
      AppLogger.error('Error updating user progression in Firestore: $e');
      rethrow;
    }
  }

  /// Retrieves a user's achievements from Firestore.
  Future<Map<String, bool>> getUserAchievements(String userId) async {
    try {
      final snapshot =
      await _firestore.collection(_usersCollection).doc(userId).get();
      if (snapshot.exists &&
          snapshot.data() != null &&
          snapshot.data()!.containsKey('achievements')) {
        return Map<String, bool>.from(
            snapshot.data()!['achievements'] as Map);
      } else {
        return {};
      }
    } catch (e) {
      AppLogger.error('Error getting user achievements from Firestore: $e');
      rethrow;
    }
  }

  /// Updates a user's achievements in Firestore.
  Future<void> updateUserAchievements(
      String userId, Map<String, bool> achievements) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).update({
        'achievements': achievements
      }); // Ensure you update the 'achievements' field.
    } catch (e) {
      AppLogger.error('Error updating user achievements in Firestore: $e');
      rethrow;
    }
  }
}