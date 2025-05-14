import 'package:immuno_warriors/domain/entities/memory_signature.dart';

abstract class MemoryRepository {
  Future<List<MemorySignature>> getMemorySignatures(String userId);

  Future<void> addMemorySignature(String userId, MemorySignature signature);

  Future<void> clearExpiredMemorySignatures(String userId);
}