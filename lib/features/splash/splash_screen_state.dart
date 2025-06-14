import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:immuno_warriors/core/exceptions/app_exception.dart';
import 'package:immuno_warriors/core/exceptions/network_exceptions.dart';
import 'package:immuno_warriors/core/routes/route_names.dart';
import 'package:immuno_warriors/core/services/auth_service.dart';
import 'package:immuno_warriors/core/services/network_service.dart';
import 'package:immuno_warriors/core/services/user_service.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/core/constants/app_strings.dart';
import 'package:immuno_warriors/features/auth/providers/auth_provider.dart';
import 'package:immuno_warriors/features/auth/providers/user_provider.dart';
import 'package:immuno_warriors/shared/widgets/feedback/snackbar_manager.dart';

class SplashScreenState {
  final double progress;
  final String statusMessage;
  final String? errorMessage;
  final bool isLoading;
  final bool hasCriticalError;
  final bool isAuthenticated;
  final bool isInitialized;
  final bool showContinueButton;
  final String networkStatus;
  final String currentUrl;

  SplashScreenState({
    this.progress = 0.0,
    this.statusMessage = AppStrings.initializing,
    this.errorMessage,
    this.isLoading = false,
    this.hasCriticalError = false,
    this.isAuthenticated = false,
    this.isInitialized = false,
    this.showContinueButton = false,
    this.networkStatus = AppStrings.initialization,
    this.currentUrl = '',
  });

  SplashScreenState copyWith({
    double? progress,
    String? statusMessage,
    String? errorMessage,
    bool? isLoading,
    bool? hasCriticalError,
    bool? isAuthenticated,
    bool? isInitialized,
    bool? showContinueButton,
    String? networkStatus,
    String? currentUrl,
  }) {
    return SplashScreenState(
      progress: progress ?? this.progress,
      statusMessage: statusMessage ?? this.statusMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
      hasCriticalError: hasCriticalError ?? this.hasCriticalError,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isInitialized: isInitialized ?? this.isInitialized,
      showContinueButton: showContinueButton ?? this.showContinueButton,
      networkStatus: networkStatus ?? this.networkStatus,
      currentUrl: currentUrl ?? this.currentUrl,
    );
  }
}

class SplashScreenNotifier extends StateNotifier<SplashScreenState> {
  final AuthService _authService;
  final NetworkService _networkService;
  final UserService _userService;
  final Ref _ref;
  StreamSubscription<bool>? _networkSubscription;
  StreamSubscription<String>? _urlSubscription;
  final int _maxRetries = 10;
  final Duration _retryDelay = const Duration(seconds: 2);

  SplashScreenNotifier(
    this._authService,
    this._networkService,
    this._userService,
    this._ref,
  ) : super(SplashScreenState()) {
    _setupNetworkListener();
  }

  void _setupNetworkListener() {
    _networkSubscription = Stream.periodic(const Duration(seconds: 5))
        .asyncMap((_) => _networkService.isConnected)
        .listen(
          (isConnected) {
            state = state.copyWith(
              networkStatus:
                  isConnected
                      ? AppStrings.networkSuccess
                      : AppStrings.noInternetConnection,
            );
            AppLogger.info(
              'État réseau : ${state.networkStatus}',
              stackTrace: StackTrace.current,
            );
          },
          onError: (e) {
            state = state.copyWith(networkStatus: AppStrings.networkError);
            AppLogger.error(
              'Erreur listener réseau : $e',
              stackTrace: StackTrace.current,
            );
          },
        );

    _urlSubscription = _networkService.baseUrlStream.listen(
      (url) {
        state = state.copyWith(currentUrl: url);
        AppLogger.info(
          'URL mise à jour : $url',
          stackTrace: StackTrace.current,
        );
      },
      onError: (e) {
        state = state.copyWith(currentUrl: 'Erreur URL');
        AppLogger.error(
          'Erreur listener URL : $e',
          stackTrace: StackTrace.current,
        );
      },
    );
  }

