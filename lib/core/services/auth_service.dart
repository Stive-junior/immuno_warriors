import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:immuno_warriors/core/constants/game_constants.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/core/constants/app_strings.dart';
import 'package:immuno_warriors/data/models/user_model.dart';
import 'package:immuno_warriors/domain/entities/user_entity.dart';

/// Provides authentication-related services using Firebase Authentication.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Gets the currently logged-in user, if any.
  User? get currentUser => _auth.currentUser;

  /// Signs up a new user with the given email and password.
  ///
  /// Also creates a corresponding user document in Firestore.
  Future<UserEntity?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(), // Garder trim() pour Firebase
        password: password.trim(), // Garder trim() pour Firebase
      );

      if (userCredential.user != null) {
        final UserEntity user = UserEntity(
          id: userCredential.user!.uid,
          email: userCredential.user!.email ?? email,
          resources: 100,
          researchPoints: 0,
          bioMaterials: GameConstants.initialBioMaterials,

        );

        await _createUserInFirestore(user);
        return user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      AppLogger.log('Firebase Auth Error: ${e.message}');
      throw _handleFirebaseAuthError(e.code);
    } catch (e) {
      AppLogger.log('Generic Auth Error: $e');
      throw Exception(AppStrings.registerFailed);
    }
  }

  /// Logs in a user with the given email and password.
  Future<UserEntity?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (userCredential.user != null) {
        return await _getUserFromFirestore(userCredential.user!.uid);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      AppLogger.log('Firebase Auth Error: ${e.message}');
      throw _handleFirebaseAuthError(e.code);
    } catch (e) {
      AppLogger.log('Generic Auth Error: $e');
      throw Exception(AppStrings.loginFailed);
    }
  }

  /// Logs out the current user.
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      AppLogger.log('Error signing out: $e');
      rethrow;
    }
  }

  /// Sends a password reset email to the given email address.
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email.trim(), // Garder trim() pour Firebase
      );
    } on FirebaseAuthException catch (e) {
      AppLogger.log('Firebase Auth Error: ${e.message}');
      throw _handleFirebaseAuthError(e.code);
    } catch (e) {
      AppLogger.log('Generic Auth Error: $e');
      rethrow;
    }
  }

  /// Creates a new user document in Firestore.
  Future<void> _createUserInFirestore(UserEntity user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(
        UserModel.fromEntity(user).toJson(),
      );
    } catch (e) {
      AppLogger.log('Error creating user in Firestore: $e');
      rethrow;
    }
  }

  /// Retrieves a user document from Firestore by ID.
  Future<UserEntity?> _getUserFromFirestore(String uid) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
      await _firestore.collection('users').doc(uid).get();

      if (snapshot.exists) {
        return UserModel.fromJson(snapshot.data()!).toEntity();
      }
      return null;
    } catch (e) {
      AppLogger.log('Error getting user from Firestore: $e');
      rethrow;
    }
  }

  /// Handles Firebase Authentication error codes and returns a user-friendly exception.
  Exception _handleFirebaseAuthError(String errorCode) {
    switch (errorCode) {
      case 'invalid-email':
        return Exception(AppStrings.invalidEmail);
      case 'user-disabled':
        return Exception('This account has been disabled.');
      case 'user-not-found':
        return Exception('No user found with that email.');
      case 'wrong-password':
        return Exception('Wrong password.');
      case 'email-already-in-use':
        return Exception(
            'The email address is already in use by another account.');
      case 'operation-not-allowed':
        return Exception('Operation not allowed.');
      case 'weak-password':
        return Exception(AppStrings.invalidPassword);
      default:
        return Exception('An unknown error occurred. Please try again.');
    }
  }

}