
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:immuno_warriors/core/constants/app_strings.dart';
import 'package:immuno_warriors/core/services/auth_service.dart';
import 'package:immuno_warriors/core/services/local_storage_service.dart';
import 'package:immuno_warriors/data/datasources/local/user_local_datasource.dart';
import 'package:immuno_warriors/data/datasources/remote/user_remote_datasource.dart';
import 'package:immuno_warriors/data/repositories/user_repository_impl.dart';
import 'package:immuno_warriors/domain/entities/user_entity.dart';
import 'package:immuno_warriors/domain/repositories/user_repository.dart';
import 'package:immuno_warriors/domain/usecases/clear_user_cache_usecase.dart';
import 'package:immuno_warriors/domain/usecases/clear_user_session_usecase.dart';
import 'package:immuno_warriors/domain/usecases/get_cached_session_usecase.dart';
import 'package:immuno_warriors/domain/usecases/get_current_user_usecase.dart';
import 'package:immuno_warriors/domain/usecases/get_user_achievements_usecase.dart';
import 'package:immuno_warriors/domain/usecases/get_user_inventory_usecase.dart';
import 'package:immuno_warriors/domain/usecases/get_user_progression_usecase.dart';
import 'package:immuno_warriors/domain/usecases/get_user_resources_usecase.dart';
import 'package:immuno_warriors/domain/usecases/get_user_settings_usecase.dart';
import 'package:immuno_warriors/domain/usecases/get_user_usecase.dart';
import 'package:immuno_warriors/domain/usecases/get_users_usecase.dart';
import 'package:immuno_warriors/domain/usecases/sign_in_usecase.dart';
import 'package:immuno_warriors/domain/usecases/sign_up_usecase.dart';
import 'package:immuno_warriors/domain/usecases/sign_out_usecase.dart';
import 'package:immuno_warriors/domain/usecases/update_user_achievements_usecase.dart';
import 'package:immuno_warriors/domain/usecases/update_user_inventory_usecase.dart';
import 'package:immuno_warriors/domain/usecases/update_user_progression_usecase.dart';
import 'package:immuno_warriors/domain/usecases/update_user_resources_usecase.dart';
import 'package:immuno_warriors/domain/usecases/update_user_settings_usecase.dart';
import 'package:immuno_warriors/domain/usecases/check_session_validity_usecase.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart'; // Import AppLogger
import 'package:immuno_warriors/core/network/network_info.dart'; // Import NetworkInfo


import '../../../../core/routes/route_names.dart';
import '../../../../domain/usecases/authentificate_user_usecase.dart'; // Nouveau use case

// 1. Services Providers
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Ajout du NetworkInfoProvider
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  Connectivity connectivity = new Connectivity();
  return NetworkInfo(connectivity);
});


// 2. Data Sources Providers
final userLocalDataSourceProvider = Provider<UserLocalDataSource>((ref) {
  final localStorageService = ref.read(localStorageServiceProvider);
  final authService = ref.read(authServiceProvider);
  return UserLocalDataSource(localStorageService, authService);
});

final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>((ref) {
  return UserRemoteDataSource();
});

// 3. Repository Provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final remoteDataSource = ref.read(userRemoteDataSourceProvider);
  final localDataSource = ref.read(userLocalDataSourceProvider);
  final authService = ref.read(authServiceProvider);
  return UserRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    authService: authService,
  );
});

// 4. Use Cases Providers - Organisés par catégorie

// Authentication Use Cases
final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  final authService = ref.read(authServiceProvider);
  final userRepository = ref.read(userRepositoryProvider);
  return SignInUseCase(authService, userRepository);
});

final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  final authService = ref.read(authServiceProvider);
  final userRepository = ref.read(userRepositoryProvider);
  final networkInfo = ref.read(networkInfoProvider); // Injecte NetworkInfo
  return SignUpUseCase(authService, userRepository, networkInfo); // Passe NetworkInfo au constructeur
});

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  final authService = ref.read(authServiceProvider);
  return SignOutUseCase(authService);
});

