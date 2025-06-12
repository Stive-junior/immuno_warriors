import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:immuno_warriors/core/exceptions/app_exception.dart';
import 'package:uuid/uuid.dart';
import 'package:immuno_warriors/core/network/api_endpoints.dart';
import 'package:immuno_warriors/core/network/dio_client.dart';
import 'package:immuno_warriors/core/services/local_storage_service.dart';
import 'package:immuno_warriors/core/services/network_service.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/data/api/gemini_response.dart';

/// Service for managing interactions with Gemini AI.
/// Supports local storage of responses and offline access.
class GeminiService {
  final DioClient _dioClient;
  final LocalStorageService _localStorage;
  final NetworkService _networkService;
  DateTime? _lastSyncTime;

  GeminiService(this._dioClient, this._localStorage, this._networkService);

  /// Initiates a chat with Gemini AI.
  /// - Online: Sends the message and stores the response.
  /// - Offline: Not supported.
  Future<Either<ApiException, GeminiResponse>> startChat(String message) async {
    try {
      if (!await _networkService.isServerReachable()) {
        return Left(ApiException('No internet connection available.'));
      }

      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      if (!_isValidUUID(userId)) {
        return Left(ApiException('Invalid user ID.'));
      }

      final response = await _dioClient.post(
        ApiEndpoints.geminiChat,
        data: {'message': message},
      );

      if (!_isValidResponse(response.data)) {
        return Left(ApiException('Invalid response format for Gemini chat.'));
      }

      final responseData = response.data['data'] as Map<String, dynamic>;
      final geminiResponse = GeminiResponse.fromJson({
        'id': responseData['id']?.toString() ?? const Uuid().v4(),
        'content': responseData['content']?.toString() ?? '',
        'type': 'chat',
        'timestamp': DateTime.now().toIso8601String(),
      });

      await _localStorage.saveGeminiResponse(userId, geminiResponse);
      await _queueSyncOperation(userId, {
        'type': 'start_chat',
        'data': responseData,
        'timestamp': DateTime.now().toIso8601String(),
      });
      _lastSyncTime = DateTime.now();
      AppLogger.info('Gemini chat initiated: ${geminiResponse.id}');
      return Right(geminiResponse);
    } on DioException catch (e) {
      final error = ApiException(
        'Failed to initiate Gemini chat: ${e.message}',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
      AppLogger.error('Error initiating Gemini chat: $e');
      return Left(error);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error initiating chat: $e',
        stackTrace: stackTrace,
      );
      return Left(ApiException('Unexpected error: $e'));
    }
  }

  /// Generates a combat chronicle with Gemini AI.
  /// - Online: Generates and stores the chronicle.
  /// - Offline: Returns the local chronicle if available.
  Future<Either<ApiException, String>> generateCombatChronicle(
    String combatId,
  ) async {
    try {
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      if (!_isValidUUID(userId) || !_isValidUUID(combatId)) {
        return Left(ApiException('Invalid ID (user or combat).'));
      }

      if (await _networkService.isServerReachable()) {
        final response = await _dioClient.get(
          ApiEndpoints.generateCombatChronicle(combatId),
        );

        if (!_isValidStringResponse(response.data)) {
          return Left(
            ApiException('Invalid response format for combat chronicle.'),
          );
        }

        final chronicle = response.data['data'] as String;
        final geminiResponse = GeminiResponse.fromJson({
          'id': combatId,
          'content': chronicle,
          'type': 'chronicle',
          'timestamp': DateTime.now().toIso8601String(),
        });

        await _localStorage.saveGeminiResponse(userId, geminiResponse);
        await _queueSyncOperation(userId, {
          'type': 'generate_combat_chronicle',
          'data': {'id': combatId, 'content': chronicle},
          'timestamp': DateTime.now().toIso8601String(),
        });
        _lastSyncTime = DateTime.now();
        AppLogger.info('Combat chronicle generated: $combatId');
        return Right(chronicle);
      }

      final response = await _localStorage.getGeminiResponse(userId, combatId);
      if (response != null && response.type == 'chronicle') {
        AppLogger.warning(
          'Combat chronicle retrieved offline (potentially outdated): $combatId',
        );
        return Right(response.content);
      }
      return Left(ApiException('Chronicle not found or local data outdated.'));
    } on DioException catch (e) {
      final error = ApiException(
        'Failed to generate combat chronicle: ${e.message}',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
      AppLogger.error('Error generating combat chronicle: $e');
      return Left(error);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error generating chronicle: $e',
        stackTrace: stackTrace,
      );
      return Left(ApiException('Unexpected error: $e'));
    }
  }

