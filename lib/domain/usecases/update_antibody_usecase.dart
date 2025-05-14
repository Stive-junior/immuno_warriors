import 'package:immuno_warriors/domain/repositories/antibody_repository.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

class UpdateAntibodyUseCase {
  final AntibodyRepository _antibodyRepository;

  UpdateAntibodyUseCase(this._antibodyRepository);

  Future<void> execute({
    required String id,
    required Map<String, dynamic> updatedStats,
  }) async {
    try {
      await _antibodyRepository.updateAntibody(id, updatedStats);
    } catch (e) {
      AppLogger.error('Error updating antibody: $e');
      rethrow;
    }
  }
}