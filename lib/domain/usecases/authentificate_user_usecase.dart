import 'package:immuno_warriors/domain/repositories/user_repository.dart';

class AuthenticateUserUsecase {
  final UserRepository _userRepository;

  AuthenticateUserUsecase(this._userRepository);

  Future<bool> execute(String email, String password) async {
    try {
      final isValid = await _userRepository.authenticateUser(email, password);
      return isValid;
    } catch (e) {
      rethrow; // Meilleure pratique que de retourner false silencieusement
    }
  }
}