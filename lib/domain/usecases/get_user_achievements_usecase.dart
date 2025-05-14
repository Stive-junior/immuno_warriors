import 'package:flutter/foundation.dart';
import 'package:immuno_warriors/domain/repositories/user_repository.dart';

class GetUserAchievementsUseCase {
  final UserRepository _userRepository;

  GetUserAchievementsUseCase(this._userRepository);

  Future<Map<String, bool>> execute() async {
    try {
      final achievements = await _userRepository.getUserAchievements();
      return achievements;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user achievements: $e');
      }
      rethrow;
    }
  }
}