  /// Retrieves tactical advice with Gemini AI.
  /// - Online: Generates and stores the advice.
  /// - Offline: Returns the local advice if available.
  Future<Either<ApiException, String>> getTacticalAdvice(
    String combatId,
  ) async {
    try {
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      if (!_isValidUUID(userId) || !_isValidUUID(combatId)) {
        return Left(ApiException('Invalid ID (user or combat).'));
      }

      if (await _networkService.isServerReachable()) {
        final response = await _dioClient.get(
          ApiEndpoints.getTacticalAdvice(combatId),
        );

        if (!_isValidStringResponse(response.data)) {
          return Left(
            ApiException('Invalid response format for tactical advice.'),
          );
        }

        final advice = response.data['data'] as String;
        final geminiResponse = GeminiResponse.fromJson({
          'id': combatId,
          'content': advice,
          'type': 'advice',
          'timestamp': DateTime.now().toIso8601String(),
        });

        await _localStorage.saveGeminiResponse(userId, geminiResponse);
        await _queueSyncOperation(userId, {
          'type': 'get_tactical_advice',
          'data': {'id': combatId, 'content': advice},
          'timestamp': DateTime.now().toIso8601String(),
        });
        _lastSyncTime = DateTime.now();
        AppLogger.info('Tactical advice retrieved: $combatId');
        return Right(advice);
      }

      final response = await _localStorage.getGeminiResponse(userId, combatId);
      if (response != null && response.type == 'advice') {
        AppLogger.warning(
          'Tactical advice retrieved offline (potentially outdated): $combatId',
        );
        return Right(response.content);
      }
      return Left(
        ApiException('Tactical advice not found or local data outdated.'),
      );
    } on DioException catch (e) {
      final error = ApiException(
        'Failed to retrieve tactical advice: ${e.message}',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
      AppLogger.error('Error retrieving tactical advice: $e');
      return Left(error);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error retrieving advice: $e',
        stackTrace: stackTrace,
      );
      return Left(ApiException('Unexpected error: $e'));
    }
  }

  /// Generates a research description with Gemini AI.
  /// - Online: Generates and stores the description.
  /// - Offline: Returns the local description if available.
  Future<Either<ApiException, GeminiResponse>> generateResearchDescription(
    String researchId,
  ) async {
    try {
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      if (!_isValidUUID(userId) || !_isValidUUID(researchId)) {
        return Left(ApiException('Invalid ID (user or research).'));
      }

      if (await _networkService.isServerReachable()) {
        final response = await _dioClient.get(
          ApiEndpoints.generateResearchDescription(researchId),
        );

        if (!_isValidResponse(response.data)) {
          return Left(
            ApiException('Invalid response format for research description.'),
          );
        }

        final responseData = response.data['data'] as Map<String, dynamic>;
        final geminiResponse = GeminiResponse.fromJson({
          'id': responseData['id']?.toString() ?? researchId,
          'content': responseData['content']?.toString() ?? '',
          'type': 'research_description',
          'timestamp': DateTime.now().toIso8601String(),
        });

        await _localStorage.saveGeminiResponse(userId, geminiResponse);
        await _queueSyncOperation(userId, {
          'type': 'generate_research_description',
          'data': responseData,
          'timestamp': DateTime.now().toIso8601String(),
        });
        _lastSyncTime = DateTime.now();
        AppLogger.info('Research description generated: ${geminiResponse.id}');
        return Right(geminiResponse);
      }

      final response = await _localStorage.getGeminiResponse(
        userId,
        researchId,
      );
      if (response != null && response.type == 'research_description') {
        AppLogger.warning(
          'Research description retrieved offline (potentially outdated): $researchId',
        );
        return Right(response);
      }
      return Left(
        ApiException('Description not found or local data outdated.'),
      );
    } on DioException catch (e) {
      final error = ApiException(
        'Failed to generate research description: ${e.message}',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
      AppLogger.error('Error generating research description: $e');
      return Left(error);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error generating research description: $e',
        stackTrace: stackTrace,
      );
      return Left(ApiException('Unexpected error: $e'));
    }
  }

