// Repository for managing memory signature operations in Immuno Warriors.
import 'package:dartz/dartz.dart';
import '../../domain/entities/memory_signature.dart';
import '../../data/models/memory_signature_model.dart';
import '../../core/exceptions/app_exception.dart';

abstract class MemoryRepository {
  /// Retrieves memory signatures for a user.
  Future<Either<AppException, List<MemorySignature>>> getMemorySignatures(
    String userId,
  );

  /// Adds a memory signature for a user.
  Future<Either<AppException, void>> addMemorySignature(
    String userId,
    MemorySignature signature,
  );

  /// Clears expired memory signatures for a user.
  Future<Either<AppException, void>> clearExpiredMemorySignatures(
    String userId,
  );

  /// Adds multiple memory signatures in a batch.
  Future<Either<AppException, void>> addBatchMemorySignatures(
    String userId,
    List<MemorySignature> signatures,
  );

  /// Validates a memory signature by pathogen type.
  Future<Either<AppException, bool>> validateMemorySignature(
    String userId,
    String pathogenType,
  );

  /// Caches a memory signature locally.
  Future<Either<AppException, void>> cacheMemorySignature(
    MemorySignatureModel signature,
  );

  /// Retrieves cached memory signatures for a user.
  Future<Either<AppException, List<MemorySignatureModel>>>
  getCachedMemorySignatures(String userId);

  /// Clears cached memory signatures for a user.
  Future<Either<AppException, void>> clearCachedMemorySignatures(String userId);
}
