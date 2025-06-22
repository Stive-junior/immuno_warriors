import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:immuno_warriors/core/exceptions/app_exception.dart';
import 'package:uuid/uuid.dart';
import 'package:immuno_warriors/core/network/api_endpoints.dart';
import 'package:immuno_warriors/core/network/dio_client.dart';
import 'package:immuno_warriors/core/services/local_storage_service.dart';
import 'package:immuno_warriors/core/services/network_service.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/data/models/pathogen_model.dart';

class PathogenService {
  final DioClient _dioClient;
  final LocalStorageService _localStorage;
  final NetworkService _networkService;

  PathogenService(this._dioClient, this._localStorage, this._networkService);

  Future<Either<ApiException, PathogenModel>> createPathogen({
    required String name,
    required String type,
    required String rarity,
    required Map<String, dynamic> stats,
  }) async {
    try {
      if (!await _networkService.isServerReachable()) {
        return Left(ApiException('Aucune connexion Internet disponible.'));
      }

      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      if (!Uuid.isValidUUID(fromString: userId)) {
        return Left(ApiException('ID d\'utilisateur invalide.'));
      }

      final response = await _dioClient.post(
        ApiEndpoints.createPathogen,
        data: {
          'name': name,
          'type': type,
          'rarity': rarity,
          'health': stats['health'],
          'attack': stats['attack'],
          'attackType': stats['attackType'],
          'resistanceType': stats['resistanceType'],
          'mutationRate': stats['mutationRate'],
          'abilities': stats['abilities'],
        },
      );
      if (response.data['data'] is! Map<String, dynamic>) {
        return Left(
          ApiException(
            'Format de réponse invalide pour la création de pathogène.',
          ),
        );
      }
      final pathogen = PathogenModel.fromJson(response.data['data']);
      await _localStorage.savePathogen(userId, pathogen);
      AppLogger.info(
        'Pathogène créé : ${pathogen.id} pour l\'utilisateur $userId',
      );
      return Right(pathogen);
    } on DioException catch (e) {
      final error = ApiException(
        'Échec de la création du pathogène : ${e.message}',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
      AppLogger.error('Erreur lors de la création du pathogène : $e');
      return Left(error);
    } catch (e) {
      AppLogger.error(
        'Erreur inattendue lors de la création du pathogène : $e',
      );
      return Left(ApiException('Erreur inattendue : $e'));
    }
  }

  Future<Either<ApiException, List<PathogenModel>>> getPathogensByType(
    String type, {
    int page = 1,
    int limit = 10,
  }) async {
    const feature = 'pathogens';
    final userId = _localStorage.getCurrentUserCache('current_user')?.id ?? '';

    if (await _networkService.isServerReachable()) {
      try {
        if (!Uuid.isValidUUID(fromString: userId)) {
          return Left(ApiException('ID d\'utilisateur invalide.'));
        }

        final response = await _dioClient.get(
          ApiEndpoints.getPathogensByType(type),
          queryParameters: {'page': page, 'limit': limit},
        );
        if (response.data['data'] is! List) {
          return Left(
            ApiException(
              'Format de réponse invalide pour les pathogènes par type.',
            ),
          );
        }
        final pathogens =
            (response.data['data'] as List)
                .map((json) => PathogenModel.fromJson(json))
                .toList();
        await _localStorage.savePathogens(userId, pathogens);
        AppLogger.info(
          'Pathogènes récupérés par type : $type, ${pathogens.length}',
        );
        return Right(pathogens);
      } on DioException catch (e) {
        final error = ApiException(
          'Échec de la récupération des pathogènes par type : ${e.message}',
          statusCode: e.response?.statusCode,
          error: e.response?.data,
        );
        AppLogger.error(
          'Erreur lors de la récupération des pathogènes par type : $e',
        );
        return Left(error);
      } catch (e) {
        AppLogger.error(
          'Erreur inattendue lors de la récupération des pathogènes par type : $e',
        );
        return Left(ApiException('Erreur inattendue : $e'));
      }
    }

    if (_networkService.isOfflineSupported(feature)) {
      try {
        if (!Uuid.isValidUUID(fromString: userId)) {
          return Left(ApiException('ID d\'utilisateur invalide.'));
        }
        final pathogens = await _localStorage.getPathogens(userId) ?? [];
        final filtered =
            pathogens.where((p) => p.type.displayName == type).toList();
        AppLogger.warning(
          'Pathogènes récupérés hors ligne par type : $type, ${filtered.length} (données potentiellement non à jour)',
        );
        return Right(filtered.skip((page - 1) * limit).take(limit).toList());
      } catch (e) {
        AppLogger.error(
          'Erreur lors de la récupération des pathogènes hors ligne : $e',
        );
        return Left(
          ApiException(
            'Erreur lors de la récupération des données locales : $e',
          ),
        );
      }
    }

    return Left(
      ApiException('Pathogènes non trouvés ou données locales obsolètes.'),
    );
  }

  Future<Either<ApiException, List<PathogenModel>>> getPathogensByRarity(
    String rarity, {
    int page = 1,
    int limit = 10,
  }) async {
    const feature = 'pathogens';
    final userId = _localStorage.getCurrentUserCache('current_user')?.id ?? '';

    if (await _networkService.isServerReachable()) {
      try {
        if (!Uuid.isValidUUID(fromString: userId)) {
          return Left(ApiException('ID d\'utilisateur invalide.'));
        }

        final response = await _dioClient.get(
          ApiEndpoints.getPathogensByRarity(rarity),
          queryParameters: {'page': page, 'limit': limit},
        );
        if (response.data['data'] is! List) {
          return Left(
            ApiException(
              'Format de réponse invalide pour les pathogènes par rareté.',
            ),
          );
        }
        final pathogens =
            (response.data['data'] as List)
                .map((json) => PathogenModel.fromJson(json))
                .toList();
        await _localStorage.savePathogens(userId, pathogens);
        AppLogger.info(
          'Pathogènes récupérés par rareté : $rarity, ${pathogens.length}',
        );
        return Right(pathogens);
      } on DioException catch (e) {
        final error = ApiException(
          'Échec de la récupération des pathogènes par rareté : ${e.message}',
          statusCode: e.response?.statusCode,
          error: e.response?.data,
        );
        AppLogger.error(
          'Erreur lors de la récupération des pathogènes par rareté : $e',
        );
        return Left(error);
      } catch (e) {
        AppLogger.error(
          'Erreur inattendue lors de la récupération des pathogènes par rareté : $e',
        );
        return Left(ApiException('Erreur inattendue : $e'));
      }
    }

    if (_networkService.isOfflineSupported(feature)) {
      try {
        if (!Uuid.isValidUUID(fromString: userId)) {
          return Left(ApiException('ID d\'utilisateur invalide.'));
        }
        final pathogens = await _localStorage.getPathogens(userId) ?? [];
        final filtered =
            pathogens.where((p) => p.rarity.displayName == rarity).toList();
        AppLogger.warning(
          'Pathogènes récupérés hors ligne par rareté : $rarity, ${filtered.length} (données potentiellement non à jour)',
        );
        return Right(filtered.skip((page - 1) * limit).take(limit).toList());
      } catch (e) {
        AppLogger.error(
          'Erreur lors de la récupération des pathogènes hors ligne : $e',
        );
        return Left(
          ApiException(
            'Erreur lors de la récupération des données locales : $e',
          ),
        );
      }
    }

    return Left(
      ApiException('Pathogènes non trouvés ou données locales obsolètes.'),
    );
  }

  Future<Either<ApiException, PathogenModel>> updatePathogenStats(
    String pathogenId,
    Map<String, dynamic> stats,
  ) async {
    try {
      if (!await _networkService.isServerReachable()) {
        return Left(ApiException('Aucune connexion Internet disponible.'));
      }

      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      if (!Uuid.isValidUUID(fromString: userId) ||
          !Uuid.isValidUUID(fromString: pathogenId)) {
        return Left(ApiException('ID invalide (utilisateur ou pathogène).'));
      }

      final response = await _dioClient.put(
        ApiEndpoints.updatePathogenStats(pathogenId),
        data: stats,
      );
      if (response.data['data'] is! Map<String, dynamic>) {
        return Left(
          ApiException(
            'Format de réponse invalide pour la mise à jour du pathogène.',
          ),
        );
      }
      final updatedPathogen = PathogenModel.fromJson(response.data['data']);
      await _localStorage.savePathogen(userId, updatedPathogen);
      AppLogger.info(
        'Stats du pathogène $pathogenId mis à jour pour l\'utilisateur $userId',
      );
      return Right(updatedPathogen);
    } on DioException catch (e) {
      final error = ApiException(
        'Échec de la mise à jour des stats du pathogène : ${e.message}',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
      AppLogger.error(
        'Erreur lors de la mise à jour des stats du pathogène : $e',
      );
      return Left(error);
    } catch (e) {
      AppLogger.error(
        'Erreur inattendue lors de la mise à jour des stats du pathogène : $e',
      );
      return Left(ApiException('Erreur inattendue : $e'));
    }
  }

  Future<Either<ApiException, List<PathogenModel>>> getAllPathogens({
    int page = 1,
    int limit = 10,
  }) async {
    const feature = 'pathogens';
    final userId = _localStorage.getCurrentUserCache('current_user')?.id ?? '';

    if (await _networkService.isServerReachable()) {
      try {
        if (!Uuid.isValidUUID(fromString: userId)) {
          return Left(ApiException('ID d\'utilisateur invalide.'));
        }

        final response = await _dioClient.get(
          ApiEndpoints.getAllPathogens,
          queryParameters: {'page': page, 'limit': limit},
        );
        if (response.data['data'] is! List) {
          return Left(
            ApiException(
              'Format de réponse invalide pour tous les pathogènes.',
            ),
          );
        }
        final pathogens =
            (response.data['data'] as List)
                .map((json) => PathogenModel.fromJson(json))
                .toList();
        await _localStorage.savePathogens(userId, pathogens);
        AppLogger.info('Tous les pathogènes récupérés : ${pathogens.length}');
        return Right(pathogens);
      } on DioException catch (e) {
        final error = ApiException(
          'Échec de la récupération de tous les pathogènes : ${e.message}',
          statusCode: e.response?.statusCode,
          error: e.response?.data,
        );
        AppLogger.error(
          'Erreur lors de la récupération de tous les pathogènes : $e',
        );
        return Left(error);
      } catch (e) {
        AppLogger.error(
          'Erreur inattendue lors de la récupération de tous les pathogènes : $e',
        );
        return Left(ApiException('Erreur inattendue : $e'));
      }
    }

    if (_networkService.isOfflineSupported(feature)) {
      try {
        if (!Uuid.isValidUUID(fromString: userId)) {
          return Left(ApiException('ID d\'utilisateur invalide.'));
        }
        final pathogens = await _localStorage.getPathogens(userId) ?? [];
        AppLogger.warning(
          'Pathogènes récupérés hors ligne : ${pathogens.length} (données potentiellement non à jour)',
        );
        return Right(pathogens.skip((page - 1) * limit).take(limit).toList());
      } catch (e) {
        AppLogger.error(
          'Erreur lors de la récupération des pathogènes hors ligne : $e',
        );
        return Left(
          ApiException(
            'Erreur lors de la récupération des données locales : $e',
          ),
        );
      }
    }

    return Left(
      ApiException('Pathogènes non trouvés ou données locales obsolètes.'),
    );
  }

  Future<Either<ApiException, void>> deletePathogen(String pathogenId) async {
    try {
      if (!await _networkService.isServerReachable()) {
        return Left(ApiException('Aucune connexion Internet disponible.'));
      }

      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      if (!Uuid.isValidUUID(fromString: userId) ||
          !Uuid.isValidUUID(fromString: pathogenId)) {
        return Left(ApiException('ID invalide (utilisateur ou pathogène).'));
      }

      await _dioClient.delete(ApiEndpoints.deletePathogen(pathogenId));
      await _localStorage.removePathogen(userId, pathogenId);
      AppLogger.info(
        'Pathogène $pathogenId supprimé pour l\'utilisateur $userId',
      );
      return const Right(null);
    } on DioException catch (e) {
      final error = ApiException(
        'Échec de la suppression du pathogène : ${e.message}',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
      AppLogger.error('Erreur lors de la suppression du pathogène : $e');
      return Left(error);
    } catch (e) {
      AppLogger.error(
        'Erreur inattendue lors de la suppression du pathogène : $e',
      );
      return Left(ApiException('Erreur inattendue : $e'));
    }
  }
}
