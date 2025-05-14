import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_endpoints.dart';
import '../utils/app_logger.dart';

/// A wrapper around the Dio HTTP client.
///
/// Provides methods for making API requests and handling responses.
class DioClient {
  final Dio _dio;

  /// Creates a DioClient instance.
  ///
  /// The [baseUrl] is the base URL for all API requests.
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
      _dio.interceptors.add(LogInterceptor(
        error: true,
        requestBody: true,
        responseBody: true,
        requestHeader: true,
      ));
    }
  }

  /// Sends a GET request to the specified [endpoint].
  ///
  /// [queryParameters] are added to the URL.
  /// [options] are additional Dio request options.
  /// [cancelToken] can be used to cancel the request.
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
      _handleDioError(e); // Utilisation de la méthode de gestion d'erreur
      rethrow;
    } catch (e) {
      _handleGenericError(e); // Utilisation de la méthode de gestion d'erreur
      rethrow;
    }
  }

  /// Sends a POST request to the specified [endpoint].
  ///
  /// [data] is the request body.
  /// [options] are additional Dio request options.
  /// [cancelToken] can be used to cancel the request.
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
      _handleDioError(e); // Utilisation de la méthode de gestion d'erreur
      rethrow;
    } catch (e) {
      _handleGenericError(e); // Utilisation de la méthode de gestion d'erreur
      rethrow;
    }
  }

  /// Sends a PUT request to the specified [endpoint].
  ///
  /// [data] is the request body.
  /// [queryParameters] are added to the URL.
  /// [options] are additional Dio request options.
  /// [cancelToken] can be used to cancel the request.
  Future<Response> put(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters, // Ajout des queryParameters
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters, // Utilisation des queryParameters
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      _handleDioError(e); // Utilisation de la méthode de gestion d'erreur
      rethrow;
    } catch (e) {
      _handleGenericError(e); // Utilisation de la méthode de gestion d'erreur
      rethrow;
    }
  }

  /// Sends a DELETE request to the specified [endpoint].
  ///
  /// [data] is the request body.
  /// [options] are additional Dio request options.
  /// [cancelToken] can be used to cancel the request.
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
      _handleDioError(e); // Utilisation de la méthode de gestion d'erreur
      rethrow;
    } catch (e) {
      _handleGenericError(e); // Utilisation de la méthode de gestion d'erreur
      rethrow;
    }
  }

  // Méthode de gestion des erreurs Dio
  void _handleDioError(DioException e) {
    String errorMessage = 'Dio Error: ${e.message}';
    if (e.response != null) {
      errorMessage += ' - Status Code: ${e.response!.statusCode} - Data: ${e.response!.data}';
    }
    AppLogger.error('Generic Error: $errorMessage $e');
  }

  // Méthode de gestion des erreurs génériques
  void _handleGenericError(dynamic e) {
    AppLogger.error('Generic Error: $e');
  }
}