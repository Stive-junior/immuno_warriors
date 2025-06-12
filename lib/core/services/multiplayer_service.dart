import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:immuno_warriors/core/exceptions/app_exception.dart';
import 'package:uuid/uuid.dart';
import 'package:immuno_warriors/core/network/api_endpoints.dart';
import 'package:immuno_warriors/core/network/dio_client.dart';
import 'package:immuno_warriors/core/services/local_storage_service.dart';
import 'package:immuno_warriors/core/services/network_service.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/data/models/multiplayer_session_model.dart';

class MultiplayerService {
  final DioClient _dioClient;
  final LocalStorageService _localStorage;
  final NetworkService _networkService;

  MultiplayerService(this._dioClient, this._localStorage, this._networkService);

  Future<Either<ApiException, MultiplayerSessionModel>>
  createMultiplayerSession(Map<String, dynamic> sessionData) async {
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
        ApiEndpoints.createMultiplayerSession,
        data: sessionData,
      );
      if (response.data['data'] is! Map<String, dynamic>) {
        return Left(
          ApiException(
            'Format de réponse invalide pour la création de session.',
          ),
        );
      }
      final session = MultiplayerSessionModel.fromJson(response.data['data']);
      await _localStorage.saveMultiplayerSession(userId, session);
      AppLogger.info('Session multijoueur créée : ${session.sessionId}');
      return Right(session);
    } on DioException catch (e) {
      final error = ApiException(
        'Échec de la création de la session : ${e.message}',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
      AppLogger.error('Erreur lors de la création de la session : $e');
      return Left(error);
    } catch (e) {
      AppLogger.error(
        'Erreur inattendue lors de la création de la session : $e',
      );
      return Left(ApiException('Erreur inattendue : $e'));
    }
  }

  Future<Either<ApiException, MultiplayerSessionModel>> joinMultiplayerSession(
    String sessionId,
  ) async {
    try {
      if (!await _networkService.isServerReachable()) {
        return Left(ApiException('Aucune connexion Internet disponible.'));
      }

      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      if (!Uuid.isValidUUID(fromString: userId) ||
          !Uuid.isValidUUID(fromString: sessionId)) {
        return Left(ApiException('ID invalide (utilisateur ou session).'));
      }

      final response = await _dioClient.post(
        ApiEndpoints.joinMultiplayerSession(sessionId),
      );
      if (response.data['data'] is! Map<String, dynamic>) {
        return Left(
          ApiException(
            'Format de réponse invalide pour la jointure de session.',
          ),
        );
      }
      final session = MultiplayerSessionModel.fromJson(response.data['data']);
      await _localStorage.saveMultiplayerSession(userId, session);
      AppLogger.info('Utilisateur $userId a rejoint la session $sessionId');
      return Right(session);
    } on DioException catch (e) {
      final error = ApiException(
        'Échec de la jointure de la session : ${e.message}',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
      AppLogger.error('Erreur lors de la jointure de la session : $e');
      return Left(error);
    } catch (e) {
      AppLogger.error(
        'Erreur inattendue lors de la jointure de la session : $e',
      );
      return Left(ApiException('Erreur inattendue : $e'));
    }
  }

  Future<Either<ApiException, MultiplayerSessionModel>> getMultiplayerStatus(
    String sessionId,
  ) async {
    const feature = 'multiplayer_sessions';
    final userId = _localStorage.getCurrentUserCache('current_user')?.id ?? '';

    if (await _networkService.isServerReachable()) {
      try {
        if (!Uuid.isValidUUID(fromString: userId) ||
            !Uuid.isValidUUID(fromString: sessionId)) {
          return Left(ApiException('ID invalide (utilisateur ou session).'));
        }

        final response = await _dioClient.get(
          ApiEndpoints.getSessionStatus(sessionId),
        );
        if (response.data['data'] is! Map<String, dynamic>) {
          return Left(
            ApiException(
              'Format de réponse invalide pour le statut de session.',
            ),
          );
        }
        final session = MultiplayerSessionModel.fromJson(response.data['data']);
        await _localStorage.saveMultiplayerSession(userId, session);
        AppLogger.info('Statut de la session $sessionId récupéré');
        return Right(session);
      } on DioException catch (e) {
        final error = ApiException(
          'Échec de la récupération du statut : ${e.message}',
          statusCode: e.response?.statusCode,
          error: e.response?.data,
        );
        AppLogger.error('Erreur lors de la récupération du statut : $e');
        return Left(error);
      } catch (e) {
        AppLogger.error(
          'Erreur inattendue lors de la récupération du statut : $e',
        );
        return Left(ApiException('Erreur inattendue : $e'));
      }
    }

    if (_networkService.isOfflineSupported(feature)) {
      try {
        if (!Uuid.isValidUUID(fromString: userId)) {
          return Left(ApiException('ID d\'utilisateur invalide.'));
        }
        final sessions = await _localStorage.getMultiplayerSessions(userId);
        final session = sessions!.firstWhere(
          (s) => s.sessionId == sessionId,
          orElse: () => throw Exception('Session non trouvée'),
        );
        AppLogger.warning(
          'Statut de la session $sessionId récupéré hors ligne (données potentiellement non à jour)',
        );
        return Right(session);
      } catch (e) {
        AppLogger.error(
          'Erreur lors de la récupération du statut hors ligne : $e',
        );
        return Left(
          ApiException('Session non trouvée ou données locales obsolètes.'),
        );
      }
    }

    return Left(
      ApiException('Session non trouvée ou données locales obsolètes.'),
    );
  }

  Future<Either<ApiException, List<MultiplayerSessionModel>>>
  getUserMultiplayerSessions({int page = 1, int limit = 10}) async {
    const feature = 'multiplayer_sessions';
    final userId = _localStorage.getCurrentUserCache('current_user')?.id ?? '';

    if (await _networkService.isServerReachable()) {
      try {
        if (!Uuid.isValidUUID(fromString: userId)) {
          return Left(ApiException('ID d\'utilisateur invalide.'));
        }

        final response = await _dioClient.get(
          ApiEndpoints.getUserSessions,
          queryParameters: {'page': page, 'limit': limit},
        );
        if (response.data['data'] is! List) {
          return Left(
            ApiException(
              'Format de réponse invalide pour les sessions multijoueurs.',
            ),
          );
        }
        final sessions =
            (response.data['data'] as List)
                .map((json) => MultiplayerSessionModel.fromJson(json))
                .toList();
        await _localStorage.saveMultiplayerSessions(userId, sessions);
        AppLogger.info(
          'Sessions multijoueurs récupérées pour l\'utilisateur $userId : ${sessions.length}',
        );
        return Right(sessions);
      } on DioException catch (e) {
        final error = ApiException(
          'Échec de la récupération des sessions : ${e.message}',
          statusCode: e.response?.statusCode,
          error: e.response?.data,
        );
        AppLogger.error('Erreur lors de la récupération des sessions : $e');
        return Left(error);
      } catch (e) {
        AppLogger.error(
          'Erreur inattendue lors de la récupération des sessions : $e',
        );
        return Left(ApiException('Erreur inattendue : $e'));
      }
    }

    if (_networkService.isOfflineSupported(feature)) {
      try {
        if (!Uuid.isValidUUID(fromString: userId)) {
          return Left(ApiException('ID d\'utilisateur invalide.'));
        }
        final sessions = await _localStorage.getMultiplayerSessions(userId);
        AppLogger.warning(
          'Sessions multijoueurs récupérées hors ligne (données potentiellement non à jour) : ${sessions!.length}',
        );
        return Right(sessions.skip((page - 1) * limit).take(limit).toList());
      } catch (e) {
        AppLogger.error(
          'Erreur lors de la récupération des sessions hors ligne : $e',
        );
        return Left(
          ApiException(
            'Erreur lors de la récupération des données locales : $e',
          ),
        );
      }
    }

    return Left(
      ApiException('Sessions non trouvées ou données locales obsolètes.'),
    );
  }
}
