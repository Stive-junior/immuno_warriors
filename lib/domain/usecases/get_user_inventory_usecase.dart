import 'package:immuno_warriors/domain/repositories/user_repository.dart';

class GetUserInventoryUseCase {
  final UserRepository _userRepository;

  GetUserInventoryUseCase(this._userRepository);

  Future<List<dynamic>> execute() async {
    return await _userRepository.getUserInventory();
  }
}