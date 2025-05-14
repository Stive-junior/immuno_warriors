import 'package:flutter/foundation.dart';
import 'package:immuno_warriors/core/services/auth_service.dart';

class SignOutUseCase {
  final AuthService _authService;

  SignOutUseCase(this._authService);

  Future<void> execute() async {
    try {
      await _authService.signOut();
      // Ici, on pourrait potentiellement effectuer d'autres actions après la déconnexion,
      // comme nettoyer le cache local de l'utilisateur via le UserRepository.
    } catch (e) {
      if (kDebugMode) {
        print('Sign out failed: $e');
      }
      rethrow;
    }
  }
}