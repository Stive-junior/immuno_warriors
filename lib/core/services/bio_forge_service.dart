import 'package:immuno_warriors/core/constants/pathogen_types.dart';
import 'package:immuno_warriors/domain/entities/base_virale_entity.dart';
import 'package:immuno_warriors/domain/entities/combat/pathogen_entity.dart';
import 'package:immuno_warriors/domain/repositories/base_virale_repository.dart'; // Si nécessaire
import 'package:immuno_warriors/core/utils/app_logger.dart';

class BioForgeService {
  final BaseViraleRepository? _baseViraleRepository; // Inject si nécessaire

  BioForgeService({BaseViraleRepository? baseViraleRepository})
      : _baseViraleRepository = baseViraleRepository;

  /// Adds a pathogen to the BaseVirale.
  Future<BaseViraleEntity> addPathogenToBase(
      BaseViraleEntity baseVirale, PathogenEntity pathogen) async {
    try {
      final updatedPathogens = List<PathogenEntity>.from(baseVirale.pathogens)..add(pathogen);
      final updatedBaseVirale = BaseViraleEntity(
        id: baseVirale.id,
        playerId: baseVirale.playerId,
        name: baseVirale.name,
        level: baseVirale.level,
        pathogens: updatedPathogens,
        defenses: baseVirale.defenses,
      );

      if (_baseViraleRepository != null) {
        await _baseViraleRepository.updateBaseVirale(updatedBaseVirale);
      }

      return updatedBaseVirale;
    } catch (e) {
      AppLogger.error('Error adding pathogen to base: $e');
      rethrow;
    }}

  /// Removes a pathogen from the BaseVirale.
  Future<BaseViraleEntity> removePathogenFromBase(
      BaseViraleEntity baseVirale, PathogenEntity pathogen) async {
    try {
      final updatedPathogens = List<PathogenEntity>.from(baseVirale.pathogens)
        ..removeWhere((p) => p.id == pathogen.id);
      final updatedBaseVirale = BaseViraleEntity(
        id: baseVirale.id,
        playerId: baseVirale.playerId,
        name: baseVirale.name,
        level: baseVirale.level,
        pathogens: updatedPathogens,
        defenses: baseVirale.defenses,
      );

      if (_baseViraleRepository != null) {
        await _baseViraleRepository.updateBaseVirale(updatedBaseVirale);
      }

      return updatedBaseVirale;
    } catch (e) {
      AppLogger.error('Error removing pathogen from base: $e');
      rethrow;
    }
  }

  /// Updates the defenses of the BaseVirale.
  Future<BaseViraleEntity> updateBaseDefenses(
      BaseViraleEntity baseVirale,
      Map< DefenseType, int> newDefenses,
      ) async {
    try {
      final updatedBaseVirale = BaseViraleEntity(
        id: baseVirale.id,
        playerId: baseVirale.playerId,
        name: baseVirale.name,
        level: baseVirale.level,
        pathogens: baseVirale.pathogens,
        defenses: newDefenses,
      );

      if (_baseViraleRepository != null) {
        await _baseViraleRepository.updateBaseVirale(updatedBaseVirale);
      }

      return updatedBaseVirale;
    } catch (e) {
      AppLogger.error('Error updating base defenses: $e');
      rethrow;
    }
  }
}
