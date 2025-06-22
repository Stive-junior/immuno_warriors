import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:immuno_warriors/core/exceptions/app_exception.dart';
import 'package:immuno_warriors/core/exceptions/network_exceptions.dart';
import 'package:uuid/uuid.dart';
import 'package:immuno_warriors/core/network/api_endpoints.dart';
import 'package:immuno_warriors/core/network/dio_client.dart';
import 'package:immuno_warriors/core/services/local_storage_service.dart';
import 'package:immuno_warriors/core/services/network_service.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/data/models/memory_signature_model.dart';

/// Service pour gérer les signatures mémoire des utilisateurs.
/// Supporte le stockage local et l'accès hors ligne.
class MemorySignatureService {
  final DioClient _dioClient;
  final LocalStorageService _localStorage;
  final NetworkService _networkService;
  DateTime? _lastSyncTime;
  static const _validPathogenTypes = {'virus', 'bacteria', 'fungus'};

  MemorySignatureService(
    this._dioClient,
    this._localStorage,
    this._networkService,
  );

  /// Ajoute une nouvelle signature mémoire.
  /// - En ligne : Envoie au serveur et met en cache.
  /// - Hors ligne : Non supporté (requiert une connexion).
  Future<Either<ApiException, MemorySignatureModel>> addMemorySignature({
    required String pathogenType,
    required int attackBonus,
    required int defenseBonus,
    required String expiryDate,
  }) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    // Valider les données
    if (!_validPathogenTypes.contains(pathogenType)) {
      return Left(
        ApiException(
          'Type de pathogène invalide : doit être virus, bacteria ou fungus.',
        ),
      );
    }
    if (attackBonus < 0 || defenseBonus < 0) {
      return Left(
        ApiException(
          'Les bonus d\'attaque et de défense doivent être supérieurs ou égaux à 0.',
        ),
      );
    }
    try {
      DateTime.parse(expiryDate);
    } catch (e) {
      return Left(
        ApiException(
          'Date d\'expiration invalide : doit être au format ISO 8601.',
        ),
      );
    }

