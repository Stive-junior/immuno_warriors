import 'package:dio/dio.dart';
import 'package:immuno_warriors/core/network/dio_client.dart';
import 'package:immuno_warriors/core/network/api_endpoints.dart';
import 'package:immuno_warriors/data/models/base_viral_model.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

/// Provides remote data source for base viral data.
class BaseViralRemoteDataSource {
  final DioClient _dioClient;

  BaseViralRemoteDataSource(this._dioClient);

  /// Retrieves a list of all viral bases from the remote API.
  Future<List<BaseViraleModel>> getAllViralBases() async {
    try {
      final response = await _dioClient.get(ApiEndpoints.threatScannerTargets); // Assuming this endpoint returns all bases
      return (response.data as List)
          .map((json) => BaseViraleModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      _handleGenericError(e);
      rethrow;
    }
  }

  /// Retrieves a specific viral base by its ID from the remote API.
  Future<BaseViraleModel> getViralBaseById(String baseId) async {
    try {
      final response = await _dioClient.get(
        ApiEndpoints.threatScannerScanUrl(baseId), // Assuming this endpoint gets a base by ID
      );
      return BaseViraleModel.fromJson(response.data);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      _handleGenericError(e);
      rethrow;
    }
  }

  /// Creates a new viral base on the remote API.
  Future<BaseViraleModel> createViralBase(BaseViraleModel base) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.threatScannerTargets, // Assuming this endpoint creates a base
        data: base.toJson(),
      );
      return BaseViraleModel.fromJson(response.data);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      _handleGenericError(e);
      rethrow;
    }
  }

  /// Updates an existing viral base on the remote API.
  Future<BaseViraleModel> updateViralBase(String baseId, BaseViraleModel base) async {
    try {
      final response = await _dioClient.put(
        ApiEndpoints.threatScannerScanUrl(baseId), // Assuming this endpoint updates a base by ID
        data: base.toJson(),
      );
      return BaseViraleModel.fromJson(response.data);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      _handleGenericError(e);
      rethrow;
    }
  }

  /// Deletes a viral base by its ID from the remote API.
  Future<void> deleteViralBase(String baseId) async {
    try {
      await _dioClient.delete(
        ApiEndpoints.threatScannerScanUrl(baseId), // Assuming this endpoint deletes a base by ID
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
