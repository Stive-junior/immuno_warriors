import 'package:flutter/foundation.dart';
import 'package:immuno_warriors/domain/entities/research_entity.dart';
import 'package:immuno_warriors/core/services/research_service.dart';

class GetResearchTreeUseCase {
  final ResearchService _researchService;

  GetResearchTreeUseCase(this._researchService);

  Future<List<ResearchEntity>> execute() async {
    try {
      return await _researchService.getResearchTree();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting research tree: $e');
      }
      rethrow;
    }
  }
}