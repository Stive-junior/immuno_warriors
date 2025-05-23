import 'package:immuno_warriors/domain/repositories/user_repository.dart';

class GetCachedSessionUseCase {
  final UserRepository _userRepository;

  GetCachedSessionUseCase(this._userRepository);

  Future<String?> execute(String userId) async {
    return await _userRepository.getCachedSession(userId);
  }
}
