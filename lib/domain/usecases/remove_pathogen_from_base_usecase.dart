import 'package:immuno_warriors/domain/entities/base_virale_entity.dart';
import 'package:immuno_warriors/domain/entities/combat/pathogen_entity.dart';
import 'package:immuno_warriors/domain/repositories/base_virale_repository.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

class RemovePathogenFromBaseUseCase {
  final BaseViraleRepository _baseViraleRepository;

  RemovePathogenFromBaseUseCase(this._baseViraleRepository);

  Future<BaseViraleEntity> execute(
      BaseViraleEntity baseVirale, PathogenEntity pathogen) async {
    try {
      final updatedPathogens = List<PathogenEntity>.from(baseVirale.pathogens)
        ..removeWhere((p) => p.id == pathogen.id);
      final updatedBaseVirale = BaseViraleEntity(
          id: baseVirale.id,
          playerId: baseVirale.playerId,
          name: baseVirale.name,
          level: baseVirale.level,
          pathogens: updatedPathogens,defenses: baseVirale.defenses,
      );

      await _baseViraleRepository.updateBaseVirale(updatedBaseVirale);
      return updatedBaseVirale;
    } catch (e) {
      AppLogger.error('Error removing pathogen from base: $e');
      rethrow;
    }
  }
}