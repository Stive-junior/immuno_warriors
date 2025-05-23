import 'package:immuno_warriors/domain/repositories/user_repository.dart';


import '../../core/services/auth_service.dart';

class UpdateUserInventoryUseCase {
  final UserRepository _userRepository;
  final AuthService _authService;

  UpdateUserInventoryUseCase(
      this._userRepository,
      this._authService,
      );

  Future<String> _getUserId() async {
    final user = _authService.currentUser;
    if (user == null || user.uid.isEmpty) {
      throw Exception('Utilisateur non connecté');
    }
    return user.uid;
  }

  /// ✅ Récupère l’inventaire actuel
  Future<List<dynamic>> getInventory() async {
    final userId = await _getUserId();
    final user = await _userRepository.getUserById(userId);
    return user?.inventory ?? [];
  }

  /// ✅ Remplace complètement l'inventaire
  Future<void> replaceInventory(List<dynamic> newInventory) async {
    final userId = await _getUserId();
    await _userRepository.updateUserInventory(userId, newInventory);
  }

  /// ✅ Ajoute un élément à l'inventaire (si pas déjà présent)
  Future<void> addItemToInventory(dynamic item) async {
    final currentInventory = await getInventory();
    if (!currentInventory.contains(item)) {
      currentInventory.add(item);
      await replaceInventory(currentInventory);
    }
  }

  /// ✅ Supprime un élément de l'inventaire (s’il existe)
  Future<void> removeItemFromInventory(dynamic item) async {
    final currentInventory = await getInventory();
    if (currentInventory.contains(item)) {
      currentInventory.remove(item);
      await replaceInventory(currentInventory);
    }
  }

  /// ✅ Vérifie si un item est dans l'inventaire
  Future<bool> containsItem(dynamic item) async {
    final currentInventory = await getInventory();
    return currentInventory.contains(item);
  }
}
