import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:immuno_warriors/core/exceptions/app_exception.dart';
import 'package:immuno_warriors/core/network/api_endpoints.dart';
import 'package:immuno_warriors/core/network/dio_client.dart';
import 'package:immuno_warriors/core/services/local_storage_service.dart';
import 'package:immuno_warriors/core/services/network_service.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/data/models/combat_report_model.dart';

/// Service pour gérer les opérations liées aux combats.
/// Supporte les modes en ligne et hors ligne avec synchronisation différée.
class CombatService {
  final DioClient _dioClient;
  final LocalStorageService _localStorage;
  final NetworkService _networkService;
  DateTime? _lastSyncTime;

  CombatService(this._dioClient, this._localStorage, this._networkService);

  /// Démarre un combat avec une base virale et une liste d'anticorps.
  /// - Requiert une connexion réseau.
  /// - Enregistre l'opération pour synchronisation.
  Future<Either<ApiException, void>> startCombat(
    String baseId,
    List<String> antibodies,
  ) async {
    try {
      if (!await _networkService.isServerReachable()) {
        return Left(ApiException('Aucune connexion Internet disponible.'));
      }

      final data = {'baseId': baseId, 'antibodies': antibodies};
      await _dioClient.post(ApiEndpoints.combatStart, data: data);
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _queueSyncOperation(userId, {
        'type': 'start_combat',
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
      });
      AppLogger.info('Combat démarré avec la base : $baseId');
      return const Right(null);
    } on DioException catch (e) {
      final error = ApiException(
        'Échec du démarrage du combat : ${e.message}',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
      AppLogger.error('Erreur lors du démarrage du combat : $e');
      return Left(error);
    } catch (e) {
      AppLogger.error('Erreur inattendue lors du démarrage du combat : $e');
      return Left(ApiException('Erreur inattendue : $e'));
    }
  }

  /// Termine un combat avec un résultat et des statistiques.
  /// - Requiert une connexion réseau.
  /// - Enregistre l'opération pour synchronisation.
  Future<Either<ApiException, void>> endCombat(
    String combatId,
    String outcome,
    Map<String, dynamic> stats,
  ) async {
    try {
      if (!await _networkService.isServerReachable()) {
        return Left(ApiException('Aucune connexion Internet disponible.'));
      }

      final data = {'combatId': combatId, 'outcome': outcome, 'stats': stats};
      await _dioClient.post(ApiEndpoints.combatEnd(combatId), data: data);
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _queueSyncOperation(userId, {
        'type': 'end_combat',
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
      });
      AppLogger.info('Combat terminé : $combatId');
      return const Right(null);
    } on DioException catch (e) {
      final error = ApiException(
        'Échec de la fin du combat : ${e.message}',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
      AppLogger.error('Erreur lors de la fin du combat : $e');
      return Left(error);
    } catch (e) {
      AppLogger.error('Erreur inattendue lors de la fin du combat : $e');
      return Left(ApiException('Erreur inattendue : $e'));
    }
  }

  /// Récupère un rapport de combat spécifique.
  /// - En ligne : collecte les données via API et met en cache localement.
  /// - Hors ligne : retourne les données locales si disponibles.
  Future<Either<ApiException, CombatReportModel>> getCombatReport(
    String combatId,
  ) async {
    const feature = 'combat_log';
    final userId = _localStorage.getCurrentUserCache('current_user')?.id ?? '';

    if (await _networkService.isServerReachable()) {
      try {
        final response = await _dioClient.get(
          ApiEndpoints.combatReport(combatId),
        );
        if (response.data is! Map<String, dynamic>) {
          return Left(
            ApiException(
              'Format de réponse invalide pour le rapport de combat.',
            ),
          );
        }
        final report = CombatReportModel.fromJson(
          response.data as Map<String, dynamic>,
        );
        await _localStorage.saveCombatReport(userId, report);
        await _queueSyncOperation(userId, {
          'type': 'get_combat_report',
          'data': report.toJson(),
          'timestamp': DateTime.now().toIso8601String(),
        });
        _lastSyncTime = DateTime.now();
        AppLogger.info('Rapport de combat récupéré en ligne : $combatId');
        return Right(report);
      } on DioException catch (e) {
        final error = ApiException(
          'Échec de la récupération du rapport : ${e.message}',
          statusCode: e.response?.statusCode,
          error: e.response?.data,
        );
        AppLogger.error(
          'Erreur lors de la récupération du rapport en ligne : $e',
        );
        return Left(error);
      } catch (e) {
        AppLogger.error(
          'Erreur inattendue lors de la récupération du rapport : $e',
        );
        return Left(ApiException('Erreur inattendue : $e'));
      }
    }

    if (_networkService.isOfflineSupported(feature)) {
      try {
        final report = await _localStorage.getCombatReport(userId, combatId);
        if (report != null) {
          AppLogger.warning(
            'Rapport de combat récupéré hors ligne (données potentiellement non à jour) : $combatId',
          );
          return Right(report);
        }
      } catch (e) {
        AppLogger.error(
          'Erreur lors de la récupération du rapport hors ligne : $e',
        );
        return Left(
          ApiException(
            'Erreur lors de la récupération des données locales : $e',
          ),
        );
      }
    }

    return Left(
      ApiException('Rapport non trouvé ou données locales obsolètes.'),
    );
  }

  /// Récupère l'historique des combats de l'utilisateur.
  /// - En ligne : collecte les données via API et met en cache localement.
  /// - Hors ligne : retourne les données locales si disponibles.
  Future<Either<ApiException, List<CombatReportModel>>>
  getCombatHistory() async {
    const feature = 'combat_log';
    final userId = _localStorage.getCurrentUserCache('current_user')?.id ?? '';

    if (await _networkService.isServerReachable()) {
      try {
        final response = await _dioClient.get(ApiEndpoints.combatHistory);
        if (response.data is! List) {
          return Left(
            ApiException(
              'Format de réponse invalide pour l\'historique des combats.',
            ),
          );
        }
        final histories =
            (response.data as List<dynamic>)
                .map(
                  (item) =>
                      CombatReportModel.fromJson(item as Map<String, dynamic>),
                )
                .toList();
        // Save each report individually to align with LocalStorageService
        for (var report in histories) {
          await _localStorage.saveCombatReport(userId, report);
        }
        await _queueSyncOperation(userId, {
          'type': 'get_combat_history',
          'data': histories.map((item) => item.toJson()).toList(),
          'timestamp': DateTime.now().toIso8601String(),
        });
        _lastSyncTime = DateTime.now();
        AppLogger.info(
          'Historique des combats récupéré pour l\'utilisateur : $userId, ${histories.length} rapports',
        );
        return Right(histories);
      } on DioException catch (e) {
        final error = ApiException(
          'Échec de la récupération de l\'historique : ${e.message}',
          statusCode: e.response?.statusCode,
          error: e.response?.data,
        );
        AppLogger.error(
          'Erreur lors de la récupération de l\'historique en ligne : $e',
        );
        return Left(error);
      } catch (e) {
        AppLogger.error(
          'Erreur inattendue lors de la récupération de l\'historique : $e',
        );
        return Left(ApiException('Erreur inattendue : $e'));
      }
    }

    if (_networkService.isOfflineSupported(feature)) {
      try {
        final histories = await _localStorage.getAllCombatReports(userId);
        AppLogger.warning(
          'Historique des combats récupéré hors ligne (données potentiellement non à jour) : $userId, ${histories.length} rapports',
        );
        return Right(histories);
      } catch (e) {
        AppLogger.error(
          'Erreur lors de la récupération de l\'historique hors ligne : $e',
        );
        return Left(
          ApiException(
            'Erreur lors de la récupération des données locales : $e',
          ),
        );
      }
    }

    return Left(
      ApiException('Historique non trouvé ou données locales obsolètes.'),
    );
  }

  /// Génère une chronique narrative d'un combat.
  /// - Requiert une connexion réseau.
  /// - Enregistre l'opération pour synchronisation.
  Future<Either<ApiException, String>> generateCombatChronicle(
    String combatId,
  ) async {
    try {
      if (!await _networkService.isServerReachable()) {
        return Left(ApiException('Aucune connexion Internet disponible.'));
      }

      final response = await _dioClient.get(
        ApiEndpoints.combatChronicle(combatId),
      );
      if (response.data is! String) {
        return Left(
          ApiException(
            'Format de réponse invalide pour la chronique de combat.',
          ),
        );
      }
      final chronicle = response.data as String;
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _queueSyncOperation(userId, {
        'type': 'generate_combat_chronicle',
        'data': {'combatId': combatId, 'chronicle': chronicle},
        'timestamp': DateTime.now().toIso8601String(),
      });
      AppLogger.info('Chronique de combat générée : $combatId');
      return Right(chronicle);
    } on DioException catch (e) {
      final error = ApiException(
        'Échec de la génération de la chronique : ${e.message}',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
      AppLogger.error('Erreur lors de la génération de la chronique : $e');
      return Left(error);
    } catch (e) {
      AppLogger.error(
        'Erreur inattendue lors de la génération de la chronique : $e',
      );
      return Left(ApiException('Erreur inattendue : $e'));
    }
  }

  /// Récupère des conseils tactiques pour un combat.
  /// - Requiert une connexion réseau.
  /// - Enregistre l'opération pour synchronisation.
  Future<Either<ApiException, String>> getCombatAdvice(String combatId) async {
    try {
      if (!await _networkService.isServerReachable()) {
        return Left(ApiException('Aucune connexion Internet disponible.'));
      }

      final response = await _dioClient.get(
        ApiEndpoints.combatAdvice(combatId),
      );
      if (response.data is! String) {
        return Left(
          ApiException(
            'Format de réponse invalide pour les conseils tactiques.',
          ),
        );
      }
      final advice = response.data as String;
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _queueSyncOperation(userId, {
        'type': 'get_combat_advice',
        'data': {'combatId': combatId, 'advice': advice},
        'timestamp': DateTime.now().toIso8601String(),
      });
      AppLogger.info('Conseils tactiques récupérés : $combatId');
      return Right(advice);
    } on DioException catch (e) {
      final error = ApiException(
        'Échec de la récupération des conseils : ${e.message}',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
      AppLogger.error('Erreur lors de la récupération des conseils : $e');
      return Left(error);
    } catch (e) {
      AppLogger.error(
        'Erreur inattendue lors de la récupération des conseils : $e',
      );
      return Left(ApiException('Erreur inattendue : $e'));
    }
  }

  /// Ajoute une opération à la file d'attente de synchronisation.
  /// Inclut un horodatage pour suivre la fraîcheur des données.
  Future<void> _queueSyncOperation(
    String userId,
    Map<String, dynamic> operation,
  ) async {
    try {
      if (_lastSyncTime != null) {
        operation['lastSyncTime'] = _lastSyncTime!.toIso8601String();
      }
      await _localStorage.queueSyncOperation(userId, operation);
      AppLogger.info(
        'Opération ajoutée à la file d\'attente de synchronisation : ${operation['type']}',
      );
    } catch (e) {
      AppLogger.error(
        'Erreur lors de l\'ajout à la file de synchronisation : $e',
      );
      rethrow;
    }
  }
}
