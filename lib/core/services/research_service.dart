import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:immuno_warriors/core/exceptions/app_exception.dart';
import 'package:immuno_warriors/core/exceptions/network_exceptions.dart';
import 'package:immuno_warriors/core/network/api_endpoints.dart';
import 'package:immuno_warriors/core/network/dio_client.dart';
import 'package:immuno_warriors/core/services/local_storage_service.dart';
import 'package:immuno_warriors/core/services/network_service.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/data/models/research_model.dart';

/// Service pour gérer les opérations liées aux recherches.
/// Supporte les modes en ligne et hors ligne avec synchronisation différée.
class ResearchService {
  final DioClient _dioClient;
  final LocalStorageService _localStorage;
  final NetworkService _networkService;
  DateTime? _lastSyncTime;

  ResearchService(this._dioClient, this._localStorage, this._networkService);

  /// Récupère l'arbre de recherche.
  /// - En ligne : Appel API et mise en cache local.
  /// - Hors ligne : Retourne les données locales si disponibles.
  Future<Either<ApiException, List<ResearchModel>>> getResearchTree() async {
    const feature = 'research_tree';
    final userId = _localStorage.getCurrentUserCache('current_user')?.id ?? '';

    if (await _networkService.isServerReachable()) {
      try {
        final response = await _dioClient.get(ApiEndpoints.researchTree);
        final tree =
            (response.data as List)
                .map((json) => ResearchModel.fromJson(json))
                .toList();
        await _localStorage.saveResearchTree(userId, tree);
        await _queueSyncOperation(userId, {
          'type': 'get_research_tree',
          'data': tree,
          'timestamp': DateTime.now().toIso8601String(),
        });
        _lastSyncTime = DateTime.now();
        AppLogger.info(
          'Arbre de recherche récupéré en ligne : ${tree.length} nœuds',
        );
        return Right(tree);
      } on DioException catch (e) {
        final error = ApiException(
          'Échec de la récupération de l\'arbre de recherche : ${e.message}',
          statusCode: e.response?.statusCode,
          error: e.response?.data,
        );
        AppLogger.error(
          'Erreur lors de la récupération de l\'arbre de recherche en ligne : $e',
        );
        return Left(error);
      }
    }

    if (_networkService.isOfflineSupported(feature)) {
      final tree = await _localStorage.getResearchTree(userId);
      if (tree != null) {
        AppLogger.warning(
          'Arbre de recherche récupéré hors ligne (données potentiellement non à jour) : ${tree.length} nœuds',
        );
        return Right(tree);
      }
    }

    return Left(ApiException('Données locales obsolètes.'));
  }

  /// Récupère la progression des recherches de l'utilisateur.
  /// - En ligne : Appel API et mise en cache local.
  /// - Hors ligne : Retourne les données locales si disponibles.
  Future<Either<ApiException, Map<String, dynamic>>>
  getResearchProgress() async {
    const feature = 'research_progress';
    final userId = _localStorage.getCurrentUserCache('current_user')?.id ?? '';

    if (await _networkService.isServerReachable()) {
      try {
        final response = await _dioClient.get(ApiEndpoints.researchProgress);
        final progress = response.data as Map<String, dynamic>;
        await _localStorage.saveResearchProgress(userId, progress);
        await _queueSyncOperation(userId, {
          'type': 'get_research_progress',
          'data': progress,
          'timestamp': DateTime.now().toIso8601String(),
        });
        _lastSyncTime = DateTime.now();
        AppLogger.info(
          'Progression des recherches récupérée en ligne : $userId',
        );
        return Right(progress);
      } on DioException catch (e) {
        final error = ApiException(
          'Échec de la récupération de la progression des recherches : ${e.message}',
          statusCode: e.response?.statusCode,
          error: e.response?.data,
        );
        AppLogger.error(
          'Erreur lors de la récupération de la progression des recherches en ligne : $e',
        );
        return Left(error);
      }
    }

    if (_networkService.isOfflineSupported(feature)) {
      final progress = await _localStorage.getResearchProgress(userId);
      if (progress != null) {
        AppLogger.warning(
          'Progression des recherches récupérée hors ligne (données potentiellement non à jour) : $userId',
        );
        return Right(progress);
      }
    }

    return Left(ApiException('Données locales obsolètes.'));
  }

  /// Déverrouille un nœud de recherche.
  /// - Requiert une connexion réseau.
  /// - Enregistre l'opération pour synchronisation.
  Future<void> unlockResearch(String researchId) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    try {
      await _dioClient.post(
        ApiEndpoints.researchUnlock,
        data: {'researchId': researchId},
      );

      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _queueSyncOperation(userId, {
        'type': 'unlock_research',
        'data': {'researchId': researchId},
        'timestamp': DateTime.now().toIso8601String(),
      });
      AppLogger.info('Nœud de recherche déverrouillé : $researchId');
    } on DioException catch (e) {
      AppLogger.error(
        'Erreur lors du déverrouillage du nœud de recherche : $e',
      );
      throw ApiException(
        'Échec du déverrouillage du nœud de recherche.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }

  /// Met à jour la progression d'un nœud de recherche.
  /// - Requiert une connexion réseau.
  /// - Enregistre l'opération pour synchronisation.
  Future<void> updateResearchProgress(String researchId, int progress) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    try {
      await _dioClient.put(
        ApiEndpoints.researchNodeUrl(researchId),
        data: {'progress': progress},
      );
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _queueSyncOperation(userId, {
        'type': 'update_research_progress',
        'data': {'researchId': researchId, 'progress': progress},
        'timestamp': DateTime.now().toIso8601String(),
      });
      AppLogger.info(
        'Progression du nœud de recherche mise à jour : $researchId',
      );
    } on DioException catch (e) {
      AppLogger.error(
        'Erreur lors de la mise à jour de la progression du nœud de recherche : $e',
      );
      throw ApiException(
        'Échec de la mise à jour de la progression du nœud de recherche.',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
    }
  }

  /// Ajoute une opération à la file d'attente de synchronisation.
  /// Inclut un horodatage pour suivre la fraîcheur des données.
  Future<void> _queueSyncOperation(
    String userId,
    Map<String, dynamic> operation,
  ) async {
    if (_lastSyncTime != null) {
      operation['lastSyncTime'] = _lastSyncTime!.toIso8601String();
    }
    await _localStorage.queueSyncOperation(userId, operation);
    AppLogger.info(
      'Opération ajoutée à la file d\'attente de synchronisation : ${operation['type']}',
    );
  }
}
