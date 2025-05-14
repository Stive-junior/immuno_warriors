import 'package:immuno_warriors/domain/entities/combat/antibody_entity.dart';

abstract class AntibodyRepository {
  Future<AntibodyEntity?> getAntibodyById(String id);
  Future<void> createAntibody(AntibodyEntity antibody);
  Future<void> updateAntibody(String id, Map<String, dynamic> updatedStats);
  Future<List<AntibodyEntity>> getAntibodiesByType(String type);
  Future<List<AntibodyEntity>> getAllAntibodies();
  Future<void> deleteAntibody(String id);
}