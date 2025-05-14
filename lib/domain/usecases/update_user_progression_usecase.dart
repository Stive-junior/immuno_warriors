import 'package:flutter/foundation.dart';
import 'package:immuno_warriors/domain/repositories/user_repository.dart';

class UpdateUserProgressionUseCase {
  final UserRepository _userRepository;

  UpdateUserProgressionUseCase(this._userRepository);

  Future<void> execute(Map<String, dynamic> progression) async {
    try {
      await _userRepository.updateUserProgression(progression);
      // Potentiellement notifier les changements de progression.
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user progression: $e');
      }
      rethrow;
    }
  }
}