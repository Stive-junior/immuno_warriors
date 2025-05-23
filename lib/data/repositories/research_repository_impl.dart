import 'package:immuno_warriors/data/datasources/remote/research_datasource.dart';
import 'package:immuno_warriors/domain/entities/research_entity.dart';
import 'package:immuno_warriors/domain/repositories/research_repository.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:get_it/get_it.dart';
import 'package:immuno_warriors/core/services/auth_service.dart'; // Import AuthService
import 'package:immuno_warriors/core/services/local_storage_service.dart'; // Import LocalStorageService

import '../models/research_model.dart';

class ResearchRepositoryImpl implements ResearchRepository {
  final ResearchRemoteDataSource remoteDataSource;
  final AuthService _authService; // Instance de AuthService
  final LocalStorageService _localStorageService; // Instance de LocalStorageService
  static const String _researchProgressKey = 'research_progress';

  ResearchRepositoryImpl({
    ResearchRemoteDataSource? remoteDataSource,
    required AuthService authService,
    LocalStorageService? localStorageService,
  })  : remoteDataSource = remoteDataSource ?? GetIt.I.get<ResearchRemoteDataSource>(),
        _authService = authService,
        _localStorageService = localStorageService ?? GetIt.I.get<LocalStorageService>();

  String? get _currentUserId => _authService.currentUser?.uid;

  Future<String?> get _userSpecificProgressKey async {
    final userId = _currentUserId;
    return userId != null ? '$_researchProgressKey\_$userId' : null;
  }

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
    final userId = _currentUserId;
    final progressKey = await _userSpecificProgressKey;
    if (userId == null || progressKey == null) {
      AppLogger.warning('No user ID available to unlock research item.');
      return;
    }
    try {
      final researchItem = await getResearchItem(id);
      if (researchItem != null) {
        final updatedResearchItem = researchItem.copyWith(isUnlocked: true);
        await updateResearchItem(id, updatedResearchItem);
        // Sauvegarder la progression de la recherche pour l'utilisateur actuel
        final currentProgress = await getResearchProgress();
        currentProgress[id] = true;
        await saveResearchProgress(currentProgress);
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
    final userId = _currentUserId;
    final progressKey = await _userSpecificProgressKey;
    if (userId == null || progressKey == null) {
      AppLogger.warning('No user ID available to get research progress.');
      return {};
    }
    return _localStorageService.getData(progressKey) as Map<String, dynamic>? ?? {};
  }

  @override
  Future<void> saveResearchProgress(Map<String, dynamic> progress) async {
    final userId = _currentUserId;
    final progressKey = await _userSpecificProgressKey;
    if (userId == null || progressKey == null) {
      AppLogger.warning('No user ID available to save research progress.');
      return;
    }
    await _localStorageService.saveData(progressKey, progress);
    AppLogger.info('Research progress saved for user $userId: $progress'); // Log
  }
}