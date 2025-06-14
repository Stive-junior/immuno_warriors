import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:immuno_warriors/core/exceptions/app_exception.dart';
import 'package:immuno_warriors/core/exceptions/network_exceptions.dart';
import 'package:immuno_warriors/core/network/dio_client.dart';
import 'package:immuno_warriors/core/network/network_info.dart';
import 'package:immuno_warriors/core/services/auth_service.dart';
import 'package:immuno_warriors/core/services/local_storage_service.dart';
import 'package:immuno_warriors/core/services/network_service.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/core/constants/app_strings.dart';
import 'package:immuno_warriors/domain/entities/user_entity.dart';
import 'package:immuno_warriors/features/auth/providers/user_provider.dart';

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
  bool get isSignedIn => isAuthenticated;
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

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final NetworkService _networkService;
  final FirebaseFirestore _firestore;
  StreamSubscription<String>? _baseUrlSubscription;

  AuthNotifier(this._authService, this._networkService, this._firestore)
    : super(AuthState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      _baseUrlSubscription = _networkService.baseUrlStream.listen((baseUrl) {
        AppLogger.info('URL de base mise à jour dans AuthNotifier: $baseUrl');
      });

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
        AppLogger.warning('Serveur injoignable lors de l\'initialisation');
        return;
      }

      final isAuthenticated = await _authService.verifyToken();
      if (isAuthenticated) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final userDoc =
              await _firestore.collection('users').doc(user.uid).get();
          if (userDoc.exists) {
            state = state.copyWith(
              userId: user.uid,
              email: user.email,
              username: userDoc.data()?['username'] as String?,
              avatarUrl: userDoc.data()?['avatarUrl'] as String?,
              isLoading: false,
              sessionExpiry: DateTime.now().add(const Duration(days: 7)),
              errorMessage: null,
            );
            AppLogger.info('Session initiale valide pour: ${user.email}');
          } else {
            AppLogger.warning(
              'Document utilisateur introuvable pour ${user.uid}. Déconnexion.',
            );
            await _authService.signout();
            state = state.copyWith(
              userId: null,
              email: null,
              username: null,
              avatarUrl: null,
              isLoading: false,
              sessionExpiry: null,
              errorMessage: AppStrings.profileNotFound,
            );
          }
        }
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
        AppLogger.info('Aucune session valide trouvée.');
      }
    } catch (e) {
      AppLogger.error('Erreur initialisation: $e', error: e);
      state = state.copyWith(
        isLoading: false,
        errorMessage: e is ApiException ? e.message : AppStrings.errorMessage,
      );
    }
  }

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
      if (user != null) {
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          state = state.copyWith(
            userId: user.uid,
            email: user.email,
            username: userDoc.data()?['username'] as String?,
            avatarUrl: userDoc.data()?['avatarUrl'] as String?,
            isLoading: false,
            sessionExpiry: DateTime.now().add(const Duration(days: 7)),
            errorMessage: null,
          );
          AppLogger.info('Connexion réussie: ${user.email}');
        } else {
          AppLogger.warning(
            'Document utilisateur introuvable pour ${user.uid}. Déconnexion.',
          );
          await _authService.signout();
          throw ApiException('Profil utilisateur introuvable.');
        }
      } else {
        throw ApiException('Utilisateur Firebase null après connexion.');
      }
    } catch (e) {
      AppLogger.error('Erreur connexion: $e', error: e);
      state = state.copyWith(
        isLoading: false,
        errorMessage: e is ApiException ? e.message : AppStrings.loginFailed,
      );
    }
  }

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
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'username': username,
          'avatarUrl': avatarUrl,
          'createdAt': FieldValue.serverTimestamp(),
        });
        state = state.copyWith(
          userId: user.uid,
          email: user.email,
          username: username,
          avatarUrl: avatarUrl,
          isLoading: false,
          sessionExpiry: DateTime.now().add(const Duration(days: 7)),
          errorMessage: null,
        );
        AppLogger.info('Inscription réussie: ${user.email}');
      } else {
        throw ApiException('Utilisateur Firebase null après inscription.');
      }
    } catch (e) {
      AppLogger.error('Erreur inscription: $e', error: e);
      state = state.copyWith(
        isLoading: false,
        errorMessage: e is ApiException ? e.message : AppStrings.registerFailed,
      );
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      if (!await _networkService.isConnected) {
        throw NoInternetException();
      }
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      AppLogger.info('Email de réinitialisation envoyé à $email');
    } catch (e) {
      AppLogger.error('Erreur réinitialisation mot de passe: $e', error: e);
      state = state.copyWith(
        errorMessage:
            e is ApiException ? e.message : AppStrings.passwordResetFailed,
      );
      rethrow;
    }
  }

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
      if (user != null) {
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          state = state.copyWith(
            userId: user.uid,
            email: user.email,
            username: userDoc.data()?['username'] as String?,
            avatarUrl: userDoc.data()?['avatarUrl'] as String?,
            sessionExpiry: DateTime.now().add(const Duration(days: 7)),
            errorMessage: null,
          );
          AppLogger.info('Token rafraîchi pour: ${user.email}');
        } else {
          AppLogger.warning(
            'Document utilisateur introuvable pour ${user.uid}. Déconnexion.',
          );
          await _authService.signout();
          throw ApiException('Profil utilisateur introuvable.');
        }
      } else {
        throw ApiException('Utilisateur Firebase null après rafraîchissement.');
      }
    } catch (e) {
      AppLogger.error('Erreur rafraîchissement token: $e', error: e);
      state = state.copyWith(
        errorMessage: e is ApiException ? e.message : AppStrings.errorMessage,
      );
    }
  }

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
      AppLogger.info('Déconnexion réussie');
    } catch (e) {
      AppLogger.error('Erreur déconnexion: $e', error: e);
      state = state.copyWith(
        isLoading: false,
        errorMessage: e is ApiException ? e.message : AppStrings.signOutFailed,
      );
    }
  }

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
        if (user != null) {
          final userDoc =
              await _firestore.collection('users').doc(user.uid).get();
          if (userDoc.exists) {
            state = state.copyWith(
              userId: user.uid,
              email: user.email,
              username: userDoc.data()?['username'] as String?,
              avatarUrl: userDoc.data()?['avatarUrl'] as String?,
              sessionExpiry: DateTime.now().add(const Duration(days: 7)),
              errorMessage: null,
            );
            AppLogger.info('Session validée pour: ${user.email}');
            return true;
          } else {
            AppLogger.warning(
              'Document utilisateur introuvable pour ${user.uid}. Effacement session.',
            );
            await _authService.signout();
            state = AuthState(
              userId: null,
              email: null,
              username: null,
              avatarUrl: null,
              isLoading: false,
              sessionExpiry: null,
              errorMessage: AppStrings.profileNotFound,
            );
            return false;
          }
        } else {
          AppLogger.info('Utilisateur Firebase null. Effacement session.');
          state = AuthState(
            userId: null,
            email: null,
            username: null,
            avatarUrl: null,
            isLoading: false,
            sessionExpiry: null,
            errorMessage: null,
          );
          return false;
        }
      }
      state = AuthState(
        userId: null,
        email: null,
        username: null,
        avatarUrl: null,
        isLoading: false,
        sessionExpiry: null,
        errorMessage: null,
      );
      AppLogger.info('Session invalide, état effacé');
      return false;
    } catch (e) {
      AppLogger.error('Erreur validation session: $e', error: e);
      state = state.copyWith(
        errorMessage: e is ApiException ? e.message : AppStrings.errorMessage,
      );
      return false;
    }
  }

  Future<bool> authenticateUser(String userId, String password) async {
    try {
      if (!await _networkService.isConnected) {
        throw NoInternetException();
      }
      if (!await _networkService.isServerReachable()) {
        throw ServerUnreachableException();
      }
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser?.uid != userId) {
        throw ApiException('Mauvais ID utilisateur.');
      }
      await _authService.signin(currentUser!.email!, password);
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        state = state.copyWith(
          userId: currentUser.uid,
          email: currentUser.email,
          username: userDoc.data()?['username'] as String?,
          avatarUrl: userDoc.data()?['avatarUrl'] as String?,
          sessionExpiry: DateTime.now().add(const Duration(days: 7)),
          errorMessage: null,
        );
        AppLogger.info('Utilisateur $userId ré-authentifié.');
        return true;
      } else {
        AppLogger.warning(
          'Document utilisateur introuvable pour $userId. Effacement session.',
        );
        await _authService.signout();
        throw ApiException('Profil utilisateur introuvable.');
      }
    } catch (e) {
      AppLogger.error('Erreur authentification $userId: $e', error: e);
      state = state.copyWith(
        errorMessage: e is ApiException ? e.message : AppStrings.loginFailed,
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  @override
  void dispose() {
    _baseUrlSubscription?.cancel();
    AppLogger.info('AuthNotifier disposé');
    super.dispose();
  }
}

// Providers
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfo(Connectivity());
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final networkServiceProvider = Provider<NetworkService>((ref) {
  final service = NetworkService(
    networkInfo: ref.read(networkInfoProvider),
    firestore: ref.read(firestoreProvider),
    ref: ref,
  );
  ref.onDispose(service.dispose);
  return service;
});

final dioClientProvider = Provider<DioClient>((ref) {
  final client = DioClient(
    ref: ref,
    networkService: ref.read(networkServiceProvider),
    firebaseAuth: ref.read(firebaseAuthProvider),
  );
  ref.onDispose(client.dispose);
  return client;
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    ref.read(dioClientProvider),
    ref.read(localStorageServiceProvider),
    ref.read(networkServiceProvider),
  );
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final notifier = AuthNotifier(
    ref.read(authServiceProvider),
    ref.read(networkServiceProvider),
    ref.read(firestoreProvider),
  );
  ref.onDispose(notifier.dispose);
  return notifier;
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

final currentUserDataProvider = FutureProvider.autoDispose<UserEntity?>((
  ref,
) async {
  final userService = ref.read(userServiceProvider);
  final userId = ref.read(currentUserIdProvider);
  if (userId == null) {
    AppLogger.debug('currentUserDataProvider: Aucun userId, retourne null.');
    return null;
  }
  try {
    final result = await userService.getUserProfile();
    return result.fold((error) {
      AppLogger.error(
        'Erreur chargement profil: ${error.message}',
        error: error,
      );
      return null;
    }, (user) => user);
  } catch (e) {
    AppLogger.error('Erreur inattendue chargement profil: $e', error: e);
    return null;
  }
});
