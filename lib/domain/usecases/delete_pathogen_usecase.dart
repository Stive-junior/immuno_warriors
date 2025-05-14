import 'package:immuno_warriors/domain/repositories/pathogen_repository.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

class DeletePathogenUseCase {
  final PathogenRepository _pathogenRepository;

  DeletePathogenUseCase(this._pathogenRepository);

  Future<void> execute(String id) async {
    try {
      await _pathogenRepository.deletePathogen(id);
    } catch (e) {
      AppLogger.error('Error deleting pathogen: $e');
      rethrow;
    }
  }
}