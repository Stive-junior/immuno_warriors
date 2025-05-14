import 'package:immuno_warriors/domain/entities/base_virale_entity.dart';
import 'package:immuno_warriors/domain/repositories/base_virale_repository.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

class GetBaseViraleByIdUseCase {
  final BaseViraleRepository _baseViraleRepository;

  GetBaseViraleByIdUseCase(this._baseViraleRepository);

  Future<BaseViraleEntity?> execute(String id) async {
    try {
      return await _baseViraleRepository.getBaseViraleById(id);
    } catch (e) {
      AppLogger.error('Error getting BaseVirale by id: $e');
      rethrow;
    }
  }
}