import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'api_endpoints.dart';
import '../utils/app_logger.dart';

class DioClient {
  final Dio _dio;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  DioClient({String? baseUrl})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl ?? ApiEndpoints.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      ) {
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          error: true,
          requestBody: true,
          responseBody: true,
          requestHeader: true,
        ),
      );
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final user = _firebaseAuth.currentUser;
          if (user != null) {
            // Obtient le token ID Firebase pour l'utilisateur actuellement connecté
            final idToken = await user.getIdToken();
            // Ajoute le token dans le header Authorization
            options.headers['Authorization'] = 'Bearer $idToken';
            AppLogger.info(
              'DioClient: Ajout du header Authorization avec token Firebase.',
            );
          } else {
            AppLogger.warning(
              'DioClient: Aucun utilisateur Firebase authentifié. La requête continuera sans header Authorization.',
            );
          }
          return handler.next(options); // Continue la requête
        },
        onError: (DioException e, handler) {
          // Gérer les erreurs spécifiques, par exemple les erreurs 401 (Non autorisé)
          if (e.response?.statusCode == 401) {
            AppLogger.error(
              'DioClient: Accès non autorisé (401). Le token Firebase est peut-être invalide ou expiré.',
              error: e,
            );
          }
          return handler.next(e);
        },
      ),
    );
  }

  // Les méthodes GET, POST, PUT, DELETE restent inchangées,
  // l'intercepteur s'occupe d'ajouter le token.
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
      return response;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      _handleGenericError(e);
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
      return response;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      _handleGenericError(e);
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
      return response;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      _handleGenericError(e);
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
      return response;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      _handleGenericError(e);
      rethrow;
    }
  }

  void _handleDioError(DioException e) {
    String errorMessage = 'Erreur Dio: ${e.message}';
    if (e.response != null) {
      errorMessage +=
          ' - Code Statut: ${e.response!.statusCode} - Données: ${e.response!.data}';
      if (e.response!.data is Map && e.response!.data.containsKey('message')) {
        errorMessage += ' - Détails: ${e.response!.data['message']}';
      }
    }
    AppLogger.error('Erreur API: $errorMessage', error: e);
  }

  void _handleGenericError(dynamic e) {
    AppLogger.error('Erreur inattendue: $e', error: e);
  }
}