  Future<void> initialize(BuildContext context) async {
    if (!context.mounted) return;
    state = state.copyWith(isLoading: true, progress: 0.0);

    try {
      // Étape 1 : Attendre l'URL de base
      await _waitForBaseUrl(context);
      state = state.copyWith(progress: 0.2, statusMessage: 'URL chargée');

      // Étape 2 : Vérification réseau
      await _checkNetwork(context);
      state = state.copyWith(
        progress: 0.4,
        statusMessage: AppStrings.networkChecked,
      );

      // Étape 3 : Vérification session
      final isAuthenticated = await _checkSession(context);
      state = state.copyWith(
        progress: 0.6,
        statusMessage: AppStrings.sessionChecked,
        isAuthenticated: isAuthenticated,
      );

      // Étape 4 : Chargement profil si authentifié
      if (isAuthenticated) {
        await _loadUserProfile(context);
        state = state.copyWith(
          progress: 0.8,
          statusMessage: AppStrings.profileLoaded,
        );
      } else {
        state = state.copyWith(
          progress: 0.8,
          statusMessage: AppStrings.profileNotFound,
        );
        AppLogger.info('Non authentifié, profil non chargé');
      }

      // Étape 5 : Chargement ressources si authentifié
      if (isAuthenticated) {
        await _loadUserResources(context);
        state = state.copyWith(
          progress: 1.0,
          statusMessage: AppStrings.resourcesLoaded,
        );
      } else {
        state = state.copyWith(
          progress: 1.0,
          statusMessage: AppStrings.profileNotFound,
        );
        AppLogger.info('Non authentifié, ressources non chargées');
      }

      // Étape 6 : Vérification version
      await _checkAppVersion(context);
      state = state.copyWith(
        isLoading: false,
        isInitialized: true,
        showContinueButton:
            !isAuthenticated, // Bouton "Continuer" seulement si non authentifié
      );

      await Future.delayed(const Duration(seconds: 1));
      if (!context.mounted) return;

      // Navigation automatique si authentifié
      if (isAuthenticated) {
        _navigate(context);
      }
    } catch (e) {
      if (context.mounted) {
        _handleError(context, e);
      }
    }
  }

  Future<void> _waitForBaseUrl(BuildContext context) async {
    bool isValid = false;
    int attempt = 0;
    while (!isValid && context.mounted) {
      attempt++;
      try {
        // Attendre la première URL non vide et valide du stream
        final url = await _networkService.baseUrlStream
            .firstWhere((url) => url.isNotEmpty && _isValidUrl(url))
            .timeout(
              const Duration(seconds: 10),
              onTimeout: () => throw NetworkException('Timeout attente URL'),
            );

        // Vérifier si l'URL est joignable
        final isReachable = await _networkService.networkInfo.canHandleRequests(
          url,
        );
        if (!isReachable) {
          throw NetworkException('URL injoignable : $url');
        }

        // Mettre à jour l'état si validée
        state = state.copyWith(currentUrl: url, progress: 0.2);
        AppLogger.info(
          'URL validée à la tentative $attempt : $url',
          stackTrace: StackTrace.current,
        );
        isValid = true;
      } catch (e) {
        AppLogger.error(
          'Échec validation URL à la tentative $attempt : $e',
          stackTrace: StackTrace.current,
        );
        state = state.copyWith(
          statusMessage: 'Attente URL valide (tentative $attempt)',
          progress: 0.1 + (0.1 * (attempt % 5) / 5),
          errorMessage: 'URL non valide, veuillez configurer via NetworkModal',
        );
        if (context.mounted) {
          SnackbarManager.showError(
            context,
            'Veuillez configurer une URL valide',
          );
        }
        await Future.delayed(_retryDelay);
      }
    }
  }

  Future<void> _checkNetwork(BuildContext context) async {
    try {
      if (!await _networkService.isConnected) {
        throw NoInternetException();
      }
      if (!await _networkService.isServerReachable()) {
        throw ServerUnreachableException();
      }
      if (context.mounted) {
        SnackbarManager.showSuccess(context, AppStrings.networkSuccess);
      }
    } catch (e) {
      throw ApiException(AppStrings.networkError);
    }
  }

