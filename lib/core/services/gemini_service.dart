import 'package:dio/dio.dart';
import 'package:immuno_warriors/core/network/dio_client.dart';
import 'package:immuno_warriors/core/network/api_endpoints.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/data/models/api/gemini_response.dart';
import 'package:immuno_warriors/core/services/local_storage_service.dart'; // Import LocalStorageService

/// Provides services for interacting with the Gemini API.
class GeminiService {
  final DioClient _dioClient = DioClient();
  final _localStorageService = LocalStorageService(); // Instance of LocalStorageService

  /// Generates a chronicle of a combat using the Gemini API.
  Future<String> generateCombatChronicle(String combatSummary) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.geminiChat,
        data: {
          'prompt':
          '${combatSummary.trim()} Agis comme un chroniqueur de guerre épique. Rédige un récit détaillé et captivant de la bataille en utilisant un style littéraire et immersif.',
          'max_tokens': 200,
        },
      );

      final geminiResponse = GeminiResponse.fromJson(response.data);
      await _localStorageService.saveGeminiResponse(geminiResponse); // Save to Hive
      return geminiResponse.text;
    } on DioException catch (e) {
      AppLogger.log('Gemini API Error: ${e.message}');
      throw Exception('Failed to generate combat chronicle.');
    } catch (e) {
      AppLogger.log('Error generating combat chronicle: $e');
      rethrow;
    }
  }

  /// Gets tactical advice from the Gemini API.
  Future<String> getTacticalAdvice(String gameState, String enemyBaseInfo) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.geminiChat,
        data: {
          'prompt':
          '${gameState.trim()} ${enemyBaseInfo.trim()} Agis comme un conseiller militaire expérimenté dans un jeu de stratégie de défense immunitaire. Fournis des conseils tactiques détaillés et exploitables.',
          'max_tokens': 150,
        },
      );

      final geminiResponse = GeminiResponse.fromJson(response.data);
      await _localStorageService.saveGeminiResponse(geminiResponse); // Save to Hive
      return geminiResponse.text;
    } on DioException catch (e) {
      AppLogger.log('Gemini API Error: ${e.message}');
      throw Exception('Failed to get tactical advice.');
    } catch (e) {
      AppLogger.log('Error getting tactical advice: $e');
      rethrow;
    }
  }


  List<GeminiResponse> getStoredGeminiResponses() {
    return _localStorageService.getGeminiResponses();
  }
}