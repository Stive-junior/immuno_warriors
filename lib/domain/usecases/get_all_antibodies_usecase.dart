import 'package:immuno_warriors/domain/entities/antibody_entity.dart';
import 'package:immuno_warriors/domain/repositories/antibody_repository.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

class GetAllAntibodiesUseCase {
  final AntibodyRepository _antibodyRepository;

  GetAllAntibodiesUseCase(this._antibodyRepository);

  Future<List<AntibodyEntity>> execute() async {
    try {
      return await _antibodyRepository.getAllAntibodies();
    } catch (e) {
      AppLogger.error('Error getting all antibodies: $e');
      rethrow;
    }
  }
}
