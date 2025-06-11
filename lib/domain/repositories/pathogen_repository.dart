/// Repository for managing pathogen-related operations in Immuno Warriors.
import 'package:dartz/dartz.dart';
import '../../domain/entities/combat/pathogen_entity.dart';
import '../../core/constants/pathogen_types.dart';
import '../../data/models/combat/pathogen_model.dart';
import '../../core/exceptions/app_exception.dart';

abstract class PathogenRepository {
  /// Retrieves all pathogens.
  Future<Either<AppException, List<PathogenEntity>>> getAllPathogens();

  /// Retrieves pathogens by type.
  Future<Either<AppException, List<PathogenEntity>>> getPathogensByType(
    PathogenType type,
  );

  /// Retrieves a pathogen by ID.
  Future<Either<AppException, PathogenEntity?>> getPathogenById(String id);

  /// Creates a new pathogen.
  Future<Either<AppException, void>> createPathogen(PathogenEntity pathogen);

  /// Updates a pathogen's stats.
  Future<Either<AppException, void>> updatePathogenStats(
    String id,
    Map<String, dynamic> updatedStats,
  );

  /// Deletes a pathogen.
  Future<Either<AppException, void>> deletePathogen(String id);

  /// Retrieves pathogens by rarity.
  Future<Either<AppException, List<PathogenEntity>>> getPathogensByRarity(
    PathogenRarity rarity,
  );

  /// Creates multiple pathogens in a batch.
  Future<Either<AppException, void>> createBatchPathogens(
    List<PathogenEntity> pathogens,
  );

  /// Caches a pathogen locally.
  Future<Either<AppException, void>> cachePathogen(PathogenModel pathogen);

  /// Retrieves a cached pathogen by ID.
  Future<Either<AppException, PathogenModel?>> getCachedPathogen(String id);

  /// Clears cached pathogens.
  Future<Either<AppException, void>> clearCachedPathogens();
}
