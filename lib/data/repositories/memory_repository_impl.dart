import 'package:hive/hive.dart';
import 'package:immuno_warriors/domain/entities/memory_signature.dart';
import 'package:immuno_warriors/domain/repositories/memory_repository.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

class MemoryRepositoryImpl implements MemoryRepository {
  final Box<MemorySignature> _memoryBox;

  MemoryRepositoryImpl(this._memoryBox);

  @override
  Future<List<MemorySignature>> getMemorySignatures(String userId) async {
    try {
      return _memoryBox.values
          .where((signature) => signature.isValid())
          .toList();
    } catch (e) {
      AppLogger.error('Error getting memory signatures: $e');
      rethrow;
    }
  }

  @override
  Future<void> addMemorySignature(
      String userId, MemorySignature signature) async {
    try {
      await _memoryBox.add(signature); // You might want to use a unique key
    } catch (e) {
      AppLogger.error('Error adding memory signature: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearExpiredMemorySignatures(String userId) async {
    try {
      final keysToRemove = _memoryBox.keys
          .where((key) => !(_memoryBox.get(key)!.isValid()))
          .toList();
      await _memoryBox.deleteAll(keysToRemove);
    } catch (e) {
      AppLogger.error('Error clearing expired signatures: $e');
      rethrow;
    }
  }
}