// User Data Use Cases
final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return GetCurrentUserUseCase(userRepository);
});

final getUserUseCaseProvider = Provider<GetUserUseCase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return GetUserUseCase(userRepository);
});

final getUsersUseCaseProvider = Provider<GetUsersUseCase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return GetUsersUseCase(userRepository);
});



// Session Management Use Cases
final checkSessionValidityUseCaseProvider = Provider<CheckSessionValidityUseCase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return CheckSessionValidityUseCase(userRepository);
});

final getCachedSessionUseCaseProvider = Provider<GetCachedSessionUseCase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return GetCachedSessionUseCase(userRepository);
});

final clearUserSessionUseCaseProvider = Provider<ClearUserSessionUseCase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return ClearUserSessionUseCase(userRepository);
});

final clearUserCacheUseCaseProvider = Provider<ClearUserCacheUseCase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return ClearUserCacheUseCase(userRepository);
});

// User Features Use Cases
final getUserResourcesUseCaseProvider = Provider<GetUserResourcesUseCase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return GetUserResourcesUseCase(userRepository);
});

final updateUserResourcesUseCaseProvider = Provider<UpdateUserResourcesUseCase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return UpdateUserResourcesUseCase(userRepository);
});

final getUserInventoryUseCaseProvider = Provider<GetUserInventoryUseCase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return GetUserInventoryUseCase(userRepository);
});

final updateUserInventoryUseCaseProvider = Provider<UpdateUserInventoryUseCase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  final authService = ref.read(authServiceProvider);
  return UpdateUserInventoryUseCase(userRepository, authService);
});

final getUserSettingsUseCaseProvider = Provider<GetUserSettingsUseCase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return GetUserSettingsUseCase(userRepository);
});

final updateUserSettingsUseCaseProvider = Provider<UpdateUserSettingsUseCase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return UpdateUserSettingsUseCase(userRepository);
});

final getUserProgressionUseCaseProvider = Provider<GetUserProgressionUseCase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return GetUserProgressionUseCase(userRepository);
});

final updateUserProgressionUseCaseProvider = Provider<UpdateUserProgressionUseCase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return UpdateUserProgressionUseCase(userRepository);
});

final getUserAchievementsUseCaseProvider = Provider<GetUserAchievementsUseCase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return GetUserAchievementsUseCase(userRepository);
});

final updateUserAchievementsUseCaseProvider = Provider<UpdateUserAchievementsUseCase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return UpdateUserAchievementsUseCase(userRepository);
});

final authenticateUserUsecaseProvider = Provider<AuthenticateUserUsecase>((ref) {
  return AuthenticateUserUsecase(ref.read(userRepositoryProvider));
});

// 5. Auth State Management - Enhanced with session management
class AuthState {
  final UserEntity? user;
  final bool isLoading;
  final String? errorMessage;
  final DateTime? sessionExpiry;

  AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.sessionExpiry,
  });

  bool get isSignedIn => user != null;
  bool get isSessionValid => sessionExpiry != null && sessionExpiry!.isAfter(DateTime.now());
  UserEntity? get currentUser => isSessionValid ? user : null;

  AuthState copyWith({
    UserEntity? user,
    bool? isLoading,
    String? errorMessage,
    DateTime? sessionExpiry,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      sessionExpiry: sessionExpiry ?? this.sessionExpiry,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final CheckSessionValidityUseCase _checkSessionValidityUseCase;
  final ClearUserSessionUseCase _clearUserSessionUseCase;
  final UserRepository _userRepository;

  AuthNotifier(
      this._signInUseCase,
      this._signUpUseCase,
      this._signOutUseCase,
      this._getCurrentUserUseCase,
      this._checkSessionValidityUseCase,
      this._clearUserSessionUseCase,
      this._userRepository
      ) : super(AuthState()) {
    // Vérifier la session au démarrage
    _checkInitialSession();
  }

  Future<void> _checkInitialSession() async {
    state = state.copyWith(isLoading: true);
    try {
      // Tente de récupérer l'utilisateur actuel via le repository (qui gère local/remote)
      final currentUser = await _getCurrentUserUseCase.execute();
      if (currentUser != null) {
        // Si un utilisateur est trouvé, vérifie la validité de sa session
        final sessionValid = await _checkSessionValidityUseCase.execute(currentUser.id);
        if (sessionValid) {
          state = state.copyWith(
            user: currentUser,
            isLoading: false,
            sessionExpiry: DateTime.now().add(const Duration(days: 7)), // Supposons une validité de 7 jours pour la session
            errorMessage: null,
          );
          AppLogger.info('Initial session check: User ${currentUser.email} session is valid.');
        } else {
          // Session non valide, efface la session locale et l'état
          await _clearSession(currentUser.id);
          AppLogger.info('Initial session check: User ${currentUser.email} session expired or invalid. Cleared session.');
        }
      } else {
        state = state.copyWith(isLoading: false, errorMessage: null); // Aucun utilisateur trouvé, pas d'erreur
        AppLogger.info('Initial session check: No current user found.');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error during initial session check', error: e, stackTrace: stackTrace);
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      // En cas d'erreur grave, assurez-vous que l'état est propre.
      if (state.user != null) {
        await _clearSession(state.user!.id);
      }
    }
  }

  Future<bool> authenticateUser(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final isValid = await _userRepository.authenticateUser(email, password);

      if (isValid) {
        // Après authentification réussie, récupérer l'utilisateur complet
        final user = await _getCurrentUserUseCase.execute(); // Cela devrait récupérer l'utilisateur authentifié
        if (user != null) {
          state = state.copyWith(
            user: user,
            isLoading: false,
            sessionExpiry: DateTime.now().add(const Duration(days: 7)),
            errorMessage: null,
          );
          AppLogger.info('User ${email} authenticated successfully.');
          return true;
        } else {
          // Si l'authentification Firebase réussit mais qu'on ne peut pas récupérer l'UserEntity
          state = state.copyWith(
            isLoading: false,
            errorMessage: AppStrings.profileNotFound,
          );
          AppLogger.warning('Authentication successful for $email, but UserEntity could not be retrieved.');
          return false;
        }
      }

      state = state.copyWith(
        isLoading: false,
        errorMessage: AppStrings.invalidPassword, // Ou un message plus spécifique si l'API le permet
      );
      AppLogger.warning('Authentication failed for $email: Invalid credentials.');
      return false;
    } catch (e, stackTrace) {
      AppLogger.error('Error during authentication for $email', error: e, stackTrace: stackTrace);
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }


  Future<void> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _signInUseCase.execute(email: email, password: password);
      if (user != null) {
        state = state.copyWith(
          user: user,
          isLoading: false,
          sessionExpiry: DateTime.now().add(const Duration(days: 7)), // 7 jours de session
          errorMessage: null,
        );
        AppLogger.info('User ${email} signed in successfully.');
      } else {
        state = state.copyWith(isLoading: false, errorMessage: AppStrings.loginFailed);
        AppLogger.warning('Sign in failed for $email: User object is null.');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error during sign in for $email', error: e, stackTrace: stackTrace);
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  // Mise à jour de la signature pour inclure username et avatarUrl
  Future<void> signUp({
    required String email,
    required String password,
    String? username, // Nouveau paramètre
    String? avatarUrl, // Nouveau paramètre
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      // Passe les nouveaux paramètres au use case
      final user = await _signUpUseCase.execute(
        email: email,
        password: password,
        username: username, // Transmet le nom d'utilisateur
        avatarUrl: avatarUrl, // Transmet l'URL de l'avatar
      );
      if (user != null) {
        state = state.copyWith(
          user: user,
          isLoading: false,
          sessionExpiry: DateTime.now().add(const Duration(days: 7)), // 7 jours de session
          errorMessage: null,
        );
        AppLogger.info('User ${email} signed up successfully.');
        // La navigation vers la page d'accueil (sélection de profil) ou le tableau de bord
        // doit être gérée par le widget (RegisterScreen) qui observe cet état.
      } else {
        state = state.copyWith(isLoading: false, errorMessage: AppStrings.registerFailed);
        AppLogger.warning('Sign up failed for $email: User object is null.');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error during sign up for $email', error: e, stackTrace: stackTrace);
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      // Assurez-vous que l'ID utilisateur est disponible pour clearSession
      final currentUserId = state.user?.id;
      await _signOutUseCase.execute();
      if (currentUserId != null) {
        await _clearSession(currentUserId);
      } else {
        // Si pas d'ID, réinitialise l'état de toute façon.
        state = AuthState(user: null, sessionExpiry: null, isLoading: false, errorMessage: null);
      }
      AppLogger.info('User signed out successfully.');
    } catch (e, stackTrace) {
      AppLogger.error('Error during sign out', error: e, stackTrace: stackTrace);
      state = state.copyWith(isLoading: false, errorMessage: AppStrings.signOutFailed);
    }
  }

  // Cette méthode est maintenant appelée par _checkInitialSession et authenticateUser
  // et ne doit plus être appelée directement par les widgets pour récupérer l'utilisateur.
  // Elle est principalement pour la logique interne du Notifier.
  Future<void> _fetchCurrentUser() async {
    try {
      final user = await _getCurrentUserUseCase.execute();
      if (user != null) {
        state = state.copyWith(
          user: user,
          isLoading: false,
          errorMessage: null,
          sessionExpiry: DateTime.now().add(const Duration(days: 7)),
        );
        AppLogger.info('Fetched current user: ${user.email}');
      } else {
        // Si aucun utilisateur n'est trouvé, assurez-vous que l'état est déconnecté.
        // Ne pas appeler _clearSession ici car il n'y a pas d'ID utilisateur à passer.
        state = AuthState(user: null, sessionExpiry: null, isLoading: false, errorMessage: null);
        AppLogger.warning('No current user found during _fetchCurrentUser.');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching current user in AuthNotifier', error: e, stackTrace: stackTrace);
      // En cas d'erreur lors du fetch, l'état doit être réinitialisé.
      state = AuthState(user: null, sessionExpiry: null, isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> _clearSession(String userId) async {
    await _clearUserSessionUseCase.execute(userId);
    // Assurez-vous que l'état est complètement réinitialisé après avoir effacé la session.
    state = AuthState(user: null, sessionExpiry: null, isLoading: false, errorMessage: null);
    AppLogger.info('Local session cleared for user ID: $userId.');
  }

  Future<bool> checkSessionValidity() async {
    // Si l'utilisateur n'est pas signé ou si la session locale a expiré,
    // tente de vérifier la validité via le repository (qui peut impliquer le backend).
    if (!state.isSignedIn || !state.isSessionValid) {
      final currentUserId = state.user?.id;
      if (currentUserId != null) {
        final isValid = await _checkSessionValidityUseCase.execute(currentUserId);
        if (isValid && !state.isSignedIn) {
          // Si la session est valide mais que l'état local ne reflète pas la connexion,
          // tente de récupérer l'utilisateur pour mettre à jour l'état.
          await _fetchCurrentUser();
        }
        return isValid;
      }
      return false; // Pas d'ID utilisateur pour vérifier la session
    }
    return true; // Session locale est valide
  }
}

// 6. Main Auth Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.read(signInUseCaseProvider),
    ref.read(signUpUseCaseProvider),
    ref.read(signOutUseCaseProvider),
    ref.read(getCurrentUserUseCaseProvider),
    ref.read(checkSessionValidityUseCaseProvider),
    ref.read(clearUserSessionUseCaseProvider),
    ref.read(userRepositoryProvider),
  );
});

// 7. Derived Providers - Enhanced with more utility providers
final isSignedInProvider = Provider<bool>((ref) {
  return ref.watch(authProvider.select((state) => state.isSignedIn));
});

final isSessionValidProvider = Provider<bool>((ref) {
  return ref.watch(authProvider.select((state) => state.isSessionValid));
});

final currentUserProvider = Provider<UserEntity?>((ref) {
  return ref.watch(authProvider.select((state) => state.currentUser));
});

final authLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider.select((state) => state.isLoading));
});

final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authProvider.select((state) => state.errorMessage));
});

