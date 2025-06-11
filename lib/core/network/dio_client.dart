/// HTTP client for Immuno Warriors using Dio.
///
/// This file handles API requests with Firebase Authentication, retries, and error handling.
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../utils/app_logger.dart';
import 'api_endpoints.dart';

/// Custom exception for API errors.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic error;

  ApiException(this.message, {this.statusCode, this.error});

  @override
  String toString() =>
      'ApiException: $message (Status: $statusCode, Error: $error)';
}

class DioClient {
  final Dio _dio;
  final FirebaseAuth _firebaseAuth;
  final int _maxRetries = 3;
  final Duration _retryDelay = const Duration(seconds: 2);

  /// Creates a [DioClient] instance.
  ///
  /// Optionally accepts a [baseUrl] to override the default from [ApiEndpoints].
  DioClient({String? baseUrl})
    : _firebaseAuth = FirebaseAuth.instance,
      _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl ?? ApiEndpoints.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ) {
    _setupInterceptors();
  }

  /// --- Setup ---

  /// Configures Dio interceptors for logging, authentication, and retries.
  void _setupInterceptors() {
    // Logging interceptor for debug mode
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
        ),
      );
    }

    // Authentication and retry interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final user = _firebaseAuth.currentUser;
          if (user != null) {
            try {
              final idToken = await user.getIdToken(
                true,
              ); // Force refresh if expired
              options.headers['Authorization'] = 'Bearer $idToken';
              AppLogger.info(
                'DioClient: Added Authorization header with Firebase token.',
              );
            } catch (e) {
              AppLogger.error(
                'DioClient: Failed to get Firebase token.',
                error: e,
              );
            }
          } else {
            AppLogger.warning(
              'DioClient: No authenticated Firebase user. Proceeding without Authorization header.',
            );
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            AppLogger.error(
              'DioClient: Unauthorized (401). Attempting token refresh.',
              error: e,
            );
            final newToken = await _refreshToken();
            if (newToken != null) {
              e.requestOptions.headers['Authorization'] = 'Bearer $newToken';
              return _retryRequest(e.requestOptions, handler);
            }
          }
          if (_shouldRetry(e)) {
            return _retryWithBackoff(e, handler);
          }
          return handler.next(e);
        },
      ),
    );
  }

  /// --- Request Methods ---

  /// Performs a GET request to the specified [endpoint].
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
      AppLogger.info('DioClient: GET $endpoint successful.');
      return response;
    } catch (e) {
      _handleError(e, endpoint, 'GET');
      rethrow;
    }
  }

  /// Performs a POST request to the specified [endpoint].
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
      AppLogger.info('DioClient: POST $endpoint successful.');
      return response;
    } catch (e) {
      _handleError(e, endpoint, 'POST');
      rethrow;
    }
  }

  /// Performs a PUT request to the specified [endpoint].
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
      AppLogger.info('DioClient: PUT $endpoint successful.');
      return response;
    } catch (e) {
      _handleError(e, endpoint, 'PUT');
      rethrow;
    }
  }

  /// Performs a DELETE request to the specified [endpoint].
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
      AppLogger.info('DioClient: DELETE $endpoint successful.');
      return response;
    } catch (e) {
      _handleError(e, endpoint, 'DELETE');
      rethrow;
    }
  }

  /// --- Helper Methods ---

  /// Refreshes the Firebase token for the current user.
  Future<String?> _refreshToken() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        final idToken = await user.getIdToken(true);
        AppLogger.info('DioClient: Token refreshed successfully.');
        return idToken;
      }
      AppLogger.warning('DioClient: No user logged in for token refresh.');
      return null;
    } catch (e) {
      AppLogger.error('DioClient: Failed to refresh token.', error: e);
      return null;
    }
  }

  /// Determines if a request should be retried based on the error.
  bool _shouldRetry(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        (e.response?.statusCode != null && e.response!.statusCode! >= 500);
  }

  /// Retries a failed request with exponential backoff.
  Future<void> _retryWithBackoff(
    DioException e,
    ErrorInterceptorHandler handler,
  ) async {
    final requestOptions = e.requestOptions;
    final retryCount = (requestOptions.extra['retry_count'] ?? 0) + 1;

    if (retryCount <= _maxRetries) {
      final delay = _retryDelay * retryCount;
      AppLogger.info(
        'DioClient: Retrying request (Attempt $retryCount/$_maxRetries) after $delay.',
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
        'DioClient: Max retries ($_maxRetries) exceeded for ${requestOptions.path}.',
      );
      handler.next(e);
    }
  }

  /// Retries a request after token refresh.
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

  /// Handles errors and throws an [ApiException] with detailed information.
  void _handleError(dynamic e, String endpoint, String method) {
    String message = 'API Error: $method $endpoint failed.';
    int? statusCode;
    dynamic errorData;

    if (e is DioException) {
      statusCode = e.response?.statusCode;
      errorData = e.response?.data;
      message += ' Status: $statusCode';
      if (errorData is Map && errorData.containsKey('message')) {
        message += ' - ${errorData['message']}';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        message += ' - Connection timeout.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        message += ' - Receive timeout.';
      } else if (e.type == DioExceptionType.sendTimeout) {
        message += ' - Send timeout.';
      }
      AppLogger.error(message, error: e);
    } else {
      message += ' - Unexpected error: $e';
      AppLogger.error(message, error: e);
    }

    throw ApiException(message, statusCode: statusCode, error: errorData);
  }
}
