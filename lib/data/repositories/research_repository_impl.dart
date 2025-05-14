import 'package:immuno_warriors/data/datasources/remote/research_datasource.dart';
import 'package:immuno_warriors/domain/entities/research_entity.dart';
import 'package:immuno_warriors/domain/repositories/research_repository.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:get_it/get_it.dart';

import '../models/research_model.dart';

class ResearchRepositoryImpl implements ResearchRepository {
  final ResearchRemoteDataSource remoteDataSource;
  final Map<String, dynamic> _researchProgress = {};

  ResearchRepositoryImpl({ResearchRemoteDataSource? remoteDataSource})
      : remoteDataSource = remoteDataSource ?? GetIt.I.get<ResearchRemoteDataSource>();

  @override
  Future<List<ResearchEntity>> getAllResearchItems() async {
    try {
      final result = await remoteDataSource.getAllResearchItems();
      return result.map((model) => model.toEntity()).toList();
    } catch (e) {
      AppLogger.error('Error fetching all research items: $e');
      rethrow;
    }
  }

  @override
  Future<ResearchEntity?> getResearchItem(String id) async {
    try {
      final result = await remoteDataSource.getResearchItem(id);
      return result.toEntity();
    } catch (e) {
      AppLogger.error('Error fetching research item with id $id: $e');
      rethrow;
    }
  }

  @override
  Future<void> unlockResearchItem(String id) async {
    try {
      final researchItem = await getResearchItem(id);
      if (researchItem != null) {
        final updatedResearchItem = researchItem.copyWith(isUnlocked: true);
        await updateResearchItem(id, updatedResearchItem);
        _researchProgress[id] = true; // Exemple: Marquer comme débloqué
      }
    } catch (e) {
      AppLogger.error('Error unlocking research item with id $id: $e');
      rethrow;
    }
  }

  @override
  Future<ResearchEntity> createResearchItem(ResearchEntity researchItem) async {
    try {
      final model = ResearchModel.fromEntity(researchItem);
      final result = await remoteDataSource.createResearchItem(model);
      return result.toEntity();
    } catch (e) {
      AppLogger.error('Error creating research item: $e');
      rethrow;
    }
  }

  @override
  Future<ResearchEntity> updateResearchItem(String id, ResearchEntity researchItem) async {
    try {
      final model = ResearchModel.fromEntity(researchItem);
      final result = await remoteDataSource.updateResearchItem(id, model);
      return result.toEntity();
    } catch (e) {
      AppLogger.error('Error updating research item with id $id: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteResearchItem(String id) async {
    try {
      await remoteDataSource.deleteResearchItem(id);
    } catch (e) {
      AppLogger.error('Error deleting research item with id $id: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getResearchProgress() async {
    return _researchProgress;
  }

  @override
  Future<void> saveResearchProgress(Map<String, dynamic> progress) async {
    _researchProgress.addAll(progress);
    AppLogger.info('Research progress saved: $_researchProgress'); // Log
  }
}