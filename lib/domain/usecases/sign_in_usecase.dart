import 'package:flutter/foundation.dart';
import 'package:immuno_warriors/core/services/auth_service.dart';
import 'package:immuno_warriors/domain/entities/user_entity.dart';
import 'package:immuno_warriors/domain/repositories/user_repository.dart';

class SignInUseCase {
  final AuthService _authService;
  final UserRepository _userRepository;

  SignInUseCase(this._authService, this._userRepository);

  Future<UserEntity?> execute({
    required String email,
    required String password,
  }) async {
    try {
      final UserEntity? firebaseUser = await _authService.signIn(email: email, password: password);
      if (firebaseUser != null) {
        // Après la connexion via Firebase, l'entité utilisateur est retournée.
        // On récupère ensuite les données potentiellement plus complètes depuis le repository.
        return await _userRepository.getCurrentUser();
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Sign in failed: $e');
      }
      rethrow;
    }
  }
}