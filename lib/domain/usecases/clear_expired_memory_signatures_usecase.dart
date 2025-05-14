import 'package:immuno_warriors/domain/repositories/memory_repository.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

class ClearExpiredMemorySignaturesUseCase {
  final MemoryRepository _memoryRepository;

  ClearExpiredMemorySignaturesUseCase(this._memoryRepository);

  Future<void> execute(String userId) async {
    try {
      await _memoryRepository.clearExpiredMemorySignatures(userId);
    } catch (e) {
      AppLogger.error('Error clearing expired signatures: $e');
      rethrow;
    }
  }
}