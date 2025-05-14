import 'package:immuno_warriors/domain/entities/base_virale_entity.dart';
import 'package:immuno_warriors/domain/repositories/base_virale_repository.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

class GetAllBaseViralesUseCase {
  final BaseViraleRepository _baseViraleRepository;

  GetAllBaseViralesUseCase(this._baseViraleRepository);

  Future<List<BaseViraleEntity>> execute() async {
    try {
      return await _baseViraleRepository.getAllBaseVirales();
    } catch (e) {
      AppLogger.error('Error getting all BaseVirales: $e');
      rethrow;
    }
  }
}