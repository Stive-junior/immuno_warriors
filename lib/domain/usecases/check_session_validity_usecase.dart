import 'package:immuno_warriors/domain/repositories/user_repository.dart';

class CheckSessionValidityUseCase {
  final UserRepository _userRepository;

  CheckSessionValidityUseCase(this._userRepository);

  Future<bool> execute(String userId) async {
    try {

      final localValid = await _userRepository.checkSessionValidity(userId);
      if (!localValid) return false;


      return true;
    } catch (e) {
      return false;
    }
  }
}