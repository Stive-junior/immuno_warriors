
import 'package:immuno_warriors/core/services/auth_service.dart';
import 'package:immuno_warriors/domain/entities/user_entity.dart';
import 'package:immuno_warriors/domain/repositories/user_repository.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/core/network/network_info.dart';
import 'package:immuno_warriors/core/constants/app_strings.dart';


class SignUpUseCase {
  final AuthService _authService;
  final UserRepository _userRepository;
  final NetworkInfo _networkInfo;


  SignUpUseCase(this._authService, this._userRepository, this._networkInfo);


  Future<UserEntity?> execute({
    required String email,
    required String password,
    String? username,
    String? avatarUrl,
  }) async {
    AppLogger.info('Attempting sign up for email: $email via SignUpUseCase.');


    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      AppLogger.warning('SignUpUseCase: No internet connection for email: $email');
      throw Exception(AppStrings.noInternetConnection);
    }
    AppLogger.info('Network is connected. Proceeding with sign up via AuthService.');

    try {

      final UserEntity? newUser = await _authService.signUp(
        email: email,
        password: password,
        username: username,
        avatarUrl: avatarUrl,
      );

      if (newUser != null) {
        AppLogger.info('User ${newUser.email} successfully created by AuthService. Now saving locally.');


        await _userRepository.saveUser(newUser);
        AppLogger.info('User ${newUser.email} successfully registered and saved locally (Hive).');
        return newUser; // Retourne l'entité utilisateur complète
      } else {
        AppLogger.warning('SignUpUseCase: AuthService.signUp returned null for email: $email');
        return null;
      }
    } catch (e, stackTrace) {
      AppLogger.error('SignUpUseCase failed for email: $email', error: e, stackTrace: stackTrace);
      rethrow; // Relance l'exception pour que la couche de présentation puisse la gérer.
    }
  }
}