// User Data Providers
final userListProvider = FutureProvider<List<UserEntity>>((ref) async {
  // Dépend de l'état d'authentification pour éviter de charger si non nécessaire
  final authState = ref.watch(authProvider);
  if (!authState.isSignedIn) {
    AppLogger.info('userListProvider: User not signed in, returning empty list.');
    return [];
  }
  try {
    return ref.read(getUsersUseCaseProvider).execute();
  } catch (e, stackTrace) {
    AppLogger.error('Error fetching user list in provider', error: e, stackTrace: stackTrace);
    // Vous pouvez choisir de relancer l'erreur ou de retourner une liste vide/un état d'erreur.
    // Pour l'affichage sur HomeScreen, retourner une liste vide peut être plus gracieux.
    return [];
  }
});

final currentUserDataProvider = FutureProvider<UserEntity?>((ref) async {
  final authState = ref.watch(authProvider);
  // Si l'utilisateur est déjà dans l'état du AuthNotifier et la session est valide,
  // utilisez cette instance pour éviter un re-fetch inutile.
  if (authState.isSignedIn && authState.isSessionValid && authState.user != null) {
    return authState.user;
  }
  // Sinon, tentez de récupérer l'utilisateur via le use case.
  // Cela sera utile si l'app vient de démarrer et que _checkInitialSession a trouvé un utilisateur valide.
  return ref.read(getCurrentUserUseCaseProvider).execute();
});


