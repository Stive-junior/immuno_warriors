import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/data/models/user_model.dart';

class UserRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _usersCollection = 'users';

  Future<UserModel> getUserProfile(String userId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
      await _firestore.collection(_usersCollection).doc(userId).get();

      if (snapshot.exists && snapshot.data() != null) {
        return UserModel.fromJson(snapshot.data()!);
      } else {
        throw Exception('User profile not found for ID: $userId');
      }
    } catch (e) {
      AppLogger.error('Error getting user profile from Firestore: $e');
      rethrow;
    }
  }



  Future<void> updateUserSettings(
      String userId, Map<String, dynamic> settings) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).update(settings);
    } catch (e) {
      AppLogger.error('Error updating user settings in Firestore: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUserResources(String userId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
      await _firestore.collection(_usersCollection).doc(userId).get();
      if (snapshot.exists &&
          snapshot.data() != null &&
          snapshot.data()!.containsKey('resources')) {
        return {'resources': snapshot.data()!['resources']}; // Adjust based on your actual data structure
      } else {
        return {};
      }
    } catch (e) {
      AppLogger.error('Error getting user resources from Firestore: $e');
      rethrow;
    }
  }

  Future<void> updateUserResources(
      String userId, Map<String, dynamic> resources) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).update(resources);
    } catch (e) {
      AppLogger.error('Error updating user resources in Firestore: $e');
      rethrow;
    }
  }

  Future<List<dynamic>> getUserInventory(String userId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
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

  Future<void> addItemToInventory(String userId, dynamic item) async {
    try {
      final DocumentReference<Map<String, dynamic>> userDocRef =
      _firestore.collection(_usersCollection).doc(userId);

      await _firestore.runTransaction((transaction) async {
        final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await transaction.get(userDocRef);
        if (snapshot.exists &&
            snapshot.data() != null &&
            snapshot.data()!.containsKey('inventory')) {
          final List<dynamic> currentInventory =
          List<dynamic>.from(snapshot.data()!['inventory'] as List);
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

  Future<void> removeItemFromInventory(String userId, dynamic item) async {
    try {
      final DocumentReference<Map<String, dynamic>> userDocRef =
      _firestore.collection(_usersCollection).doc(userId);

      await _firestore.runTransaction((transaction) async {
        final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await transaction.get(userDocRef);
        if (snapshot.exists &&
            snapshot.data() != null &&
            snapshot.data()!.containsKey('inventory')) {
          final List<dynamic> currentInventory =
          List<dynamic>.from(snapshot.data()!['inventory'] as List);
          currentInventory.remove(item); // Be cautious with object equality
          transaction.update(userDocRef, {'inventory': currentInventory});
        }
      });
    } catch (e) {
      AppLogger.error(
          'Error removing item from inventory in Firestore: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUserSettings(String userId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
      await _firestore.collection(_usersCollection).doc(userId).get();
      if (snapshot.exists &&
          snapshot.data() != null &&
          snapshot.data()!.containsKey('settings')) {
        return Map<String, dynamic>.from(snapshot.data()!['settings'] as Map);
      } else {
        return {};
      }
    } catch (e) {
      AppLogger.error('Error getting user settings from Firestore: $e');
      rethrow;
    }
  }



  Future<Map<String, dynamic>> getUserProgression(String userId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
      await _firestore.collection(_usersCollection).doc(userId).get();
      if (snapshot.exists && snapshot.data() != null && snapshot.data()!.containsKey('progression')) {
        return Map<String, dynamic>.from(snapshot.data()!['progression'] as Map);
      } else {
        return {};
      }
    } catch (e) {
      AppLogger.error('Error getting user progression from Firestore: $e');
      rethrow;
  }
  }

  Future<void> updateUserProgression(String userId, Map<String, dynamic> progression) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).update({'progression': progression});
    } catch (e) {
      AppLogger.error('Error updating user progression in Firestore: $e');
      rethrow;
    }
  }

  Future<Map<String, bool>> getUserAchievements(String userId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
      await _firestore.collection(_usersCollection).doc(userId).get();
      if (snapshot.exists && snapshot.data() != null && snapshot.data()!.containsKey('achievements')) {
        return Map<String, bool>.from(snapshot.data()!['achievements'] as Map);
      } else {
        return {};
      }
    } catch (e) {
      AppLogger.error('Error getting user achievements from Firestore: $e');
      rethrow;
    }
  }

  Future<void> updateUserAchievements(String userId, Map<String, bool> achievements) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).update({'achievements': achievements});
    } catch (e) {
      AppLogger.error('Error updating user achievements in Firestore: $e');
      rethrow;
    }
  }

// No direct "clearUser" needed here, as sign-out is handled by AuthService
}