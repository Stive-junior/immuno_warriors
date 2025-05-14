import 'package:immuno_warriors/domain/entities/memory_signature.dart';
import 'package:immuno_warriors/domain/repositories/memory_repository.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

class GetMemorySignaturesUseCase {
  final MemoryRepository _memoryRepository;

  GetMemorySignaturesUseCase(this._memoryRepository);

  Future<List<MemorySignature>> execute(String userId) async {
    try {
      return await _memoryRepository.getMemorySignatures(userId);
    } catch (e) {
      AppLogger.error('Error getting memory signatures: $e');
      rethrow;
    }
  }
}