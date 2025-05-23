import 'package:immuno_warriors/domain/repositories/user_repository.dart';

class ClearUserCacheUseCase {
  final UserRepository _userRepository;

  ClearUserCacheUseCase(this._userRepository);

  Future<void> execute() async {
    await _userRepository.clearCurrentUserCache();
  }
}