import 'package:flutter/foundation.dart';
import 'package:immuno_warriors/domain/repositories/user_repository.dart';

class UpdateUserAchievementsUseCase {
  final UserRepository _userRepository;

  UpdateUserAchievementsUseCase(this._userRepository);

  Future<void> execute(Map<String, bool> achievements) async {
    try {
      await _userRepository.updateUserAchievements(achievements);
      // Potentiellement notifier les changements d'achievements.
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user achievements: $e');
      }
      rethrow;
    }
  }
}