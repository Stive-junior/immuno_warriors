import 'package:immuno_warriors/domain/repositories/user_repository.dart';

class ClearUserSessionUseCase {
  final UserRepository _userRepository;

  ClearUserSessionUseCase(this._userRepository);

  Future<void> execute(String userId) async {
    await _userRepository.clearCachedSession(userId);
  }
}