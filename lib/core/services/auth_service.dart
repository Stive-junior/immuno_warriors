import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:immuno_warriors/core/exceptions/app_exception.dart';
import 'package:immuno_warriors/core/exceptions/network_exceptions.dart';
import 'package:immuno_warriors/core/network/api_endpoints.dart';
import 'package:immuno_warriors/core/network/dio_client.dart';
import 'package:immuno_warriors/core/services/local_storage_service.dart';
import 'package:immuno_warriors/core/services/network_service.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

class AuthService {
  final DioClient _dioClient;
  final LocalStorageService _localStorage;
  final NetworkService _networkService;
  final FirebaseAuth _firebaseAuth;

  AuthService(
    this._dioClient,
    this._localStorage,
    this._networkService, {
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  /// Vérifie le token JWT en local et sur le serveur.
  Future<bool> verifyToken() async {
    try {
      if (!await _networkService.isOnline) {
        throw NoInternetException();
      }
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        AppLogger.warning('Aucun utilisateur connecté localement');
        return false;
      }
      final idToken = await user.getIdToken();
      final response = await _dioClient.get(
        ApiEndpoints.verifyToken,
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );
      AppLogger.info(
        'Token JWT vérifié avec succès : ${response.data['userId']}',
      );
      return true;
    } on DioException catch (e) {
      AppLogger.error('Échec de la vérification du token : $e');
      throw ApiException(
        'Échec de la vérification du token.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    } catch (e) {
      AppLogger.error(
        'Erreur inattendue lors de la vérification du token : $e',
      );
      return false;
    }
  }

  /// Inscrit un nouvel utilisateur avec Firebase Auth et synchronise avec le serveur.
  Future<void> signup(String email, String password, String username) async {
    try {
      if (!await _networkService.isOnline) {
        throw NoInternetException();
      }
      // Inscription avec Firebase Auth
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) {
        throw ApiException('Échec de la création de l\'utilisateur.');
      }
      await user.updateDisplayName(username);
      final idToken = await user.getIdToken();

      // Synchronisation avec le serveur
      final response = await _dioClient.post(
        ApiEndpoints.signup,
        data: {'email': email, 'username': username, 'firebaseToken': idToken},
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );

      final userId = response.data['user']['id'] as String?;
      final serverToken = response.data['token'] as String?;
      if (userId != null && serverToken != null) {
        await _localStorage.saveSession(
          userId,
          serverToken,
          DateTime.now().add(const Duration(days: 7)),
        );
        AppLogger.info('Utilisateur inscrit avec succès : $userId');
      } else {
        throw ApiException('Réponse d\'inscription invalide.');
      }
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Erreur Firebase lors de l\'inscription : $e');
      throw ApiException(_mapFirebaseError(e.code), statusCode: 400);
    } on DioException catch (e) {
      AppLogger.error('Échec de la synchronisation serveur : $e');
      throw ApiException(
        'Échec de l\'inscription côté serveur.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    } catch (e) {
      AppLogger.error('Erreur inattendue lors de l\'inscription : $e');
      rethrow;
    }
  }

  /// Connecte un utilisateur avec Firebase Auth et synchronise avec le serveur.
  Future<void> signin(String email, String password) async {
    try {
      if (!await _networkService.isOnline) {
        throw NoInternetException();
      }
      // Connexion avec Firebase Auth
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) {
        throw ApiException('Échec de la connexion.');
      }
      final idToken = await user.getIdToken();

      // Synchronisation avec le serveur
      final response = await _dioClient.post(
        ApiEndpoints.signin,
        data: {'email': email, 'firebaseToken': idToken},
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );

      final userId = response.data['user']['id'] as String?;
      final serverToken = response.data['token'] as String?;
      if (userId != null && serverToken != null) {
        await _localStorage.saveSession(
          userId,
          serverToken,
          DateTime.now().add(const Duration(days: 7)),
        );
        AppLogger.info('Utilisateur connecté avec succès : $userId');
        AppLogger.setContext(
          userId: userId,
          sessionId: 'session-${DateTime.now().millisecondsSinceEpoch}',
        );
      } else {
        throw ApiException('Réponse de connexion invalide.');
      }
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Erreur Firebase lors de la connexion : $e');
      throw ApiException(_mapFirebaseError(e.code), statusCode: 400);
    } on DioException catch (e) {
      AppLogger.error('Échec de la synchronisation serveur : $e');
      throw ApiException(
        'Échec de la connexion côté serveur.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    } catch (e) {
      AppLogger.error('Erreur inattendue lors de la connexion : $e');
      rethrow;
    }
  }

  /// Rafraîchit le token Firebase et synchronise avec le serveur.
  Future<void> refreshToken() async {
    try {
      if (!await _networkService.isOnline) {
        throw NoInternetException();
      }
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw ApiException('Aucun utilisateur connecté.');
      }
      final idToken = await user.getIdToken(true); // Force le rafraîchissement
      final response = await _dioClient.post(
        ApiEndpoints.refreshToken,
        data: {'firebaseToken': idToken},
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );

      final userId = response.data['userId'] as String?;
      final newToken = response.data['token'] as String?;
      if (userId != null && newToken != null) {
        await _localStorage.saveSession(
          userId,
          newToken,
          DateTime.now().add(const Duration(days: 7)),
        );
        AppLogger.info(
          'Token rafraîchi avec succès pour l\'utilisateur : $userId',
        );
      } else {
        throw ApiException('Réponse de rafraîchissement de token invalide.');
      }
    } on DioException catch (e) {
      AppLogger.error('Échec du rafraîchissement du token : $e');
      throw ApiException(
        'Échec du rafraîchissement du token.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    } catch (e) {
      AppLogger.error(
        'Erreur inattendue lors du rafraîchissement du token : $e',
      );
      rethrow;
    }
  }

  /// Déconnecte l'utilisateur localement et sur le serveur.
  Future<void> signout() async {
    try {
      final userId = _localStorage.getCurrentUserCache('current_user')?.id;
      if (await _networkService.isOnline) {
        final user = _firebaseAuth.currentUser;
        if (user != null) {
          final idToken = await user.getIdToken();
          await _dioClient.post(
            ApiEndpoints.signout,
            options: Options(headers: {'Authorization': 'Bearer $idToken'}),
          );
        }
      }
      await _firebaseAuth.signOut();
      await _localStorage.clearSession(userId ?? '');
      AppLogger.info('Utilisateur déconnecté avec succès : $userId');
    } on DioException catch (e) {
      AppLogger.error('Échec de la déconnexion serveur : $e');
      throw ApiException(
        'Échec de la déconnexion côté serveur.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    } catch (e) {
      AppLogger.error('Erreur inattendue lors de la déconnexion : $e');
      rethrow;
    }
  }

  /// Mappe les erreurs Firebase en messages lisibles.
  String _mapFirebaseError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé.';
      case 'invalid-email':
        return 'Email invalide.';
      case 'weak-password':
        return 'Mot de passe trop faible.';
      case 'user-not-found':
      case 'wrong-password':
        return 'Email ou mot de passe incorrect.';
      default:
        return 'Erreur d\'authentification : $code';
    }
  }
}