// User Features Providers
final userResourcesProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final userId = ref.watch(authProvider.select((state) => state.user?.id));
  if (userId != null) {
    return ref.read(getUserResourcesUseCaseProvider).execute();
  }
  return {};
});

final userInventoryProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final userId = ref.watch(authProvider.select((state) => state.user?.id));
  if (userId != null) {
    return ref.read(getUserInventoryUseCaseProvider).execute();
  }
  return [];
});

final userSettingsProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final userId = ref.watch(authProvider.select((state) => state.user?.id));
  if (userId != null) {
    return ref.read(getUserSettingsUseCaseProvider).execute();
  }
  return {};
});

final userProgressionProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final userId = ref.watch(authProvider.select((state) => state.user?.id));
  if (userId != null) {
    return ref.read(getUserProgressionUseCaseProvider).execute();
  }
  return {};
});

final userAchievementsProvider = FutureProvider.autoDispose<Map<String, bool>>((ref) async {
  final userId = ref.watch(authProvider.select((state) => state.user?.id));
  if (userId != null) {
    return ref.read(getUserAchievementsUseCaseProvider).execute();
  }
  return {};
});

// Session Providers
final cachedSessionProvider = FutureProvider.autoDispose<String?>((ref) async {
  final userId = ref.watch(authProvider.select((state) => state.user?.id));
  if (userId != null) {
    return ref.read(getCachedSessionUseCaseProvider).execute(userId);
  }
  return null;
});



// Utility function to check session before navigation
Future<bool> checkAuthAndNavigate(WidgetRef ref, BuildContext context, String routeName, {Object? extra}) async {
  final isValid = await ref.read(authProvider.notifier).checkSessionValidity();
  if (isValid) {
    if (extra != null) {
      context.goNamed(routeName, extra: extra);
    } else {
      context.goNamed(routeName);
    }
    return true;
  } else {
    context.goNamed(RouteNames.profileAuth);
    return false;
  }
}
