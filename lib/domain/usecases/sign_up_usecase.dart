import 'package:flutter/foundation.dart';
import 'package:immuno_warriors/core/services/auth_service.dart';
import 'package:immuno_warriors/domain/entities/user_entity.dart';
import 'package:immuno_warriors/domain/repositories/user_repository.dart';

class SignUpUseCase {
  final AuthService _authService;
  final UserRepository _userRepository;

  SignUpUseCase(this._authService, this._userRepository);

  Future<UserEntity?> execute({
    required String email,
    required String password,
  }) async {
    try {
      final UserEntity? firebaseUser = await _authService.signUp(email: email, password: password);
      if (firebaseUser != null) {
        // Après l'inscription via Firebase, l'entité utilisateur de base est retournée.
        // On pourrait vouloir récupérer les données complètes de l'utilisateur depuis le repository
        // ou s'assurer que les données initiales sont bien persistées.
        return await _userRepository.getCurrentUser();
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Sign up failed: $e');
      }
      rethrow;
    }
  }
}