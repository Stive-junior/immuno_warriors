import 'package:immuno_warriors/domain/entities/base_virale_entity.dart';
import 'package:immuno_warriors/domain/repositories/base_virale_repository.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

class CreateBaseViraleUseCase {
  final BaseViraleRepository _baseViraleRepository;

  CreateBaseViraleUseCase(this._baseViraleRepository);

  Future<void> execute(BaseViraleEntity baseVirale) async {
    try {
      await _baseViraleRepository.createBaseVirale(baseVirale);
    } catch (e) {
      AppLogger.error('Error creating BaseVirale: $e');
      rethrow;
    }
  }
}