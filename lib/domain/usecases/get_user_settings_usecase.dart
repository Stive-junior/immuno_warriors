import 'package:flutter/foundation.dart';
import 'package:immuno_warriors/domain/repositories/user_repository.dart';

class GetUserSettingsUseCase {
  final UserRepository _userRepository;

  GetUserSettingsUseCase(this._userRepository);

  Future<Map<String, dynamic>> execute() async {
    try {
      final settings = await _userRepository.getUserSettings();
      return settings;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user settings: $e');
      }
      rethrow;
    }
  }
}