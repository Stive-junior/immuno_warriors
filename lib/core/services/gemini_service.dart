// Votre fichier : lib/data/services/gemini_service.dart (ou similaire)

import 'package:dio/dio.dart';
import 'package:immuno_warriors/core/network/dio_client.dart';
import 'package:immuno_warriors/core/network/api_endpoints.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/data/models/api/gemini_response.dart';

class GeminiService {
  final DioClient _dioClient = DioClient();

  Future<String> generateCombatChronicle(String combatSummary) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.generateCombatChronicle,
        data: {'combatSummary': combatSummary},
      );

      final geminiResponse = GeminiResponse.fromJson(response.data);
      return geminiResponse.text;
    } on DioException catch (e) {
      AppLogger.error(
        'Erreur API (Chroniques de Combat): ${e.message}',
        error: e,
      );
      throw Exception(
        'Échec de la génération de la chronique de combat via l\'API.',
      );
    } catch (e) {
      AppLogger.error(
        'Erreur inattendue lors de la génération de la chronique de combat: $e',
        error: e,
      );
      rethrow;
    }
  }

  Future<String> getTacticalAdvice(
    String gameState,
    String enemyBaseInfo,
  ) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.getTacticalAdvice,
        data: {'gameState': gameState, 'enemyBaseInfo': enemyBaseInfo},
      );

      final geminiResponse = GeminiResponse.fromJson(response.data);
      return geminiResponse.text;
    } on DioException catch (e) {
      AppLogger.error(
        'Erreur API (Conseils Tactiques): ${e.message}',
        error: e,
      );
      throw Exception(
        'Échec de l\'obtention des conseils tactiques via l\'API.',
      );
    } catch (e) {
      AppLogger.error(
        'Erreur inattendue lors de l\'obtention des conseils tactiques: $e',
        error: e,
      );
      rethrow;
    }
  }


  Future<List<dynamic>> getStoredGeminiResponses() async {
    try {
      final response = await _dioClient.get(
        ApiEndpoints.getStoredGeminiResponses,
      );
      // Le backend renvoie une liste d'objets JSON.
      // Assurez-vous que le type de retour correspond à ce que vous attendez.
      return response.data as List<dynamic>; // Cast en List<dynamic>
    } on DioException catch (e) {
      AppLogger.error(
        'Erreur lors de la récupération des réponses Gemini stockées: ${e.message}',
        error: e,
      );
      throw Exception('Échec de la récupération des réponses Gemini stockées.');
    } catch (e) {
      AppLogger.error(
        'Erreur inattendue lors de la récupération des réponses Gemini stockées: $e',
        error: e,
      );
      rethrow;
    }
  }
}
