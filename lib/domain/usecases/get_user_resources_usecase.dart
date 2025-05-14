import 'package:flutter/foundation.dart';
import 'package:immuno_warriors/domain/repositories/user_repository.dart';

class GetUserResourcesUseCase {
  final UserRepository _userRepository;

  GetUserResourcesUseCase(this._userRepository);

  Future<Map<String, dynamic>> execute() async {
    try {
      final resources = await _userRepository.getUserResources();
      return resources;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user resources: $e');
      }
      // Ici, on pourrait potentiellement retourner un état d'erreur spécifique
      // ou rethrow l'exception pour être gérée par la couche supérieure (Bloc/Provider).
      rethrow;
    }
  }
}