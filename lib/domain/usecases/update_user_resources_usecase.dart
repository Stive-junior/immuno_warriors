import 'package:flutter/foundation.dart';
import 'package:immuno_warriors/domain/repositories/user_repository.dart';

class UpdateUserResourcesUseCase {
  final UserRepository _userRepository;

  UpdateUserResourcesUseCase(this._userRepository);

  Future<void> execute(Map<String, dynamic> resources) async {
    try {
      await _userRepository.updateUserResources(resources);
      // Ici, on pourrait potentiellement notifier les listeners ou mettre à jour
      // un state management provider pour refléter le changement.
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user resources: $e');
      }
      rethrow;
    }
  }
}