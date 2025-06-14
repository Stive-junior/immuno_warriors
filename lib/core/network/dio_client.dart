import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:immuno_warriors/core/exceptions/app_exception.dart';
import 'package:immuno_warriors/core/exceptions/network_exceptions.dart';
import 'package:immuno_warriors/core/network/api_endpoints.dart';
import 'package:immuno_warriors/core/services/network_service.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

class DioClient {
  final Dio _dio;
  final FirebaseAuth _firebaseAuth;
  final NetworkService _networkService;
  // ignore: unused_field
  final Ref _ref;
  final int _maxRetries = 3;
  final Duration _retryDelay = const Duration(seconds: 2);

  DioClient({
    required Ref ref,
    required NetworkService networkService,
    required FirebaseAuth firebaseAuth,
  }) : _ref = ref,
       _networkService = networkService,
       _firebaseAuth = firebaseAuth,
       _dio = Dio(
         BaseOptions(
           baseUrl: networkService.baseUrl,
           connectTimeout: const Duration(seconds: 30),
           receiveTimeout: const Duration(seconds: 30),
           sendTimeout: const Duration(seconds: 30),
           headers: {
             'Content-Type': 'application/json',
             'Accept': 'application/json',
             'ngrok-skip-browser-warning': 'true',
           },
           validateStatus: (status) => status != null && status < 500,
         ),
       ) {
    _setupInterceptors();
    _listenToBaseUrlChanges();
  }

  void _listenToBaseUrlChanges() {
    _networkService.baseUrlStream.listen(
      (newUrl) {
        final cleanedUrl = newUrl.endsWith('/api') ? newUrl : '$newUrl/api';
        updateBaseUrl(cleanedUrl);
      },
      onError: (e) {
        AppLogger.error('Erreur écoute URL dans DioClient: $e');
      },
    );
  }

  void updateBaseUrl(String newUrl) {
    if (ApiEndpoints.isValidUrl(newUrl)) {
      if (_dio.options.baseUrl != newUrl) {
        _dio.options.baseUrl = newUrl;
        AppLogger.info('URL de base mise à jour: $newUrl');
      }
    } else {
      AppLogger.error('URL invalide: $newUrl');
      throw NetworkException('URL invalide: $newUrl');
    }
  }

