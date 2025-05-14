import 'package:immuno_warriors/domain/entities/memory_signature.dart';
import 'package:immuno_warriors/domain/repositories/memory_repository.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

class AddMemorySignatureUseCase {
  final MemoryRepository _memoryRepository;

  AddMemorySignatureUseCase(this._memoryRepository);

  Future<void> execute(String userId, MemorySignature signature) async {
    try {
      await _memoryRepository.addMemorySignature(userId, signature);
    } catch (e) {
      AppLogger.error('Error adding memory signature: $e');
      rethrow;
    }
  }
}