// Repository for managing research-related operations in Immuno Warriors.
import 'package:dartz/dartz.dart';
import '../../domain/entities/research_entity.dart';
import '../../data/models/research_model.dart';
import '../../core/exceptions/app_exception.dart';

abstract class ResearchRepository {
  /// Retrieves all research items.
  Future<Either<AppException, List<ResearchEntity>>> getAllResearchItems();

  /// Retrieves a research item by ID.
  Future<Either<AppException, ResearchEntity?>> getResearchItem(String id);

  /// Unlocks a research item.
  Future<Either<AppException, void>> unlockResearchItem(String id);

  /// Creates a new research item.
  Future<Either<AppException, ResearchEntity>> createResearchItem(
    ResearchEntity researchItem,
  );

  /// Updates an existing research item.
  Future<Either<AppException, ResearchEntity>> updateResearchItem(
    String id,
    ResearchEntity researchItem,
  );

  /// Deletes a research item by ID.
  Future<Either<AppException, void>> deleteResearchItem(String id);

  /// Retrieves the current research progress.
  Future<Either<AppException, Map<String, dynamic>>> getResearchProgress();

  /// Saves the current research progress.
  Future<Either<AppException, void>> saveResearchProgress(
    Map<String, dynamic> progress,
  );

  /// Unlocks multiple research items in a batch.
  Future<Either<AppException, void>> unlockBatchResearchItems(List<String> ids);

  /// Caches a research item locally.
  Future<Either<AppException, void>> cacheResearchItem(ResearchModel research);

  /// Retrieves a cached research item by ID.
  Future<Either<AppException, ResearchModel?>> getCachedResearchItem(String id);

  /// Clears cached research items.
  Future<Either<AppException, void>> clearCachedResearchItems();
}
