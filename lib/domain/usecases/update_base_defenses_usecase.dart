import 'package:immuno_warriors/core/constants/pathogen_types.dart';
import 'package:immuno_warriors/domain/entities/base_virale_entity.dart';
import 'package:immuno_warriors/domain/repositories/base_virale_repository.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

class UpdateBaseDefensesUseCase {
  final BaseViraleRepository _baseViraleRepository;

  UpdateBaseDefensesUseCase(this._baseViraleRepository);

  Future<BaseViraleEntity> execute(
      BaseViraleEntity baseVirale, Map<DefenseType, int> newDefenses) async {
    try {
      final updatedBaseVirale = BaseViraleEntity(
        id: baseVirale.id,
        playerId: baseVirale.playerId,
        name: baseVirale.name,
        level: baseVirale.level,
        pathogens: baseVirale.pathogens,
        defenses: newDefenses,
      );

      await _baseViraleRepository.updateBaseVirale(updatedBaseVirale);
      return updatedBaseVirale;
    } catch (e) {
      AppLogger.error('Error updating base defenses: $e');
      rethrow;
    }
  }
}