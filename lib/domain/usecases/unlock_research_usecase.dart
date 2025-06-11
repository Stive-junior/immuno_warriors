import 'package:flutter/foundation.dart';
import 'package:immuno_warriors/domain/entities/research_entity.dart';
import 'package:immuno_warriors/core/services/research_service.dart';
import 'package:immuno_warriors/domain/repositories/user_repository.dart';

class UnlockResearchNodeUseCase {
  final ResearchService _researchService;
  final UserRepository _userRepository;

  UnlockResearchNodeUseCase(this._researchService, this._userRepository);

  Future<void> execute(String nodeId) async {
    try {
      // Récupérer les points de recherche de l'utilisateur
      final userResources = await _userRepository.getUserResources();
      final int userResearchPoints =
          userResources['researchPoints'] as int? ?? 0;

      // Tenter de déverrouiller le nœud de recherche via le service
      await _researchService.unlockResearchNode(nodeId, userResearchPoints);

      // Si le déverrouillage réussit, potentiellement mettre à jour les points de recherche de l'utilisateur
      final researchNode = await _researchService.getResearchTree().then(
        (nodes) => nodes.firstWhere((node) => node.id == nodeId),
      );
      final updatedResources = {
        'researchPoints': userResearchPoints - researchNode.cost,
      };
      await _userRepository.updateUserResources(updatedResources);
    } catch (e) {
      if (kDebugMode) {
        print('Error unlocking research node: $e');
      }
      rethrow;
    }
  }
}
