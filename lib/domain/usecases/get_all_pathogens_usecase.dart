import 'package:immuno_warriors/domain/entities/combat/pathogen_entity.dart';
import 'package:immuno_warriors/domain/repositories/pathogen_repository.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

class GetAllPathogensUseCase {
  final PathogenRepository _pathogenRepository;

  GetAllPathogensUseCase(this._pathogenRepository);

  Future<List<PathogenEntity>> execute() async {
    try {
      final pathogens = await _pathogenRepository.getAllPathogens();
      return pathogens;
    } catch (e) {
      AppLogger.error('Error getting all pathogens: $e');
      rethrow; // Rethrow pour que la couche de présentation gère l'erreur
    }
  }
}