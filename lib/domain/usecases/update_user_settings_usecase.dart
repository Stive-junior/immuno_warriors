import 'package:flutter/foundation.dart';
import 'package:immuno_warriors/domain/repositories/user_repository.dart';

class UpdateUserSettingsUseCase {
  final UserRepository _userRepository;

  UpdateUserSettingsUseCase(this._userRepository);

  Future<void> execute(Map<String, dynamic> settings) async {
    try {
      await _userRepository.updateUserSettings(settings);
      // Potentiellement notifier les changements de paramètres.
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user settings: $e');
      }
      rethrow;
    }
  }
}