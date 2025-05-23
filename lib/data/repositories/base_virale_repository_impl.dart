import 'package:hive/hive.dart';
import 'package:immuno_warriors/domain/entities/base_virale_entity.dart';
import 'package:immuno_warriors/domain/repositories/base_virale_repository.dart';
import 'package:immuno_warriors/data/models/base_viral_model.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/core/services/bio_forge_service.dart';
import 'package:get_it/get_it.dart';
import 'package:immuno_warriors/domain/entities/combat/pathogen_entity.dart';

import '../../core/constants/pathogen_types.dart';

class BaseViraleRepositoryImpl implements BaseViraleRepository {
  final Box<BaseViraleModel> _baseViraleBox;
  final BioForgeService _bioForgeService; // Get BioForgeService instance via constructor

  BaseViraleRepositoryImpl(this._baseViraleBox, {BioForgeService? bioForgeService})
      : _bioForgeService = bioForgeService ?? GetIt.I.get<BioForgeService>();

  @override
  Future<BaseViraleEntity?> getBaseViraleById(String id) async {
    try {
      final model = _baseViraleBox.get(id);
      return model?.toEntity();
    } catch (e) {
      AppLogger.error('Error getting BaseVirale by ID: $e');
      rethrow;
    }
  }

  @override
  Future<void> createBaseVirale(BaseViraleEntity baseVirale) async {
    try {
      final model = BaseViraleModel.fromEntity(baseVirale);
      await _baseViraleBox.put(model.id, model);
    } catch (e) {
      AppLogger.error('Error creating BaseVirale: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateBaseVirale(BaseViraleEntity baseVirale) async {
    try {
      final model = BaseViraleModel.fromEntity(baseVirale);
      await _baseViraleBox.put(model.id, model);
    } catch (e) {
      AppLogger.error('Error updating BaseVirale: $e');
      rethrow;
    }
  }

  @override
  Future<List<BaseViraleEntity>> getBaseViralesForPlayer(String playerId) async {
    try {
      final models = _baseViraleBox.values
          .where((model) => model.playerId == playerId)
          .toList();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      AppLogger.error('Error getting BaseVirales for player: $e');
      rethrow;
    }
  }

  @override
  Future<List<BaseViraleEntity>> getAllBaseVirales() async {
    try {
      final models = _baseViraleBox.values.toList();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      AppLogger.error('Error getting all BaseVirales: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteBaseVirale(String id) async {
    try {
      await _baseViraleBox.delete(id);
    } catch (e) {
      AppLogger.error('Error deleting BaseVirale: $e');
      rethrow;
    }
  }

  @override
  Future<BaseViraleEntity> addPathogenToBase(String baseId, PathogenEntity pathogen) async {
    try {
      final baseVirale = await getBaseViraleById(baseId);
      if (baseVirale != null) {
        return await _bioForgeService.addPathogenToBase(baseVirale, pathogen);
      }
      throw Exception('BaseVirale not found: $baseId');
    } catch (e) {
      AppLogger.error('Error adding pathogen to base via repository: $e');
      rethrow;
    }
  }

  @override
  Future<BaseViraleEntity> removePathogenFromBase(String baseId, PathogenEntity pathogen) async {
    try {
      final baseVirale = await getBaseViraleById(baseId);
      if (baseVirale != null) {
        return await _bioForgeService.removePathogenFromBase(baseVirale, pathogen);
      }
      throw Exception('BaseVirale not found: $baseId');
    } catch (e) {
      AppLogger.error('Error removing pathogen from base via repository: $e');
      rethrow;
    }
  }

  @override
  Future<BaseViraleEntity> updateBaseDefenses(String baseId, Map<int, int> newDefenses) async {
    try {
      final baseVirale = await getBaseViraleById(baseId);
      if (baseVirale != null) {
        // Convert the int-based map to the enum-based map expected by BioForgeService
        final defenseMap = newDefenses.map((key, value) {
          // Assuming your DefenseType enum has values corresponding to these integers
          // You'll need to adjust this mapping based on your actual enum definition
          switch (key) {
            case 0:
              return MapEntry(DefenseType.wall, value);
            case 1:
              return MapEntry(DefenseType.turret, value);
          // Add more cases as needed
            default:
              AppLogger.warning('Unknown defense type integer: $key');
              return MapEntry(DefenseType.wall, 0); // Default to avoid errors
          }
        });
        return await _bioForgeService.updateBaseDefenses(baseVirale, defenseMap);
      }
      throw Exception('BaseVirale not found: $baseId');
    } catch (e) {
      AppLogger.error('Error updating base defenses via repository: $e');
      rethrow;
    }
  }
}