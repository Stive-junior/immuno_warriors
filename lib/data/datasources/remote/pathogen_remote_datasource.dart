import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:immuno_warriors/data/models/combat/pathogen_model.dart';
import 'package:immuno_warriors/core/constants/pathogen_types.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart'; // Pour la gestion des erreurs

class PathogenRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'pathogens'; // Nom de ta collection dans Firestore

  /// Récupère tous les pathogènes depuis Firestore.
  Future<List<PathogenModel>> getAllPathogens() async {
    try {
      final snapshot = await _firestore.collection(_collectionName).get();
      return snapshot.docs.map((doc) => PathogenModel.fromJson(doc.data())).toList();
    } catch (e) {
      AppLogger.error('Error getting all pathogens from Firestore: $e');
      rethrow;
    }
  }

  /// Récupère les pathogènes d'un type spécifique depuis Firestore.
  Future<List<PathogenModel>> getPathogensByType(PathogenType type) async {
    try {
      final snapshot = await _firestore.collection(_collectionName)
          .where('type', isEqualTo: type.toString().split('.').last)
          .get();
      return snapshot.docs.map((doc) => PathogenModel.fromJson(doc.data())).toList();
    } catch (e) {
      AppLogger.error('Error getting pathogens by type from Firestore: $e');
      rethrow;
    }
  }

  /// Récupère un pathogène par son ID depuis Firestore.
  Future<PathogenModel?> getPathogen(String id) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(id).get();
      if (doc.exists) {
        return PathogenModel.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      AppLogger.error('Error getting pathogen by ID from Firestore: $e');
      rethrow;
    }
  }

  /// Crée un nouveau pathogène dans Firestore.
  Future<void> createPathogen(Map<String, dynamic> pathogenJson) async {
    try {
      await _firestore.collection(_collectionName).add(pathogenJson);
    } catch (e) {
      AppLogger.error('Error creating pathogen in Firestore: $e');
      rethrow;
    }
  }

  /// Met à jour les statistiques d'un pathogène dans Firestore.
  Future<void> updatePathogen(String id, Map<String, dynamic> updatedStats) async {
    try {
      await _firestore.collection(_collectionName).doc(id).update(updatedStats);
    } catch (e) {
      AppLogger.error('Error updating pathogen in Firestore: $e');
      rethrow;
    }
  }

  /// Supprime un pathogène de Firestore.
  Future<void> deletePathogen(String id) async {
    try {
      await _firestore.collection(_collectionName).doc(id).delete();
    } catch (e) {
      AppLogger.error('Error deleting pathogen from Firestore: $e');
      rethrow;
    }
  }
}