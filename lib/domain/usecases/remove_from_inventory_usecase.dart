import 'package:flutter/foundation.dart';
import 'package:immuno_warriors/domain/repositories/user_repository.dart';

class RemoveFromInventoryUseCase {
  final UserRepository _userRepository;

  RemoveFromInventoryUseCase(this._userRepository);

  Future<void> execute(dynamic item) async {
    try {
      await _userRepository.removeItemFromInventory(item);
      // Potentiellement notifier les changements d'inventaire.
    } catch (e) {
      if (kDebugMode) {
        print('Error removing item from inventory: $e');
      }
      rethrow;
    }
  }
}