  void _setupInterceptors() {
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          logPrint: (object) => AppLogger.debug(object.toString()),
        ),
      );
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (!await _networkService.isOnline) {
            AppLogger.error('Pas de connexion réseau pour ${options.uri}.');
            throw NoInternetException();
          }

          final user = _firebaseAuth.currentUser;
          if (user != null) {
            try {
              final idToken = await user.getIdToken(true);
              options.headers['Authorization'] = 'Bearer $idToken';
              AppLogger.debug('Token Firebase ajouté: ${options.uri}');
            } catch (e) {
              AppLogger.error('Échec récupération token Firebase.', error: e);
            }
          } else {
            AppLogger.warning(
              'Aucun utilisateur Firebase pour ${options.uri}.',
            );
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            AppLogger.error(
              '401: Tentative de rafraîchissement token pour ${e.requestOptions.path}.',
            );
            final newToken = await _refreshToken();
            if (newToken != null) {
              e.requestOptions.headers['Authorization'] = 'Bearer $newToken';
              final retryOptions = Options(
                method: e.requestOptions.method,
                headers: e.requestOptions.headers,
                responseType: e.requestOptions.responseType,
                contentType: e.requestOptions.contentType,
              );
              return _retryRequest(e.requestOptions, retryOptions, handler);
            } else {
              AppLogger.error('Échec rafraîchissement token.');
              throw ApiException(
                'Session expirée. Reconnectez-vous.',
                statusCode: 401,
              );
            }
          }

          if (_shouldRetry(e)) {
            return _retryWithBackoff(e, handler);
          }

          _handleError(e, e.requestOptions.path, e.requestOptions.method);
          return handler.next(e);
        },
      ),
    );
  }

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

  Future<String?> _refreshToken() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        final idToken = await user.getIdToken(true);
        AppLogger.info('Token Firebase rafraîchi.');
        return idToken;
      }
      AppLogger.warning('Aucun utilisateur pour rafraîchir le token.');
      return null;
    } catch (e) {
      AppLogger.error('Échec rafraîchissement token Firebase.', error: e);
      return null;
    }
  }

  bool _shouldRetry(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        (e.response?.statusCode != null && e.response!.statusCode! >= 500);
  }

  Future<void> _retryWithBackoff(
    DioException e,
    ErrorInterceptorHandler handler,
  ) async {
    final requestOptions = e.requestOptions;
    final retryCount = (requestOptions.extra['retry_count'] ?? 0) + 1;

    if (retryCount <= _maxRetries) {
      final delay = _retryDelay * retryCount;
      AppLogger.warning(
        'Réessai requête ($retryCount/$_maxRetries) après $delay pour ${requestOptions.path}.',
      );
      await Future.delayed(delay);
      requestOptions.extra['retry_count'] = retryCount;
      try {
        final response = await _dio.fetch(requestOptions);
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
        'Max réessais ($_maxRetries) dépassé pour ${requestOptions.path}.',
      );
      handler.next(e);
    }
  }

  void _retryRequest(
    RequestOptions options,
    Options newOptions,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      final clonedRequest = options.copyWith(headers: newOptions.headers);
      final response = await _dio.fetch(clonedRequest);
      handler.resolve(response);
      AppLogger.info('Requête réessayée avec succès: ${options.path}');
    } catch (e) {
      AppLogger.error('Échec réessai requête: ${options.path}', error: e);
      handler.reject(
        DioException(
          requestOptions: options,
          error: e,
          type: DioExceptionType.unknown,
        ),
      );
    }
  }

  void _handleError(dynamic e, String endpoint, String method) {
    String message = 'Erreur API: $method $endpoint échoué.';
    int? statusCode;
    dynamic errorData;

    if (e is DioException) {
      statusCode = e.response?.statusCode;
      errorData = e.response?.data;
      message += ' Statut: $statusCode';

      if (errorData is Map && errorData.containsKey('message')) {
        message += ' - ${errorData['message']}';
      } else {
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
            message += ' - Timeout connexion.';
            break;
          case DioExceptionType.sendTimeout:
            message += ' - Timeout envoi.';
            break;
          case DioExceptionType.receiveTimeout:
            message += ' - Timeout réception.';
            break;
          case DioExceptionType.badResponse:
            message += ' - Réponse serveur invalide.';
            break;
          case DioExceptionType.cancel:
            message += ' - Requête annulée.';
            break;
          case DioExceptionType.badCertificate:
            message += ' - Certificat SSL invalide.';
            break;
          case DioExceptionType.connectionError:
            message += ' - Erreur connexion réseau.';
            break;
          case DioExceptionType.unknown:
            message += ' - Erreur inconnue.';
            break;
        }
      }

      if (errorData is Map &&
          errorData.containsKey('error') &&
          errorData['error'] is Map &&
          errorData['error'].containsKey('code')) {
        final errorCode = errorData['error']['code'] as String;
        message += ' - ${_mapFirebaseError(errorCode)}';
      }

      AppLogger.error(message, error: e);
    } else if (e is FirebaseAuthException) {
      statusCode = 400;
      message += ' - ${_mapFirebaseError(e.code)}';
      AppLogger.error(message, error: e);
    } else if (e is NetworkException) {
      message += ' - ${e.message}';
      AppLogger.error(message, error: e);
    } else {
      message += ' - Erreur inattendue: $e';
      AppLogger.error(message, error: e);
    }

    throw ApiException(message, statusCode: statusCode, error: errorData);
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé.';
      case 'invalid-email':
        return 'Format email invalide.';
      case 'weak-password':
        return 'Mot de passe trop faible.';
      case 'user-not-found':
      case 'wrong-password':
        return 'Email ou mot de passe incorrect.';
      case 'auth/id-token-expired':
      case 'auth/id-token-revoked':
        return 'Session expirée. Reconnectez-vous.';
      case 'auth/invalid-id-token':
        return 'Token d\'authentification invalide.';
      case 'network-request-failed':
        return 'Échec requête réseau. Vérifiez votre connexion.';
      default:
        return 'Erreur authentification: $code';
    }
  }

  void dispose() {
    _dio.close();
    AppLogger.info('DioClient disposé.');
  }
}
