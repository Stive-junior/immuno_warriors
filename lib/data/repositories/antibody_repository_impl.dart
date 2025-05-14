import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:immuno_warriors/domain/entities/combat/antibody_entity.dart';
import 'package:immuno_warriors/domain/repositories/antibody_repository.dart';
import 'package:immuno_warriors/data/models/combat/antibody_model.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

class AntibodyRepositoryImpl implements AntibodyRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'antibodies';

  @override
  Future<AntibodyEntity?> getAntibodyById(String id) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(id).get();
      if (doc.exists) {
        return AntibodyModel.fromJson(doc.data() as Map<String, dynamic>).toEntity();
      } else {
        return null;
      }
    } catch (e) {
      AppLogger.error('Error getting antibody by ID: $e');
      rethrow;
    }
  }

  @override
  Future<void> createAntibody(AntibodyEntity antibody) async {
    try {
      final antibodyModel = AntibodyModel.fromEntity(antibody);
      await _firestore.collection(_collectionName).add(antibodyModel.toJson());
    } catch (e) {
      AppLogger.error('Error creating antibody: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateAntibody(String id, Map<String, dynamic> updatedStats) async {
    try {
      await _firestore.collection(_collectionName).doc(id).update(updatedStats);
    } catch (e) {
      AppLogger.error('Error updating antibody: $e');
      rethrow;
    }
  }

  @override
  Future<List<AntibodyEntity>> getAntibodiesByType(String type) async {
    try {
      final snapshot = await _firestore.collection(_collectionName)
          .where('type', isEqualTo: type)
          .get();
      return snapshot.docs.map((doc) => AntibodyModel.fromJson(doc.data()).toEntity()).toList();
    } catch (e) {
      AppLogger.error('Error getting antibodies by type: $e');
      rethrow;
    }
  }

  @override
  Future<List<AntibodyEntity>> getAllAntibodies() async {
    try {
      final snapshot = await _firestore.collection(_collectionName).get();
      return snapshot.docs.map((doc) => AntibodyModel.fromJson(doc.data()).toEntity()).toList();
    } catch (e) {
      AppLogger.error('Error getting all antibodies: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteAntibody(String id) async {
    try {
      await _firestore.collection(_collectionName).doc(id).delete();
    } catch (e) {
      AppLogger.error('Error deleting antibody: $e');
      rethrow;
    }
  }
}