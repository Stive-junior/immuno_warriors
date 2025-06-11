// Repository for managing viral base operations in Immuno Warriors.
import 'package:dartz/dartz.dart';
import 'package:immuno_warriors/core/constants/pathogen_types.dart';
import '../entities/base_virale_entity.dart';
import '../entities/combat/pathogen_entity.dart';
import '../../data/models/base_viral_model.dart';
import '../../core/exceptions/app_exception.dart';

abstract class BaseViraleRepository {
  /// Retrieves a viral base by ID.
  Future<Either<AppException, BaseViraleEntity?>> getBaseViraleById(String id);

  /// Creates a new viral base.
  Future<Either<AppException, void>> createBaseVirale(
    BaseViraleEntity baseVirale,
  );

  /// Updates an existing viral base.
  Future<Either<AppException, void>> updateBaseVirale(
    String baseId,
    BaseViraleEntity baseVirale,
  );

  /// Retrieves all viral bases for a player.
  Future<Either<AppException, List<BaseViraleEntity>>> getBaseViralesForPlayer(
    String playerId,
  );

  /// Retrieves all viral bases.
  Future<Either<AppException, List<BaseViraleEntity>>> getAllBases();

  /// Deletes a viral base by ID.
  Future<Either<AppException, void>> deleteBaseVirale(String id);

  /// Adds a pathogen to a viral base.
  Future<Either<AppException, BaseViraleEntity>> addPathogenToBase(
    String baseId,
    PathogenEntity pathogen,
  );

  /// Removes a pathogen from a viral base.
  Future<Either<AppException, BaseViraleEntity>> removePathogenFromBase(
    String baseId,
    PathogenEntity pathogen,
  );

  /// Updates defenses for a viral base.
  Future<Either<AppException, BaseViraleEntity>> updateBaseDefenses(
    String baseId,
    Map<DefenseType, int> newDefenses,
  );

  /// Levels up a viral base.
  Future<Either<AppException, BaseViraleEntity>> levelUpBase(String baseId);

  /// Validates a viral base for combat readiness.
  Future<Either<AppException, bool>> validateBaseForCombat(String baseId);

  /// Caches a viral base locally.
  Future<Either<AppException, void>> cacheBaseVirale(BaseViraleModel base);

  /// Retrieves a cached viral base by ID.
  Future<Either<AppException, BaseViraleModel?>> getCachedBaseVirale(String id);

  /// Clears cached viral bases.
  Future<Either<AppException, void>> clearCachedBases();
}
