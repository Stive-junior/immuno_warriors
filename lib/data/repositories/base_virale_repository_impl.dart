import 'package:hive/hive.dart';
import 'package:immuno_warriors/domain/entities/base_virale_entity.dart';
import 'package:immuno_warriors/domain/repositories/base_virale_repository.dart';
import 'package:immuno_warriors/data/models/base_viral_model.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

class BaseViraleRepositoryImpl implements BaseViraleRepository {
  final Box<BaseViraleModel> _baseViraleBox;

  BaseViraleRepositoryImpl(this._baseViraleBox);

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
}
