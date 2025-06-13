import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:immuno_warriors/core/exceptions/app_exception.dart';
import 'package:immuno_warriors/core/exceptions/network_exceptions.dart';
import 'package:immuno_warriors/core/network/api_endpoints.dart';
import 'package:immuno_warriors/core/services/network_service.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

class DioClient {
  final Dio _dio;
  final FirebaseAuth _firebaseAuth;
  final NetworkService _networkService;
  final int _maxRetries = 3;
  final Duration _retryDelay = const Duration(seconds: 2);

  /// Crée une instance de [DioClient].
  ///
  /// Requiert un [NetworkService] pour gérer l'URL de base et vérifier la connectivité réseau.
  /// Configure les options de base Dio avec des délais et des en-têtes par défaut.
  DioClient(this._networkService)
    : _firebaseAuth = FirebaseAuth.instance,
      _dio = Dio(
        BaseOptions(
          baseUrl: ApiEndpoints.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      ) {
    _setupInterceptors();
  }

  /// Met à jour l'URL de base dynamiquement.
  ///
  /// [newUrl] : Nouvelle URL de base pour les requêtes API.
  void updateBaseUrl(String newUrl) {
    _dio.options.baseUrl = newUrl;
    AppLogger.info('URL de base mise à jour dans DioClient : $newUrl');
  }

  /// --- Configuration des intercepteurs ---

  /// Configure les intercepteurs Dio pour la journalisation, l'authentification, les retries et la gestion des erreurs.
  void _setupInterceptors() {
    // Intercepteur de journalisation en mode débogage
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          logPrint: (object) => AppLogger.info(object.toString()),
        ),
      );
    }

    // Intercepteur pour l'authentification et les retries
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Vérifier la connectivité réseau
          if (!await _networkService.isOnline) {
            AppLogger.error('Aucune connexion réseau détectée.');
            throw NoInternetException();
          }

          // Ajouter le token Firebase
          final user = _firebaseAuth.currentUser;
          if (user != null) {
            try {
              final idToken = await user.getIdToken(
                true,
              ); // Rafraîchissement si expiré
              options.headers['Authorization'] = 'Bearer $idToken';
              AppLogger.info(
                'Token Firebase ajouté à la requête : ${options.uri}',
              );
            } catch (e) {
              AppLogger.error(
                'Échec de l\'obtention du token Firebase.',
                error: e,
              );
            }
          } else {
            AppLogger.warning(
              'Aucun utilisateur Firebase connecté. Requête sans token.',
            );
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          // Gérer les erreurs 401 (token expiré ou invalide)
          if (e.response?.statusCode == 401) {
            AppLogger.error(
              'Erreur 401 : Tentative de rafraîchissement du token.',
            );
            final newToken = await _refreshToken();
            if (newToken != null) {
              e.requestOptions.headers['Authorization'] = 'Bearer $newToken';
              return _retryRequest(e.requestOptions, handler);
            } else {
              AppLogger.error(
                'Échec du rafraîchissement du token. Déconnexion requise.',
              );
              throw ApiException(
                'Session expirée. Veuillez vous reconnecter.',
                statusCode: 401,
              );
            }
          }

          // Gérer les erreurs réseau pour les retries
          if (_shouldRetry(e)) {
            return _retryWithBackoff(e, handler);
          }

          // Propager l'erreur
          _handleError(e, e.requestOptions.path, e.requestOptions.method);
          return handler.next(e);
        },
      ),
    );
  }

  /// --- Méthodes de requêtes HTTP ---

  /// Effectue une requête GET.
  ///
  /// [endpoint] : Chemin de l'endpoint API.
  /// [queryParameters] : Paramètres de requête.
  /// [options] : Options Dio supplémentaires.
  /// [cancelToken] : Jeton pour annuler la requête.
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      AppLogger.info('GET $endpoint réussi.');
      return response;
    } catch (e) {
      _handleError(e, endpoint, 'GET');
      rethrow;
    }
  }

  /// Effectue une requête POST.
  ///
  /// [endpoint] : Chemin de l'endpoint API.
  /// [data] : Données à envoyer.
  /// [options] : Options Dio supplémentaires.
  /// [cancelToken] : Jeton pour annuler la requête.
  Future<Response> post(
    String endpoint, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        options: options,
        cancelToken: cancelToken,
      );
      AppLogger.info('POST $endpoint réussi.');
      return response;
    } catch (e) {
      _handleError(e, endpoint, 'POST');
      rethrow;
    }
  }

  /// Effectue une requête PUT.
  ///
  /// [endpoint] : Chemin de l'endpoint API.
  /// [data] : Données à envoyer.
  /// [queryParameters] : Paramètres de requête.
  /// [options] : Options Dio supplémentaires.
  /// [cancelToken] : Jeton pour annuler la requête.
  Future<Response> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      AppLogger.info('PUT $endpoint réussi.');
      return response;
    } catch (e) {
      _handleError(e, endpoint, 'PUT');
      rethrow;
    }
  }

  /// Effectue une requête DELETE.
  ///
  /// [endpoint] : Chemin de l'endpoint API.
  /// [data] : Données à envoyer.
  /// [options] : Options Dio supplémentaires.
  /// [cancelToken] : Jeton pour annuler la requête.
  Future<Response> delete(
    String endpoint, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        options: options,
        cancelToken: cancelToken,
      );
      AppLogger.info('DELETE $endpoint réussi.');
      return response;
    } catch (e) {
      _handleError(e, endpoint, 'DELETE');
      rethrow;
    }
  }

  /// Effectue une requête PATCH.
  ///
  /// [endpoint] : Chemin de l'endpoint API.
  /// [data] : Données à envoyer.
  /// [options] : Options Dio supplémentaires.
  /// [cancelToken] : Jeton pour annuler la requête.
  Future<Response> patch(
    String endpoint, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        options: options,
        cancelToken: cancelToken,
      );
      AppLogger.info('PATCH $endpoint réussi.');
      return response;
    } catch (e) {
      _handleError(e, endpoint, 'PATCH');
      rethrow;
    }
  }

  /// Effectue une requête multipart pour l'upload de fichiers.
  ///
  /// [endpoint] : Chemin de l'endpoint API.
  /// [formData] : Données multipartes (ex. fichiers, champs texte).
  /// [options] : Options Dio supplémentaires.
  /// [cancelToken] : Jeton pour annuler la requête.
  Future<Response> upload(
    String endpoint, {
    required FormData formData,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: formData,
        options: options ?? Options(contentType: 'multipart/form-data'),
        cancelToken: cancelToken,
      );
      AppLogger.info('UPLOAD $endpoint réussi.');
      return response;
    } catch (e) {
      _handleError(e, endpoint, 'UPLOAD');
      rethrow;
    }
  }

  /// --- Méthodes utilitaires ---

  /// Rafraîchit le token Firebase.
  ///
  /// Retourne un nouveau token ou null si l'utilisateur n'est pas connecté.
  Future<String?> _refreshToken() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        final idToken = await user.getIdToken(true);
        AppLogger.info('Token Firebase rafraîchi avec succès.');
        return idToken;
      }
      AppLogger.warning('Aucun utilisateur connecté pour rafraîchir le token.');
      return null;
    } catch (e) {
      AppLogger.error('Échec du rafraîchissement du token Firebase.', error: e);
      return null;
    }
  }

  /// Détermine si une requête doit être retentée.
  ///
  /// Retourne true pour les erreurs réseau ou les erreurs serveur (5xx).
  bool _shouldRetry(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        (e.response?.statusCode != null && e.response!.statusCode! >= 500);
  }

  /// Retente une requête avec un délai exponentiel.
  ///
  /// [e] : Erreur Dio initiale.
  /// [handler] : Gestionnaire d'erreur Dio.
  Future<void> _retryWithBackoff(
    DioException e,
    ErrorInterceptorHandler handler,
  ) async {
    final requestOptions = e.requestOptions;
    final retryCount = (requestOptions.extra['retry_count'] ?? 0) + 1;

    if (retryCount <= _maxRetries) {
      final delay = _retryDelay * retryCount;
      AppLogger.info(
        'Retentative de la requête (Tentative $retryCount/$_maxRetries) après $delay.',
      );
      await Future.delayed(delay);
      requestOptions.extra['retry_count'] = retryCount;
      try {
        final response = await _dio.request(
          requestOptions.path,
          data: requestOptions.data,
          queryParameters: requestOptions.queryParameters,
          options: Options(
            method: requestOptions.method,
            headers: requestOptions.headers,
          ),
        );
        handler.resolve(response);
      } catch (retryError) {
        handler.reject(
          DioException(
            requestOptions: requestOptions,
            error: retryError,
            type: DioExceptionType.unknown,
          ),
        );
      }
    } else {
      AppLogger.error(
        'Nombre maximum de tentatives ($_maxRetries) dépassé pour ${requestOptions.path}.',
      );
      handler.next(e);
    }
  }

  /// Retente une requête après rafraîchissement du token.
  ///
  /// [options] : Options de la requête initiale.
  /// [handler] : Gestionnaire d'erreur Dio.
  void _retryRequest(
    RequestOptions options,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      final response = await _dio.request(
        options.path,
        data: options.data,
        queryParameters: options.queryParameters,
        options: Options(method: options.method, headers: options.headers),
      );
      handler.resolve(response);
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: e,
          type: DioExceptionType.unknown,
        ),
      );
    }
  }

  /// Gère les erreurs Dio et mappe les erreurs Firebase.
  ///
  /// [e] : Erreur survenue.
  /// [endpoint] : Endpoint de la requête.
  /// [method] : Méthode HTTP utilisée.
  void _handleError(dynamic e, String endpoint, String method) {
    String message = 'Erreur API : $method $endpoint a échoué.';
    int? statusCode;
    dynamic errorData;

    if (e is DioException) {
      statusCode = e.response?.statusCode;
      errorData = e.response?.data;
      message += ' Statut : $statusCode';

      // Mapper les erreurs API
      if (errorData is Map && errorData.containsKey('message')) {
        message += ' - ${errorData['message']}';
      } else {
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
            message += ' - Timeout de connexion.';
            break;
          case DioExceptionType.sendTimeout:
            message += ' - Timeout d\'envoi.';
            break;
          case DioExceptionType.receiveTimeout:
            message += ' - Timeout de réception.';
            break;
          case DioExceptionType.badResponse:
            message += ' - Réponse invalide du serveur.';
            break;
          case DioExceptionType.cancel:
            message += ' - Requête annulée.';
            break;
          default:
            message += ' - Erreur inconnue.';
        }
      }

      // Mapper les erreurs Firebase si présentes
      if (errorData is Map && errorData.containsKey('error')) {
        final errorCode = errorData['error']['code'] ?? '';
        message += ' - ${_mapFirebaseError(errorCode)}';
      }

      AppLogger.error(message, error: e);
    } else if (e is FirebaseAuthException) {
      statusCode = 400;
      message += ' - ${_mapFirebaseError(e.code)}';
      AppLogger.error(message, error: e);
    } else {
      message += ' - Erreur inattendue : $e';
      AppLogger.error(message, error: e);
    }

    throw ApiException(message, statusCode: statusCode, error: errorData);
  }

  /// Mappe les codes d'erreur Firebase en messages en français.
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
      case 'auth/id-token-expired':
      case 'auth/id-token-revoked':
        return 'Session expirée. Veuillez vous reconnecter.';
      case 'auth/invalid-id-token':
        return 'Token invalide.';
      default:
        return 'Erreur d\'authentification : $code';
    }
  }
}