    try {
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      if (!Uuid.isValidUUID(fromString: userId)) {
        return Left(
          ApiException(
            'ID d\'utilisateur invalide : doit être un UUID valide.',
          ),
        );
      }

      final signatureData = {
        'pathogenType': pathogenType,
        'attackBonus': attackBonus,
        'defenseBonus': defenseBonus,
        'expiryDate': expiryDate,
      };
      final response = await _dioClient.post(
        ApiEndpoints.addMemorySignature,
        data: signatureData,
      );
      final responseData = response.data['data'] as Map<String, dynamic>;
      final signature = MemorySignatureModel.fromJson(responseData);
      await _localStorage.saveMemorySignature(userId, signature);
      await _queueSyncOperation(userId, {
        'type': 'add_memory_signature',
        'data': signature.toJson(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      _lastSyncTime = DateTime.now();
      AppLogger.info('Signature mémoire ajoutée : ${signature.id}');
      return Right(signature);
    } on DioException catch (e) {
      final error = ApiException(
        'Échec de l\'ajout de la signature mémoire : ${e.message}',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
      AppLogger.error('Erreur lors de l\'ajout de la signature mémoire : $e');
      return Left(error);
    }
  }

  /// Récupère les signatures mémoire de l'utilisateur.
  /// - En ligne : Récupère depuis le serveur et met en cache.
  /// - Hors ligne : Retourne les signatures locales si disponibles.
  Future<Either<ApiException, List<MemorySignatureModel>>>
  getUserMemorySignatures() async {
    const feature = 'memory_signatures';
    final userId = _localStorage.getCurrentUserCache('current_user')?.id ?? '';

    if (!Uuid.isValidUUID(fromString: userId)) {
      return Left(
        ApiException('ID d\'utilisateur invalide : doit être un UUID valide.'),
      );
    }

    if (await _networkService.isServerReachable()) {
      try {
        final response = await _dioClient.get(
          ApiEndpoints.getUserMemorySignatures,
        );
        final responseData = response.data['data'] as List<dynamic>;
        final signatures =
            responseData
                .map((item) => MemorySignatureModel.fromJson(item))
                .toList();
        await _localStorage.clearMemorySignatures(
          userId,
        ); // Efface les anciennes signatures
        for (var signature in signatures) {
          await _localStorage.saveMemorySignature(userId, signature);
        }
        await _queueSyncOperation(userId, {
          'type': 'get_memory_signatures',
          'data': signatures.map((item) => item.toJson()).toList(),
          'timestamp': DateTime.now().toIso8601String(),
        });
        _lastSyncTime = DateTime.now();
        AppLogger.info(
          'Signatures mémoire récupérées : ${signatures.length} signatures',
        );
        return Right(signatures);
      } on DioException catch (e) {
        final error = ApiException(
          'Échec de la récupération des signatures mémoire : ${e.message}',
          statusCode: e.response?.statusCode,
          error: e.response?.data,
        );
        AppLogger.error(
          'Erreur lors de la récupération des signatures mémoire : $e',
        );
        return Left(error);
      }
    }

    if (_networkService.isOfflineSupported(feature)) {
      final signatures = await _localStorage.getMemorySignatures(userId);
      if (signatures != null && signatures.isNotEmpty) {
        AppLogger.warning(
          'Signatures mémoire récupérées hors ligne (données potentiellement non à jour) : ${signatures.length} signatures',
        );
        return Right(signatures);
      }
    }

    return Left(
      ApiException(
        'Signatures mémoire non trouvées ou données locales obsolètes.',
      ),
    );
  }

  /// Valide une signature mémoire.
  /// - En ligne : Valide via le serveur.
  /// - Hors ligne : Non supporté (requiert une connexion).
  Future<Either<ApiException, bool>> validateMemorySignature(
    String signatureId,
  ) async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    if (!Uuid.isValidUUID(fromString: signatureId)) {
      return Left(
        ApiException('ID de signature invalide : doit être un UUID valide.'),
      );
    }

    try {
      final response = await _dioClient.get(
        ApiEndpoints.validateMemorySignature(signatureId),
      );
      final isValid = response.data['data']['isValid'] as bool;
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _queueSyncOperation(userId, {
        'type': 'validate_memory_signature',
        'data': {'signatureId': signatureId, 'isValid': isValid},
        'timestamp': DateTime.now().toIso8601String(),
      });
      _lastSyncTime = DateTime.now();
      AppLogger.info(
        'Signature mémoire validée : $signatureId, valide : $isValid',
      );
      return Right(isValid);
    } on DioException catch (e) {
      final error = ApiException(
        'Échec de la validation de la signature mémoire : ${e.message}',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
      AppLogger.error(
        'Erreur lors de la validation de la signature mémoire : $e',
      );
      return Left(error);
    }
  }

  /// Supprime les signatures mémoire expirées.
  /// - En ligne : Supprime via le serveur et met à jour le cache.
  /// - Hors ligne : Non supporté (requiert une connexion).
  Future<Either<ApiException, void>> clearExpiredSignatures() async {
    if (!await _networkService.isServerReachable()) {
      throw NoInternetException();
    }

    try {
      await _dioClient.delete(ApiEndpoints.clearExpiredSignatures);
      final userId =
          _localStorage.getCurrentUserCache('current_user')?.id ?? '';
      await _localStorage.clearMemorySignatures(userId);
      await _queueSyncOperation(userId, {
        'type': 'clear_expired_signatures',
        'data': {},
        'timestamp': DateTime.now().toIso8601String(),
      });
      _lastSyncTime = DateTime.now();
      AppLogger.info('Signatures mémoire expirées supprimées');
      return const Right(null);
    } on DioException catch (e) {
      final error = ApiException(
        'Échec de la suppression des signatures expirées : ${e.message}',
        statusCode: e.response?.statusCode,
        error: e.response?.data,
      );
      AppLogger.error(
        'Erreur lors de la suppression des signatures expirées : $e',
      );
      return Left(error);
    }
  }

  /// Ajoute une opération à la file d'attente de synchronisation.
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
