import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:immuno_warriors/core/exceptions/app_exception.dart';
import 'package:immuno_warriors/core/exceptions/network_exceptions.dart';
import 'package:immuno_warriors/core/network/dio_client.dart';
import 'package:immuno_warriors/core/services/auth_service.dart';
import 'package:immuno_warriors/core/services/local_storage_service.dart';
import 'package:immuno_warriors/core/services/network_service.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/core/constants/app_strings.dart';
import 'package:immuno_warriors/core/network/network_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:immuno_warriors/domain/entities/user_entity.dart';
import 'dart:convert';

import 'package:immuno_warriors/features/auth/providers/user_provider.dart';

// État de l'authentification
class AuthState {
  final String? userId;
  final String? email;
  final String? username;
  final String? avatarUrl;
  final bool isLoading;
  final String? errorMessage;
  final DateTime? sessionExpiry;

  AuthState({
    this.userId,
    this.email,
    this.username,
    this.avatarUrl,
    this.isLoading = false,
    this.errorMessage,
    this.sessionExpiry,
  });

  bool get isAuthenticated => userId != null && isSessionValid;
  bool get isSignedIn => isAuthenticated; // Alias for RegisterScreen
  bool get isSessionValid =>
      sessionExpiry != null && sessionExpiry!.isAfter(DateTime.now());

  AuthState copyWith({
    String? userId,
    String? email,
    String? username,
    String? avatarUrl,
    bool? isLoading,
    String? errorMessage,
    DateTime? sessionExpiry,
  }) {
    return AuthState(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      sessionExpiry: sessionExpiry ?? this.sessionExpiry,
    );
  }
}