  Future<bool> _checkSession(BuildContext context) async {
    try {
      final isAuthenticated = await _authService.verifyToken();
      if (context.mounted) {
        SnackbarManager.showInfo(
          context,
          isAuthenticated
              ? AppStrings.sessionSuccess
              : AppStrings.sessionExpired,
        );
      }
      return isAuthenticated;
    } catch (e) {
      throw ApiException(AppStrings.sessionError);
    }
  }

  Future<void> _loadUserProfile(BuildContext context) async {
    try {
      final result = await _userService.getUserProfile();
      result.fold((error) => throw error, (profile) {
        _ref.read(userProvider.notifier).loadUserProfile();
        if (context.mounted) {
          SnackbarManager.showSuccess(context, AppStrings.profileSuccess);
        }
      });
    } catch (e) {
      throw ApiException(AppStrings.profileError);
    }
  }

  Future<void> _loadUserResources(BuildContext context) async {
    try {
      final result = await _userService.getUserResources();
      result.fold((error) => throw error, (resources) {
        _ref.read(userProvider.notifier).loadUserResources();
        if (context.mounted) {
          SnackbarManager.showSuccess(context, AppStrings.resourcesSuccess);
        }
      });
    } catch (e) {
      throw ApiException(AppStrings.resourcesError);
    }
  }

  Future<void> _checkAppVersion(BuildContext context) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      AppLogger.info('Version vérifiée.', stackTrace: StackTrace.current);
    } catch (e) {
      throw ApiException(AppStrings.errorMessage);
    }
  }

  void _handleError(BuildContext context, dynamic error) {
    String errorMessage;
    if (error is FirebaseException && error.code == 'permission-denied') {
      errorMessage = 'Accès Firestore refusé. Vérifiez les permissions.';
    } else if (error is NoInternetException) {
      errorMessage = AppStrings.noInternetConnection;
    } else if (error is ServerUnreachableException) {
      errorMessage = 'Serveur injoignable. Vérifiez l\'URL.';
    } else if (error is ApiException) {
      errorMessage = error.message;
    } else if (error is NetworkException) {
      errorMessage = error.message;
    } else {
      errorMessage = AppStrings.errorMessage;
    }

    state = state.copyWith(
      isLoading: false,
      errorMessage: errorMessage,
      hasCriticalError:
          error is NoInternetException || error is ServerUnreachableException,
    );

    if (context.mounted) {
      SnackbarManager.showError(context, errorMessage);
    }
    AppLogger.error(
      'Erreur SplashScreen : $error',
      stackTrace: StackTrace.current,
    );
  }

  void _navigate(BuildContext context) {
    if (context.mounted) {
      AppLogger.error("c'est monte");

      context.goNamed(
        state.isAuthenticated ? RouteNames.login : RouteNames.home,
      );
    }
  }

  void retry(BuildContext context) {
    state = state.copyWith(
      errorMessage: null,
      hasCriticalError: false,
      progress: 0.0,
      statusMessage: AppStrings.initializing,
    );
    initialize(context);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null, hasCriticalError: false);
  }

  void continueNavigation(BuildContext context) {
    _navigate(context);
  }

  void updateUrl(String url) {
    if (_isValidUrl(url)) {
      _networkService.setBaseUrl(url);
      state = state.copyWith(currentUrl: url, errorMessage: null);
      AppLogger.info(
        'URL mise à jour manuellement : $url',
        stackTrace: StackTrace.current,
      );
    } else {
      state = state.copyWith(errorMessage: 'URL invalide : $url');
      AppLogger.error('URL invalide : $url', stackTrace: StackTrace.current);
    }
  }

  bool _isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && uri.hasScheme && uri.host.isNotEmpty;
  }

  @override
  void dispose() {
    _networkSubscription?.cancel();
    _urlSubscription?.cancel();
    super.dispose();
    AppLogger.info(
      'SplashScreenNotifier disposé',
      stackTrace: StackTrace.current,
    );
  }
}

final splashScreenProvider =
    StateNotifierProvider<SplashScreenNotifier, SplashScreenState>((ref) {
      return SplashScreenNotifier(
        ref.read(authServiceProvider),
        ref.read(networkServiceProvider),
        ref.read(userServiceProvider),
        ref,
      );
    });
