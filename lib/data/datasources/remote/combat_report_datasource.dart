
import 'package:dio/dio.dart';
import 'package:immuno_warriors/core/network/dio_client.dart';
import 'package:immuno_warriors/core/network/api_endpoints.dart';
import 'package:immuno_warriors/data/models/combat_report_model.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

/// Provides remote data source for combat report data.
class CombatReportRemoteDataSource {
  final DioClient _dioClient;

  CombatReportRemoteDataSource(this._dioClient);

  /// Retrieves a specific combat report by its ID from the remote API.
  Future<CombatReportModel> getCombatReport(String reportId) async {
    try {
      final response = await _dioClient.get(
        ApiEndpoints.combatReport,
        queryParameters: {'reportId': reportId},
      );
      return CombatReportModel.fromJson(response.data);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      _handleGenericError(e);
      rethrow;
    }
  }


  /// Creates a new combat report on the remote API.
  Future<CombatReportModel> createCombatReport(CombatReportModel report) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.combatReport, // Assuming this is the endpoint to create a report
        data: report.toJson(),
      );
      return CombatReportModel.fromJson(response.data);
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