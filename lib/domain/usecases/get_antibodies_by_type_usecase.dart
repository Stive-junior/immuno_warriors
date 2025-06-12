import 'package:immuno_warriors/domain/entities/antibody_entity.dart';
import 'package:immuno_warriors/domain/repositories/antibody_repository.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

class GetAntibodiesByTypeUseCase {
  final AntibodyRepository _antibodyRepository;

  GetAntibodiesByTypeUseCase(this._antibodyRepository);

  Future<List<AntibodyEntity>> execute(String type) async {
    try {
      return await _antibodyRepository.getAntibodiesByType(type);
    } catch (e) {
      AppLogger.error('Error getting antibodies by type: $e');
      rethrow;
    }
  }
}
