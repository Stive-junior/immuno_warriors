import 'package:flutter/foundation.dart';
import 'package:immuno_warriors/domain/repositories/research_repository.dart';

class SaveResearchProgressUseCase {
  final ResearchRepository _researchRepository;

  SaveResearchProgressUseCase(this._researchRepository);

  Future<void> execute(Map<String, dynamic> progress) async {
    try {
      await _researchRepository.saveResearchProgress(progress);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving research progress: $e');
      }
      rethrow;
    }
  }
}