import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:immuno_warriors/core/constants/app_strings.dart';
import 'package:immuno_warriors/core/constants/game_constants.dart'; // Importation de GameConstants
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/domain/entities/user_entity.dart';

/// Service d'authentification gérant l'interaction avec Firebase Authentication et Firestore.
///
/// Ce service est responsable de l'inscription, la connexion, la déconnexion
/// et la gestion des profils utilisateur dans Firestore.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _usersCollection = 'users'; // Nom de la collection Firestore pour les utilisateurs

  /// Retourne l'utilisateur Firebase actuellement connecté.
  User? get currentUser => _auth.currentUser;

  /// Gère les erreurs d'authentification Firebase et retourne un message lisible.
  String _handleFirebaseAuthError(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return AppStrings.invalidEmail;
      case 'invalid-email':
        return AppStrings.invalidEmail;
      case 'weak-password':
        return AppStrings.weakPassword;
      case 'user-not-found':
      case 'wrong-password':
        return AppStrings.loginFailed;
      case 'network-request-failed':
        return AppStrings.noInternetConnection;
      case 'operation-not-allowed':
        return 'L\'opération n\'est pas autorisée. Veuillez contacter le support.';
      case 'user-disabled':
        return 'Ce compte a été désactivé.';
      default:
        return AppStrings.firebaseError;
    }
  }

  /// Crée un nouveau document utilisateur dans Firestore.
  ///
  /// Initialise les données de base du joueur (ressources, progression, etc.).
  Future<void> _createUserInFirestore(UserEntity user) async {
    AppLogger.info('Creating user profile in Firestore for ID: ${user.id}');
    try {
      // Utilise directement user.toJson() car UserEntity devrait avoir cette méthode
      // ou UserModel.fromEntity(user).toJson() si la conversion est nécessaire ici.
      // En supposant que UserEntity.toJson() existe et est suffisant pour Firestore.
      await _firestore.collection(_usersCollection).doc(user.id).set(user.toJson());
      AppLogger.info('User profile created in Firestore for ID: ${user.id}');
    } catch (e, stackTrace) {
      AppLogger.error('Error creating user profile in Firestore for ID: ${user.id}', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Met à jour un document utilisateur existant dans Firestore.
  Future<void> _updateUserInFirestore(UserEntity user) async {
    AppLogger.info('Updating user profile in Firestore for ID: ${user.id}');
    try {
      // Utilise directement user.toJson() pour la mise à jour.
      await _firestore.collection(_usersCollection).doc(user.id).update(user.toJson());
      AppLogger.info('User profile updated in Firestore for ID: ${user.id}');
    } catch (e, stackTrace) {
      AppLogger.error('Error updating user profile in Firestore for ID: ${user.id}', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Récupère un document utilisateur depuis Firestore.
  Future<UserEntity?> _getUserFromFirestore(String uid) async {
    AppLogger.info('Fetching user profile from Firestore for ID: $uid');
    try {
      final DocumentSnapshot<Map<String, dynamic>> doc =
      await _firestore.collection(_usersCollection).doc(uid).get();

      if (doc.exists && doc.data() != null) {
        AppLogger.info('User profile found in Firestore for ID: $uid');
        // Convertit directement le Map<String, dynamic> en UserEntity
        return UserEntity.fromJson(doc.data()!);
      }
      AppLogger.warning('User profile not found in Firestore for ID: $uid');
      return null;
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching user profile from Firestore for ID: $uid', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// S'inscrit un nouvel utilisateur avec l'email et le mot de passe donnés.
  ///
  /// Crée également un document utilisateur correspondant dans Firestore
  /// avec les données de jeu initiales, le nom d'utilisateur et l'URL de l'avatar.
  Future<UserEntity?> signUp({
    required String email,
    required String password,
    String? username, // Reçoit le nom d'utilisateur
    String? avatarUrl, // Reçoit l'URL de l'avatar
  }) async {
    AppLogger.info('Attempting Firebase signUp for email: $email');
    try {
      // Étape 1: Création du compte d'authentification Firebase (email/password seulement)
      final UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (userCredential.user != null) {
        final String uid = userCredential.user!.uid;
        AppLogger.info('Firebase user created with UID: $uid');


        final UserEntity user = UserEntity(
          id: uid,
          email: userCredential.user!.email ?? email,
          username: username,
          avatarUrl: avatarUrl,
          createdAt: DateTime.now(),
          lastLogin: DateTime.now(),
          resources: {
            'energy': GameConstants.initialEnergy,
            'researchPoints': GameConstants.initialBaseSlots,
            'bioMaterials': GameConstants.initialBioMaterials,
          },
          progression: {
            'level': 1,
            'xp': 0,
            'lastCombatDate': null,
          },
          achievements: {},
          inventory: [],
        );


        await _createUserInFirestore(user);
        AppLogger.info('User data saved to Firestore for new user: $email');
        return user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase Auth Error during signUp: ${e.code} - ${e.message}');
      throw Exception(_handleFirebaseAuthError(e.code)); // Lance l'exception avec le message formaté
    } catch (e, stackTrace) {
      AppLogger.error('Generic Auth Error during signUp: $e', error: e, stackTrace: stackTrace);
      throw Exception(AppStrings.registerFailed);
    }
  }

  /// Connecte un utilisateur existant.
  Future<UserEntity?> signIn({
    required String email,
    required String password,
  }) async {
    AppLogger.info('Attempting Firebase signIn for email: $email');
    try {
      final UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (userCredential.user != null) {
        final String uid = userCredential.user!.uid;
        AppLogger.info('Firebase user signed in with UID: $uid');

        // Récupère le profil complet de Firestore
        final UserEntity? user = await _getUserFromFirestore(uid);
        if (user != null) {
          // Met à jour la date de dernière connexion
          final updatedUser = user.copyWith(lastLogin: DateTime.now());
          await _updateUserInFirestore(updatedUser);
          AppLogger.info('User profile updated in Firestore after sign in: ${user.email}');
          return updatedUser;
        } else {
          AppLogger.warning('User profile not found in Firestore after successful Firebase sign in for UID: $uid');
          throw Exception(AppStrings.profileNotFound);
        }
      }
      return null;
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase Auth Error during signIn: ${e.code} - ${e.message}');
      throw Exception(_handleFirebaseAuthError(e.code));
    } catch (e, stackTrace) {
      AppLogger.error('Generic Auth Error during signIn: $e', error: e, stackTrace: stackTrace);
      throw Exception(AppStrings.loginFailed);
    }
  }

  /// Déconnecte l'utilisateur courant.
  Future<void> signOut() async {
    AppLogger.info('Attempting Firebase signOut.');
    try {
      await _auth.signOut();
      AppLogger.info('Firebase signOut successful.');
    } catch (e, stackTrace) {
      AppLogger.error('Error during Firebase signOut: $e', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Envoie un email de réinitialisation de mot de passe.
  Future<void> sendPasswordResetEmail({required String email}) async {
    AppLogger.info('Attempting to send password reset email to: $email');
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      AppLogger.info('Password reset email sent to: $email');
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase Auth Error sending password reset email: ${e.code} - ${e.message}');
      throw Exception(_handleFirebaseAuthError(e.code));
    } catch (e, stackTrace) {
      AppLogger.error('Generic Error sending password reset email: $e', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Envoie une vérification d'email à l'utilisateur actuel.
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      AppLogger.info('Attempting to send email verification for user: ${user.email}');
      try {
        await user.sendEmailVerification();
        AppLogger.info('Email verification sent successfully for user: ${user.email}');
      } on FirebaseAuthException catch (e) {
        AppLogger.error('Firebase Auth Error (Verification): ${e.code} - ${e.message}');
        throw Exception(_handleFirebaseAuthError(e.code));
      } catch (e, stackTrace) {
        AppLogger.error('Generic Error (Verification): $e', error: e, stackTrace: stackTrace);
        throw Exception(AppStrings.emailNotVerified);
      }
    } else if (user == null) {
      AppLogger.warning('Cannot send email verification: No current user logged in.');
      throw Exception('Aucun utilisateur connecté pour la vérification de l\'email.');
    } else if (user.emailVerified) {
      AppLogger.info('Email for user ${user.email} is already verified.');
    }
  }

  /// Vérifie si l'email de l'utilisateur actuel est vérifié.
  bool isEmailVerified() {
    final user = _auth.currentUser;
    final verified = user?.emailVerified ?? false;
    AppLogger.info('Email verification status for current user: $verified');
    return verified;
  }
}
