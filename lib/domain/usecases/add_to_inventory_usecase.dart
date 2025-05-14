import 'package:flutter/foundation.dart';
import 'package:immuno_warriors/domain/repositories/user_repository.dart';

class AddToInventoryUseCase {
  final UserRepository _userRepository;

  AddToInventoryUseCase(this._userRepository);

  Future<void> execute(dynamic item) async {
    try {
      await _userRepository.addItemToInventory(item);
      // Potentiellement notifier les changements d'inventaire.
    } catch (e) {
      if (kDebugMode) {
        print('Error adding item to inventory: $e');
      }
      rethrow;
    }
  }
}