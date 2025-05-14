// lib/core/services/research_service.dart

import 'package:immuno_warriors/domain/entities/research_entity.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/core/constants/game_constants.dart';
import 'package:immuno_warriors/data/repositories/research_repository_impl.dart';

/// Provides services for managing research within the application.
class ResearchService {
  final ResearchRepositoryImpl _researchRepository;

  ResearchService(this._researchRepository);

  /// Retrieves the entire research tree.
  Future<List<ResearchEntity>> getResearchTree() async {
    try {
      return await _researchRepository.getAllResearchItems();
    } catch (e) {
      AppLogger.log('Error getting research tree: $e');
      rethrow;
    }
  }

  /// Unlocks a specific research node.
  ///
  /// Checks for prerequisites and resource costs before unlocking.
  Future<void> unlockResearchNode(
      String nodeId,
      int userResearchPoints,
      ) async {
    try {
      final node = await _researchRepository.getResearchItem(nodeId);

      if (node == null) {
        throw Exception('Research node not found.');
      }

      if (userResearchPoints < node.cost) {
        throw Exception('Insufficient research points.');
      }

      if (!await _arePrerequisitesMet(node.prerequisites)) {
        throw Exception('Prerequisites not met.');
      }

      await _researchRepository.unlockResearchItem(nodeId);
    } catch (e) {
      AppLogger.log('Error unlocking research node: $e');
      rethrow;
    }
  }

  /// Checks if the prerequisites for a research node are met.
  Future<bool> _arePrerequisitesMet(List<String> prerequisites) async {
    if (prerequisites.isEmpty) {
      return true;
    }

    for (final prerequisiteId in prerequisites) {
      final prerequisiteNode =
      await _researchRepository.getResearchItem(prerequisiteId);
      if (prerequisiteNode == null || !prerequisiteNode.isUnlocked) {
        return false;
      }
    }

    return true;
  }

  /// Calculates the research progress for a node.
  ///
  /// This could be based on time or other factors.
  double calculateResearchProgress(ResearchEntity node, double deltaTime) {
    if (node.isUnlocked) {
      return 1.0; // Already unlocked
    }

    // Example: progress based on time and research points
    final progress = (deltaTime * GameConstants.baseResearchPointsPerSecond) /
        node.cost; // Simplified
    return progress.clamp(0.0, 1.0);
  }

// Add more research-related logic as needed
}