// Notifier pour gérer l'état d'authentification
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final NetworkService _networkService;

  AuthNotifier(this._authService, this._networkService) : super(AuthState()) {
    _initialize();
  }

  /// Initialiser l'état d'authentification
  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _updateBaseUrl();

      if (!await _networkService.isConnected) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: AppStrings.noInternetConnection,
        );
        AppLogger.warning('No internet connection during initialization');
        return;
      }

      if (!await _networkService.isServerReachable()) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: AppStrings.networkError,
        );
        AppLogger.warning('Server not reachable during initialization');
        return;
      }

      final isAuthenticated = await _authService.verifyToken();
      if (isAuthenticated) {
        final user = FirebaseAuth.instance.currentUser;
        state = state.copyWith(
          userId: user?.uid,
          email: user?.email,
          username: user?.displayName,
          avatarUrl: user?.photoURL, // Fetch from Firebase or backend
          isLoading: false,
          sessionExpiry: DateTime.now().add(const Duration(days: 7)),
          errorMessage: null,
        );
        AppLogger.info('Initial session valid for user: ${user?.email}');
      } else {
        state = state.copyWith(
          userId: null,
          email: null,
          username: null,
          avatarUrl: null,
          isLoading: false,
          sessionExpiry: null,
          errorMessage: null,
        );
        AppLogger.info('No valid session found during initialization');
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e is ApiException ? e.message : AppStrings.errorMessage,
      );
      AppLogger.error('Error during initialization: $e');
    }
  }

  // Mettre à jour l'URL de base avec ngrok
  Future<void> _updateBaseUrl() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/ngrok-url'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final ngrokUrl = data['ngrokUrl'] as String?;
        if (ngrokUrl != null) {
          _networkService.setBaseUrl(ngrokUrl);
          AppLogger.info('ngrok URL updated: $ngrokUrl');
        }
      }
    } catch (e) {
      AppLogger.error('Failed to retrieve ngrok URL: $e');
    }
  }

  // Connexion
  Future<void> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      if (!await _networkService.isConnected) {
        throw NoInternetException();
      }
      if (!await _networkService.isServerReachable()) {
        throw ServerUnreachableException();
      }
      await _authService.signin(email, password);
      final user = FirebaseAuth.instance.currentUser;
      state = state.copyWith(
        userId: user?.uid,
        email: user?.email,
        username: user?.displayName,
        avatarUrl: user?.photoURL,
        isLoading: false,
        sessionExpiry: DateTime.now().add(const Duration(days: 7)),
        errorMessage: null,
      );
      AppLogger.info('User signed in successfully: ${user?.email}');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e is ApiException ? e.message : AppStrings.loginFailed,
      );
      AppLogger.error('Sign in error: $e');
    }
  }

  // Inscription
  Future<void> signUp({
    required String email,
    required String password,
    required String username,
    String? avatarUrl,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      if (!await _networkService.isConnected) {
        throw NoInternetException();
      }
      if (!await _networkService.isServerReachable()) {
        throw ServerUnreachableException();
      }
      await _authService.signup(email, password, username);
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && avatarUrl != null) {
        await user.updatePhotoURL(avatarUrl); // Update Firebase user profile
      }
      state = state.copyWith(
        userId: user?.uid,
        email: user?.email,
        username: user?.displayName ?? username,
        avatarUrl: avatarUrl ?? user?.photoURL,
        isLoading: false,
        sessionExpiry: DateTime.now().add(const Duration(days: 7)),
        errorMessage: null,
      );
      AppLogger.info('User signed up successfully: ${user?.email}');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e is ApiException ? e.message : AppStrings.registerFailed,
      );
      AppLogger.error('Sign up error: $e');
    }
  }

  // Réinitialiser le mot de passe
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      if (!await _networkService.isConnected) {
        throw NoInternetException();
      }
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      AppLogger.info('Password reset email sent to $email');
    } catch (e) {
      state = state.copyWith(
        errorMessage:
            e is ApiException ? e.message : AppStrings.passwordResetFailed,
      );
      AppLogger.error('Password reset error: $e');
      rethrow;
    }
  }

  // Rafraîchir le token
  Future<void> refreshToken() async {
    try {
      if (!await _networkService.isConnected) {
        throw NoInternetException();
      }
      if (!await _networkService.isServerReachable()) {
        throw ServerUnreachableException();
      }
      await _authService.refreshToken();
      final user = FirebaseAuth.instance.currentUser;
      state = state.copyWith(
        userId: user?.uid,
        email: user?.email,
        username: user?.displayName,
        avatarUrl: user?.photoURL,
        sessionExpiry: DateTime.now().add(const Duration(days: 7)),
        errorMessage: null,
      );
      AppLogger.info('Token refreshed successfully for user: ${user?.email}');
    } catch (e) {
      state = state.copyWith(
        errorMessage: e is ApiException ? e.message : AppStrings.errorMessage,
      );
      AppLogger.error('Token refresh error: $e');
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _authService.signout();
      state = AuthState(
        userId: null,
        email: null,
        username: null,
        avatarUrl: null,
        isLoading: false,
        sessionExpiry: null,
        errorMessage: null,
      );
      AppLogger.info('User signed out successfully');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e is ApiException ? e.message : AppStrings.signOutFailed,
      );
      AppLogger.error('Sign out error: $e');
    }
  }

  // Vérifier la validité de la session
  Future<bool> checkSessionValidity() async {
    if (state.isAuthenticated && state.isSessionValid) {
      return true;
    }
    try {
      if (!await _networkService.isConnected) {
        state = state.copyWith(errorMessage: AppStrings.noInternetConnection);
        return false;
      }
      if (!await _networkService.isServerReachable()) {
        state = state.copyWith(errorMessage: AppStrings.networkError);
        return false;
      }
      final isValid = await _authService.verifyToken();
      if (isValid) {
        final user = FirebaseAuth.instance.currentUser;
        state = state.copyWith(
          userId: user?.uid,
          email: user?.email,
          username: user?.displayName,
          avatarUrl: user?.photoURL,
          sessionExpiry: DateTime.now().add(const Duration(days: 7)),
          errorMessage: null,
        );
        AppLogger.info('Session validated for user: ${user?.email}');
        return true;
      } else {
        state = AuthState(
          userId: null,
          email: null,
          username: null,
          avatarUrl: null,
          isLoading: false,
          sessionExpiry: null,
          errorMessage: null,
        );
        AppLogger.info('Session invalid, cleared state');
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        errorMessage: e is ApiException ? e.message : AppStrings.errorMessage,
      );
      AppLogger.error('Session validation error: $e');
      return false;
    }
  }

  Future<bool> authenticateUser(String userId, String password) async {
    try {
      if (!await _networkService.isConnected) throw NoInternetException();
      if (!await _networkService.isServerReachable()) {
        throw ServerUnreachableException();
      }
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser?.uid != userId) {
        throw ApiException('Utilisateur non correspondant.');
      }
      await _authService.signin(currentUser!.email!, password);
      state = state.copyWith(
        userId: currentUser.uid,
        email: currentUser.email,
        username: currentUser.displayName,
        avatarUrl: currentUser.photoURL,
        sessionExpiry: DateTime.now().add(const Duration(days: 7)),
        errorMessage: null,
      );
      AppLogger.info('Utilisateur $userId authentifié avec succès.');
      return true;
    } catch (e) {
      state = state.copyWith(
        errorMessage: e is ApiException ? e.message : AppStrings.loginFailed,
      );
      AppLogger.error('Erreur d\'authentification pour $userId: $e');
      return false;
    }
  }

  // Réinitialiser les erreurs
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

// Providers pour les services
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfo(Connectivity());
});

final networkServiceProvider = Provider<NetworkService>((ref) {
  return NetworkService();
});

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(ref.read(networkServiceProvider));
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    ref.read(dioClientProvider),
    ref.read(localStorageServiceProvider),
    ref.read(networkServiceProvider),
  );
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.read(authServiceProvider),
    ref.read(networkServiceProvider),
  );
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider.select((state) => state.isAuthenticated));
});

final authLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider.select((state) => state.isLoading));
});

final errorMessageProvider = Provider<String?>((ref) {
  return ref.watch(authProvider.select((state) => state.errorMessage));
});

final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(authProvider.select((state) => state.userId));
});

final currentUsernameProvider = Provider<String?>((ref) {
  return ref.watch(authProvider.select((state) => state.username));
});

final currentEmailProvider = Provider<String?>((ref) {
  return ref.watch(authProvider.select((state) => state.email));
});

final currentUserDataProvider = FutureProvider<UserEntity?>((ref) async {
  final userService = ref.read(userServiceProvider);
  final userId = ref.read(currentUserIdProvider);
  if (userId == null) return null;
  final result = await userService.getUserProfile();
  return result.fold((error) {
    AppLogger.error(
      'Erreur lors du chargement du profil utilisateur: ${error.message}',
    );
    return null;
  }, (user) => user);
});
