import 'package:immuno_warriors/domain/entities/combat/pathogen_entity.dart';
import 'package:immuno_warriors/domain/repositories/pathogen_repository.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/core/constants/pathogen_types.dart'; // Assurez-vous d'avoir ce fichier

class GetPathogensByTypeUseCase {
  final PathogenRepository _pathogenRepository;

  GetPathogensByTypeUseCase(this._pathogenRepository);

  Future<List<PathogenEntity>> execute(PathogenType type) async {
    try {
      final pathogens = await _pathogenRepository.getPathogensByType(type);
      return pathogens;
    } catch (e) {
      AppLogger.error('Error getting pathogens by type: $e');
      rethrow;
    }
  }
}