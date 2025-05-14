import 'package:dio/dio.dart';
import 'package:immuno_warriors/core/network/dio_client.dart';
import 'package:immuno_warriors/core/network/api_endpoints.dart';
import 'package:immuno_warriors/data/models/research_model.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

/// Provides remote data source for research data.
class ResearchRemoteDataSource {
  final DioClient _dioClient;

  ResearchRemoteDataSource(this._dioClient);

  /// Retrieves all research items from the remote API.
  Future<List<ResearchModel>> getAllResearchItems() async {
    try {
      final response = await _dioClient.get(
        ApiEndpoints.researchTree, // Assuming this is the endpoint for all research items
      );
      return (response.data as List)
          .map((json) => ResearchModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      _handleGenericError(e);
      rethrow;
    }
  }

  /// Retrieves a specific research item by its ID from the remote API.
  Future<ResearchModel> getResearchItem(String researchId) async {
    try {
      final response = await _dioClient.get(
        ApiEndpoints.researchNodeUrl(researchId), // Utilisation de la méthode pour construire l'URL
      );
      return ResearchModel.fromJson(response.data);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      _handleGenericError(e);
      rethrow;
    }
  }

  /// Creates a new research item on the remote API.
  Future<ResearchModel> createResearchItem(ResearchModel researchItem) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.researchTree, // Assuming this is the endpoint to create a research item
        data: researchItem.toJson(),
      );
      return ResearchModel.fromJson(response.data);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      _handleGenericError(e);
      rethrow;
    }
  }

  /// Updates an existing research item on the remote API.
  Future<ResearchModel> updateResearchItem(String researchId, ResearchModel researchItem) async {
    try {
      final response = await _dioClient.put(
        ApiEndpoints.researchNodeUrl(researchId), // Utilisation de la méthode pour construire l'URL
        data: researchItem.toJson(),
      );
      return ResearchModel.fromJson(response.data);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      _handleGenericError(e);
      rethrow;
    }
  }

  /// Deletes a research item by its ID from the remote API.
  Future<void> deleteResearchItem(String researchId) async {
    try {
      await _dioClient.delete(
        ApiEndpoints.researchNodeUrl(researchId),
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      _handleGenericError(e);
      rethrow;
    }
  }

  // Méthode de gestion des erreurs Dio
  void _handleDioError(DioException e) {
    String errorMessage = 'Dio Error: ${e.message}';
    if (e.response != null) {
      errorMessage += ' - Status Code: ${e.response!.statusCode} - Data: ${e.response!.data}';
    }
    AppLogger.error(errorMessage);
  }

  // Méthode de gestion des erreurs génériques
  void _handleGenericError(dynamic e) {
    AppLogger.error('Generic Error: $e');
  }
}