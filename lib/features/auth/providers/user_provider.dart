import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:immuno_warriors/core/exceptions/app_exception.dart';
import 'package:immuno_warriors/core/services/network_service.dart';
import 'package:immuno_warriors/core/services/user_service.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/core/constants/app_strings.dart';
import 'package:immuno_warriors/data/models/inventory_item_model.dart';
import 'package:immuno_warriors/domain/entities/user_entity.dart';
import 'package:immuno_warriors/features/auth/providers/auth_provider.dart';

// État de l'utilisateur
class UserState {
  final UserEntity? userProfile;
  final Map<String, dynamic>? resources;
  final List<InventoryItemModel>? inventory;
  final Map<String, dynamic>? settings;
  final bool isLoading;
  final String? errorMessage;

  UserState({
    this.userProfile,
    this.resources,
    this.inventory,
    this.settings,
    this.isLoading = false,
    this.errorMessage,
  });

  UserState copyWith({
    UserEntity? userProfile,
    Map<String, dynamic>? resources,
    List<InventoryItemModel>? inventory,
    Map<String, dynamic>? settings,
    bool? isLoading,
    String? errorMessage,
  }) {
    return UserState(
      userProfile: userProfile ?? this.userProfile,
      resources: resources ?? this.resources,
      inventory: inventory ?? this.inventory,
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Notifier pour gérer l'état de l'utilisateur
class UserNotifier extends StateNotifier<UserState> {
  final UserService _userService;
  final NetworkService _networkService;

  UserNotifier(this._userService, this._networkService) : super(UserState());

  /// Initialise l'état de l'utilisateur
  Future<void> initialize() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      if (!await _networkService.isConnected) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: AppStrings.noInternetConnection,
        );
        AppLogger.warning('Pas de connexion réseau lors de l\'initialisation');
        return;
      }

      if (!await _networkService.isServerReachable()) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: AppStrings.networkError,
        );
        AppLogger.warning('Serveur non accessible lors de l\'initialisation');
        return;
      }

      await loadUserProfile();
      await loadUserResources();
      await loadUserInventory();
      await loadUserSettings();
      state = state.copyWith(isLoading: false, errorMessage: null);
      AppLogger.info('Initialisation de l\'utilisateur terminée');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e is ApiException ? e.message : AppStrings.errorMessage,
      );
      AppLogger.error(
        'Erreur lors de l\'initialisation de l\'utilisateur : $e',
      );
    }
  }

  /// Charge le profil de l'utilisateur
  Future<void> loadUserProfile() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _userService.getUserProfile();
    result.fold(
      (error) =>
          state = state.copyWith(isLoading: false, errorMessage: error.message),
      (profile) =>
          state = state.copyWith(
            userProfile: profile,
            isLoading: false,
            errorMessage: null,
          ),
    );
  }

  /// Met à jour le profil de l'utilisateur
  Future<void> updateUserProfile({String? username, String? avatar}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _userService.updateUserProfile(username: username, avatar: avatar);
      await loadUserProfile(); // Recharger le profil après mise à jour
      state = state.copyWith(isLoading: false, errorMessage: null);
      AppLogger.info('Profil utilisateur mis à jour');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e is ApiException ? e.message : AppStrings.errorMessage,
      );
      AppLogger.error('Erreur lors de la mise à jour du profil : $e');
    }
  }

  /// Charge les ressources de l'utilisateur
  Future<void> loadUserResources() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _userService.getUserResources();
    result.fold(
      (error) =>
          state = state.copyWith(isLoading: false, errorMessage: error.message),
      (resources) =>
          state = state.copyWith(
            resources: resources,
            isLoading: false,
            errorMessage: null,
          ),
    );
  }

  /// Ajoute des ressources à l'utilisateur
  Future<void> addUserResources({int? credits, int? energy}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _userService.addUserResources(credits: credits, energy: energy);
      await loadUserResources(); // Recharger les ressources après ajout
      state = state.copyWith(isLoading: false, errorMessage: null);
      AppLogger.info('Ressources utilisateur ajoutées');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e is ApiException ? e.message : AppStrings.errorMessage,
      );
      AppLogger.error('Erreur lors de l\'ajout des ressources : $e');
    }
  }

  /// Charge l'inventaire de l'utilisateur
  Future<void> loadUserInventory() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _userService.getUserInventory();
    result.fold(
      (error) =>
          state = state.copyWith(isLoading: false, errorMessage: error.message),
      (inventory) =>
          state = state.copyWith(
            inventory: inventory.cast<InventoryItemModel>(),
            isLoading: false,
            errorMessage: null,
          ),
    );
  }

  /// Ajoute un élément à l'inventaire
  Future<void> addInventoryItem(
    String id,
    String type,
    String name,
    int quantity,
    Map<String, dynamic> properties,
  ) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _userService.addInventoryItem(id, type, name, quantity, properties);
      await loadUserInventory(); // Recharger l'inventaire après ajout
      state = state.copyWith(isLoading: false, errorMessage: null);
      AppLogger.info('Élément ajouté à l\'inventaire : $id');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e is ApiException ? e.message : AppStrings.errorMessage,
      );
      AppLogger.error('Erreur lors de l\'ajout à l\'inventaire : $e');
    }
  }

  /// Supprime un élément de l'inventaire
  Future<void> removeInventoryItem(String itemId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _userService.removeInventoryItem(itemId);
      await loadUserInventory(); // Recharger l'inventaire après suppression
      state = state.copyWith(isLoading: false, errorMessage: null);
      AppLogger.info('Élément supprimé de l\'inventaire : $itemId');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e is ApiException ? e.message : AppStrings.errorMessage,
      );
      AppLogger.error('Erreur lors de la suppression de l\'inventaire : $e');
    }
  }

  /// Charge les paramètres de l'utilisateur
  Future<void> loadUserSettings() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _userService.getUserSettings();
    result.fold(
      (error) =>
          state = state.copyWith(isLoading: false, errorMessage: error.message),
      (settings) =>
          state = state.copyWith(
            settings: settings,
            isLoading: false,
            errorMessage: null,
          ),
    );
  }

  /// Met à jour les paramètres de l'utilisateur
  Future<void> updateUserSettings({
    bool? notifications,
    bool? sound,
    String? language,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _userService.updateUserSettings(
        notifications: notifications,
        sound: sound,
        language: language,
      );
      await loadUserSettings(); // Recharger les paramètres après mise à jour
      state = state.copyWith(isLoading: false, errorMessage: null);
      AppLogger.info('Paramètres utilisateur mis à jour');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e is ApiException ? e.message : AppStrings.errorMessage,
      );
      AppLogger.error('Erreur lors de la mise à jour des paramètres : $e');
    }
  }

  /// Supprime le compte de l'utilisateur
  Future<void> deleteUser() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _userService.deleteUser();
      state = UserState(); // Réinitialiser l'état
      AppLogger.info('Compte utilisateur supprimé');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e is ApiException ? e.message : AppStrings.errorMessage,
      );
      AppLogger.error('Erreur lors de la suppression du compte : $e');
    }
  }

  /// Réinitialise les erreurs
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

// Fournisseur pour UserService
final userServiceProvider = Provider<UserService>((ref) {
  return UserService(
    ref.read(dioClientProvider),
    ref.read(localStorageServiceProvider),
    ref.read(networkServiceProvider),
  );
});

// Fournisseur principal pour UserNotifier
final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier(
    ref.read(userServiceProvider),
    ref.read(networkServiceProvider),
  );
});

// Fournisseurs dérivés
final userProfileProvider = Provider<UserEntity?>((ref) {
  return ref.watch(userProvider.select((state) => state.userProfile));
});

final userResourcesProvider = Provider<Map<String, dynamic>?>((ref) {
  return ref.watch(userProvider.select((state) => state.resources));
});

final userInventoryProvider = Provider<List<InventoryItemModel>?>((ref) {
  return ref.watch(userProvider.select((state) => state.inventory));
});

final userSettingsProvider = Provider<Map<String, dynamic>?>((ref) {
  return ref.watch(userProvider.select((state) => state.settings));
});

final userLoadingProvider = Provider<bool>((ref) {
  return ref.watch(userProvider.select((state) => state.isLoading));
});

final userErrorMessageProvider = Provider<String?>((ref) {
  return ref.watch(userProvider.select((state) => state.errorMessage));
});
