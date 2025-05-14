import 'package:immuno_warriors/domain/entities/combat/antibody_entity.dart';
import 'package:immuno_warriors/domain/repositories/antibody_repository.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

class GetAntibodyByIdUseCase {
  final AntibodyRepository _antibodyRepository;

  GetAntibodyByIdUseCase(this._antibodyRepository);

  Future<AntibodyEntity?> execute(String id) async {
    try {
      return await _antibodyRepository.getAntibodyById(id);
    } catch (e) {
      AppLogger.error('Error getting antibody by id: $e');
      rethrow;
    }
  }
}