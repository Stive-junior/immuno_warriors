import 'package:immuno_warriors/domain/entities/combat/antibody_entity.dart';
import 'package:immuno_warriors/domain/repositories/antibody_repository.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

class CreateAntibodyUseCase {
  final AntibodyRepository _antibodyRepository;

  CreateAntibodyUseCase(this._antibodyRepository);

  Future<void> execute(AntibodyEntity antibody) async {
    try {
      await _antibodyRepository.createAntibody(antibody);
    } catch (e) {
      AppLogger.error('Error creating antibody: $e');
      rethrow;
    }
  }
}