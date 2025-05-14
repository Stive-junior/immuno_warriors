import 'package:flutter/foundation.dart';
import 'package:immuno_warriors/domain/repositories/research_repository.dart';

class GetResearchProgressUseCase {
  final ResearchRepository _researchRepository;

  GetResearchProgressUseCase(this._researchRepository);

  Future<Map<String, dynamic>> execute() async {
    try {
      return await _researchRepository.getResearchProgress();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting research progress: $e');
      }
      rethrow;
    }
  }
}