import 'package:flutter/foundation.dart';
import 'package:immuno_warriors/domain/repositories/user_repository.dart';

class GetUserProgressionUseCase {
  final UserRepository _userRepository;

  GetUserProgressionUseCase(this._userRepository);

  Future<Map<String, dynamic>> execute() async {
    try {
      final progression = await _userRepository.getUserProgression();
      return progression;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user progression: $e');
      }
      rethrow;
    }
  }
}