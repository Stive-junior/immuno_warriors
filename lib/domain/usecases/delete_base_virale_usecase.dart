import 'package:immuno_warriors/domain/repositories/base_virale_repository.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

class DeleteBaseViraleUseCase {
  final BaseViraleRepository _baseViraleRepository;

  DeleteBaseViraleUseCase(this._baseViraleRepository);

  Future<void> execute(String id) async {
    try {
      await _baseViraleRepository.deleteBaseVirale(id);
    } catch (e) {
      AppLogger.error('Error deleting BaseVirale: $e');
      rethrow;
    }
  }
}