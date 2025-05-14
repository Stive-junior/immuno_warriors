import 'package:immuno_warriors/domain/entities/combat/pathogen_entity.dart';
import 'package:immuno_warriors/core/constants/pathogen_types.dart';

abstract class PathogenRepository {
  Future<List<PathogenEntity>> getAllPathogens();
  Future<List<PathogenEntity>> getPathogensByType(PathogenType type);
  Future<PathogenEntity?> getPathogenById(String id);
  Future<void> createPathogen(PathogenEntity pathogen);
  Future<void> updatePathogenStats(String id, Map<String, dynamic> updatedStats);
  Future<void> deletePathogen(String id);
}