  /// Generates a base description with Gemini AI.
  /// - Online: Generates and stores the description.
  /// - Offline: Returns the local description if available.
  Future<Either<ApiException, GeminiResponse>> generateBaseDescription(
    String baseId,
  ) async {
    try {
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      if (!_isValidUUID(userId) || !_isValidUUID(baseId)) {
        return Left(ApiException('Invalid ID (user or base).'));
      }

      if (await _networkService.isServerReachable()) {
        final response = await _dioClient.get(
          ApiEndpoints.generateBaseDescription(baseId),
        );

        if (!_isValidResponse(response.data)) {
          return Left(
            ApiException('Invalid response format for base description.'),
          );
        }

        final responseData = response.data['data'] as Map<String, dynamic>;
        final geminiResponse = GeminiResponse.fromJson({
          'id': responseData['id']?.toString() ?? baseId,
          'content': responseData['content']?.toString() ?? '',
          'type': 'base_description',
          'timestamp': DateTime.now().toIso8601String(),
        });

        await _localStorage.saveGeminiResponse(userId, geminiResponse);
        await _queueSyncOperation(userId, {
          'type': 'generate_base_description',
          'data': responseData,
          'timestamp': DateTime.now().toIso8601String(),
        });
        _lastSyncTime = DateTime.now();
        AppLogger.info('Base description generated: ${geminiResponse.id}');
        return Right(geminiResponse);
      }

      final response = await _localStorage.getGeminiResponse(userId, baseId);
      if (response != null && response.type == 'base_description') {
        AppLogger.warning(
          'Base description retrieved offline (potentially outdated): $baseId',
        );
        return Right(response);
      }
      return Left(
        ApiException('Description not found or local data outdated.'),
      );
    } on DioException catch (e) {
      final error = ApiException(
        'Failed to generate base description: ${e.message}',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
      AppLogger.error('Error generating base description: $e');
      return Left(error);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error generating base description: $e',
        stackTrace: stackTrace,
      );
      return Left(ApiException('Unexpected error: $e'));
    }
  }

  /// Retrieves all stored Gemini AI responses.
  /// - Online: Fetches from the API and caches locally.
  /// - Offline: Returns local responses.
  Future<Either<ApiException, List<GeminiResponse>>>
  getStoredResponses() async {
    try {
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      if (!_isValidUUID(userId)) {
        return Left(ApiException('Invalid user ID.'));
      }

      if (await _networkService.isServerReachable()) {
        final response = await _dioClient.get(
          ApiEndpoints.getStoredGeminiResponses,
        );

        if (!_isValidListResponse(response.data)) {
          return Left(
            ApiException('Invalid response format for stored responses.'),
          );
        }

        final responses =
            (response.data['data'] as List)
                .map(
                  (resp) =>
                      GeminiResponse.fromJson(resp as Map<String, dynamic>),
                )
                .toList();

        for (final geminiResponse in responses) {
          await _localStorage.saveGeminiResponse(userId, geminiResponse);
        }

        await _queueSyncOperation(userId, {
          'type': 'get_stored_responses',
          'data': responses.map((r) => r.toJson()).toList(),
          'timestamp': DateTime.now().toIso8601String(),
        });
        _lastSyncTime = DateTime.now();
        AppLogger.info(
          'Stored Gemini responses retrieved: ${responses.length}',
        );
        return Right(responses);
      }

      final responses = await _localStorage.getAllGeminiResponses(userId);
      if (responses.isNotEmpty) {
        AppLogger.warning(
          'Gemini responses retrieved offline (potentially outdated): ${responses.length}',
        );
        return Right(responses);
      }
      return Left(ApiException('Responses not found or local data outdated.'));
    } on DioException catch (e) {
      final error = ApiException(
        'Failed to retrieve stored responses: ${e.message}',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
      AppLogger.error('Error retrieving stored responses: $e');
      return Left(error);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error retrieving stored responses: $e',
        stackTrace: stackTrace,
      );
      return Left(ApiException('Unexpected error: $e'));
    }
  }

  /// Queues a sync operation for later processing.
  Future<void> _queueSyncOperation(
    String userId,
    Map<String, dynamic> operation,
  ) async {
    try {
      if (_lastSyncTime != null) {
        operation['lastSyncTime'] = _lastSyncTime!.toIso8601String();
      }
      await _localStorage.queueSyncOperation(userId, operation);
      AppLogger.info('Operation queued for sync: ${operation['type']}');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error queuing sync operation: $e',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  bool _isValidUUID(String id) => Uuid.isValidUUID(fromString: id);

  /// Validates if a response is a valid Map<String, dynamic>.
  bool _isValidResponse(dynamic data) =>
      data is Map<String, dynamic> && data['data'] is Map<String, dynamic>;

  /// Validates if a response contains a valid string data field.
  bool _isValidStringResponse(dynamic data) =>
      data is Map<String, dynamic> && data['data'] is String;

  /// Validates if a response contains a valid list data field.
  bool _isValidListResponse(dynamic data) =>
      data is Map<String, dynamic> && data['data'] is List;
}
