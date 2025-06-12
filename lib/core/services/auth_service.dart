import 'package:dio/dio.dart';
import 'package:immuno_warriors/core/exceptions/app_exception.dart';
import 'package:immuno_warriors/core/exceptions/network_exceptions.dart';
import 'package:immuno_warriors/core/network/api_endpoints.dart';
import 'package:immuno_warriors/core/network/dio_client.dart';
import 'package:immuno_warriors/core/services/local_storage_service.dart';
import 'package:immuno_warriors/core/services/network_service.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

/// Service pour gérer les opérations d'authentification.
class AuthService {
  final DioClient _dioClient;
  final LocalStorageService _localStorage;
  final NetworkService _networkService;

  AuthService(this._dioClient, this._localStorage, this._networkService);

  /// Vérifie le token JWT.
  Future<void> verifyToken() async {
    try {
      if (!await _networkService.isOnline) {
        throw NoInternetException();
      }
      await _dioClient.get(ApiEndpoints.verifyToken);
      AppLogger.info('Token JWT vérifié avec succès.');
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
      rethrow;
    }
  }

  /// Inscrit un nouvel utilisateur.
  Future<void> signup(String email, String password, String username) async {
    try {
      if (!await _networkService.isOnline) {
        throw NoInternetException();
      }
      final data = {'email': email, 'password': password, 'username': username};
      final response = await _dioClient.post(ApiEndpoints.signup, data: data);
      final userId = response.data['userId'] as String?;
      final token = response.data['token'] as String?;
      if (userId != null && token != null) {
        await _localStorage.saveSession(
          userId,
          token,
          DateTime.now().add(const Duration(days: 7)),
        );
        AppLogger.info('Utilisateur inscrit avec succès : $userId');
      } else {
        throw ApiException('Réponse d\'inscription invalide.');
      }
    } on DioException catch (e) {
      AppLogger.error('Échec de l\'inscription : $e');
      throw ApiException(
        'Échec de l\'inscription.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    } catch (e) {
      AppLogger.error('Erreur inattendue lors de l\'inscription : $e');
      rethrow;
    }
  }

  /// Connecte un utilisateur.
  Future<void> signin(String email, String password) async {
    try {
      if (!await _networkService.isOnline) {
        throw NoInternetException();
      }
      final data = {'email': email, 'password': password};
      final response = await _dioClient.post(ApiEndpoints.signin, data: data);
      final userId = response.data['userId'] as String?;
      final token = response.data['token'] as String?;
      if (userId != null && token != null) {
        await _localStorage.saveSession(
          userId,
          token,
          DateTime.now().add(const Duration(days: 7)),
        );
        AppLogger.info('Utilisateur connecté avec succès : $userId');
      } else {
        throw ApiException('Réponse de connexion invalide.');
      }
    } on DioException catch (e) {
      AppLogger.error('Échec de la connexion : $e');
      throw ApiException(
        'Échec de la connexion.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    } catch (e) {
      AppLogger.error('Erreur inattendue lors de la connexion : $e');
      rethrow;
    }
  }

  /// Rafraîchit le token JWT.
  Future<void> refreshToken(String refreshToken) async {
    try {
      if (!await _networkService.isOnline) {
        throw NoInternetException();
      }
      final data = {'refreshToken': refreshToken};
      final response = await _dioClient.post(
        ApiEndpoints.refreshToken,
        data: data,
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

  /// Déconnecte l'utilisateur.
  Future<void> signout() async {
    try {
      final userId = _localStorage.getCurrentUserCache('current_user')?.id;
      if (await _networkService.isOnline) {
        await _dioClient.post(ApiEndpoints.signout);
      }
      await _localStorage.clearSession(userId!);
      AppLogger.info('Utilisateur déconnecté avec succès : $userId');
    } on DioException catch (e) {
      AppLogger.error('Échec de la déconnexion : $e');
      throw ApiException(
        'Échec de la déconnexion.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    } catch (e) {
      AppLogger.error('Erreur inattendue lors de la déconnexion : $e');
      rethrow;
    }
  }
}
