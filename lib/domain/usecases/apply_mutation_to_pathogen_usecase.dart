import 'package:flutter/foundation.dart';
import 'package:immuno_warriors/domain/entities/combat/pathogen_entity.dart';
import 'package:immuno_warriors/core/services/mutation_service.dart';

class ApplyMutationToPathogenUseCase {
  final MutationService _mutationService;

  ApplyMutationToPathogenUseCase(this._mutationService);

  Future<PathogenEntity> execute(PathogenEntity pathogen) async {
    try {
      return _mutationService.applyMutation(pathogen);
    } catch (e) {
      if (kDebugMode) {
        print('Error applying mutation to pathogen: $e');
      }
      rethrow;
    }
  }
}