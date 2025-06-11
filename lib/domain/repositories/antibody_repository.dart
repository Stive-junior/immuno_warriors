// Repository for managing antibody-related operations in Immuno Warriors.
import 'package:dartz/dartz.dart';
import '../entities/combat/antibody_entity.dart';
import '../../core/constants/pathogen_types.dart';
import '../../data/models/combat/antibody_model.dart';
import '../../core/exceptions/app_exception.dart';

abstract class AntibodyRepository {
  /// Retrieves an antibody by ID.
  Future<Either<AppException, AntibodyEntity?>> getAntibodyById(String id);

  /// Creates a new antibody.
  Future<Either<AppException, void>> createAntibody(AntibodyEntity antibody);

  /// Updates an antibody's stats.
  Future<Either<AppException, void>> updateAntibody(
    String id,
    Map<String, dynamic> updatedStats,
  );

  /// Retrieves antibodies by type.
  Future<Either<AppException, List<AntibodyEntity>>> getAntibodiesByType(
    AntibodyType type,
  );

  /// Retrieves all antibodies.
  Future<Either<AppException, List<AntibodyEntity>>> getAllAntibodies();

  /// Deletes an antibody by ID.
  Future<Either<AppException, void>> deleteAntibody(String id);

  /// Retrieves antibodies by attack type.
  Future<Either<AppException, List<AntibodyEntity>>> getAntibodiesByAttackType(
    AttackType attackType,
  );

  /// Creates multiple antibodies in a batch.
  Future<Either<AppException, void>> createBatchAntibodies(
    List<AntibodyEntity> antibodies,
  );

  /// Caches an antibody locally.
  Future<Either<AppException, void>> cacheAntibody(AntibodyModel antibody);

  /// Retrieves a cached antibody by ID.
  Future<Either<AppException, AntibodyModel?>> getCachedAntibody(String id);

  /// Clears cached antibodies.
  Future<Either<AppException, void>> clearCachedAntibodies();
}
