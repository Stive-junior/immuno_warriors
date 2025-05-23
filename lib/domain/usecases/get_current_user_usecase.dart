import 'package:immuno_warriors/domain/entities/user_entity.dart';
import 'package:immuno_warriors/domain/repositories/user_repository.dart';

class GetCurrentUserUseCase {
  final UserRepository _userRepository;

  GetCurrentUserUseCase(this._userRepository);

  Future<UserEntity?> execute() async {
    return await _userRepository.getCurrentUser();
  }
}