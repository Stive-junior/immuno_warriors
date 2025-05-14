import '../entities/research_entity.dart';

/// Abstract class defining the contract for research data operations.
abstract class ResearchRepository {
  /// Retrieves all research items.
  Future<List<ResearchEntity>> getAllResearchItems();

  /// Retrieves a specific research item by its ID.
  Future<ResearchEntity?> getResearchItem(String id);

  /// Unlocks a research item.
  Future<void> unlockResearchItem(String id);

  /// Creates a new research item.
  Future<ResearchEntity> createResearchItem(ResearchEntity researchItem);

  /// Updates an existing research item.
  Future<ResearchEntity> updateResearchItem(String id, ResearchEntity researchItem);

  /// Deletes a research item by its ID.
  Future<void> deleteResearchItem(String id);

  /// Retrieves the current research progress.
  Future<Map<String, dynamic>> getResearchProgress();

  /// Saves the current research progress.
  Future<void> saveResearchProgress(Map<String, dynamic> progress);
}