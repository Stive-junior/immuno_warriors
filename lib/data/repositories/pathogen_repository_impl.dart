import 'package:immuno_warriors/domain/entities/combat/pathogen_entity.dart';
import 'package:immuno_warriors/domain/repositories/pathogen_repository.dart';
import 'package:immuno_warriors/core/constants/pathogen_types.dart';
import 'package:immuno_warriors/data/datasources/remote/pathogen_remote_datasource.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

class PathogenRepositoryImpl implements PathogenRepository {
  final PathogenRemoteDataSource _pathogenRemoteDataSource; // Exemple

  PathogenRepositoryImpl(this._pathogenRemoteDataSource);

  @override
  Future<List<PathogenEntity>> getAllPathogens() async {
    try {
      final pathogenModels = await _pathogenRemoteDataSource.getAllPathogens();
      return pathogenModels.map((model) => model.toEntity()).toList(); // Assurez-vous d'avoir une méthode toEntity()
    } catch (e) {
      AppLogger.error('Error getting all pathogens: $e');
      rethrow;
    }
  }

  @override
  Future<List<PathogenEntity>> getPathogensByType(PathogenType type) async {
    try {
      final pathogenModels = await _pathogenRemoteDataSource.getPathogensByType(type);
      return pathogenModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      AppLogger.error('Error getting pathogens by type: $e');
      rethrow;
    }
  }

  @override
  Future<PathogenEntity?> getPathogenById(String id) async {
    try {
      final pathogenModel = await _pathogenRemoteDataSource.getPathogen(id);
      return pathogenModel?.toEntity();
    } catch (e) {
      AppLogger.error('Error getting pathogen by id: $e');
      rethrow;
    }
  }

  @override
  Future<void> createPathogen(PathogenEntity pathogen) async {
    try {
      await _pathogenRemoteDataSource.createPathogen(pathogen.toJson()); // Assurez-vous d'avoir une méthode toJson()
    } catch (e) {
      AppLogger.error('Error creating pathogen: $e');
      rethrow;
    }
  }

  @override
  Future<void> updatePathogenStats(String id, Map<String, dynamic> updatedStats) async {
    try {
      await _pathogenRemoteDataSource.updatePathogen(id, updatedStats);
    } catch (e) {
      AppLogger.error('Error updating pathogen stats: $e');
      rethrow;
    }
  }

  @override
  Future<void> deletePathogen(String id) async {
    try {
      await _pathogenRemoteDataSource.deletePathogen(id);
    } catch (e) {
      AppLogger.error('Error deleting pathogen: $e');
      rethrow;
    }
  }
}