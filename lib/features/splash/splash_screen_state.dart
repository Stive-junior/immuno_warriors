import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:immuno_warriors/core/constants/app_strings.dart';
import 'package:immuno_warriors/core/exceptions/app_exception.dart';
import 'package:immuno_warriors/core/exceptions/network_exceptions.dart';
import 'package:immuno_warriors/core/routes/route_names.dart';
import 'package:immuno_warriors/core/services/network_service.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/shared/widgets/feedback/snackbar_manager.dart';

import '../auth/providers/auth_provider.dart';

class SplashScreenState {
  final double progress;
  final String statusMessage;
  final String? errorMessage;
  final bool isLoading;
  final bool hasCriticalError;
  final bool isInitialized;
  final String networkStatus;
  final String currentUrl;

  SplashScreenState({
    this.progress = 0.0,
    this.statusMessage = AppStrings.initializing,
    this.errorMessage,
    this.isLoading = false,
    this.hasCriticalError = false,
    this.isInitialized = false,
    this.networkStatus = AppStrings.initializing,
    this.currentUrl = '',
  });

  SplashScreenState copyWith({
    double? progress,
    String? statusMessage,
    String? errorMessage,
    bool? isLoading,
    bool? hasCriticalError,
    bool? isInitialized,
    String? networkStatus,
    String? currentUrl,
  }) {
    return SplashScreenState(
      progress: progress ?? this.progress,
      statusMessage: statusMessage ?? this.statusMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
      hasCriticalError: hasCriticalError ?? this.hasCriticalError,
      isInitialized: isInitialized ?? this.isInitialized,
      networkStatus: networkStatus ?? this.networkStatus,
      currentUrl: currentUrl ?? this.currentUrl,
    );
  }
}

class SplashScreenNotifier extends StateNotifier<SplashScreenState> {
  final NetworkService _networkService;
  final Ref _ref;
  StreamSubscription<bool>? _networkSubscription;
  StreamSubscription<String>? _urlSubscription;
  final Duration _retryDelay = const Duration(seconds: 2);

  SplashScreenNotifier(
      this._networkService,
      this._ref,
      ) : super(SplashScreenState()) {
    _setupNetworkListener();
  }

  void _setupNetworkListener() {
    _networkSubscription = Stream.periodic(const Duration(seconds: 3))
        .asyncMap((_) => _networkService.isConnected)
        .listen(
          (isConnected) {
        if (isConnected && state.networkStatus != AppStrings.networkSuccess) {
          state = state.copyWith(
            networkStatus: AppStrings.networkSuccess,
            errorMessage: state.errorMessage == AppStrings.noInternetConnection ? null : state.errorMessage,
            hasCriticalError: state.errorMessage != null && state.errorMessage == 'Serveur injoignable. Vérifiez l\'URL.' ? state.hasCriticalError : false,
          );
          if (state.errorMessage == null && mounted) {
            SnackbarManager.showSuccess(
              _ref.read(contextProvider as ProviderListenable<BuildContext>),
              AppStrings.networkSuccess,
            );
          }
        } else if (!isConnected) {
          state = state.copyWith(networkStatus: AppStrings.noInternetConnection);
        }
        AppLogger.info('État réseau : ${state.networkStatus}');
      },
      onError: (e) {
        state = state.copyWith(networkStatus: AppStrings.networkError);
        AppLogger.error('Erreur listener réseau : $e');
      },
    );

    _urlSubscription = _networkService.baseUrlStream.listen(
          (url) {
        state = state.copyWith(currentUrl: url);
        AppLogger.info('URL mise à jour : $url');
      },
      onError: (e) {
        state = state.copyWith(currentUrl: AppStrings.errorMessage);
        AppLogger.error('Erreur listener URL : $e');
      },
    );
  }

  Future<void> initialize(BuildContext context) async {
    if (!context.mounted) return;
    _ref.read(contextProvider.notifier).state = context;
    state = state.copyWith(isLoading: true, progress: 0.0);

    try {
      await _waitForBaseUrl(context);
      state = state.copyWith(progress: 0.5, statusMessage: AppStrings.initializing);

      await _checkNetwork(context);
      state = state.copyWith(progress: 0.8, statusMessage: AppStrings.networkChecked);

      await _checkAppVersion(context);
      state = state.copyWith(
        progress: 1.0,
        statusMessage: AppStrings.successMessage,
        isInitialized: true,
        isLoading: false,
      );

      if (context.mounted) {
        SnackbarManager.showSuccess(context, AppStrings.successMessage);
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
        final url = await _networkService.baseUrlStream
            .firstWhere((url) => url.isNotEmpty && _isValidUrl(url))
            .timeout(
          const Duration(seconds: 5),
          onTimeout: () => throw NetworkException(AppStrings.networkError),
        );

        final isReachable = await _networkService.networkInfo.canHandleRequests(url);
        if (!isReachable) {
          throw ServerUnreachableException();
        }

        state = state.copyWith(currentUrl: url, progress: 0.5);
        AppLogger.info('URL validée à la tentative $attempt : $url');
        isValid = true;
      } catch (e) {
        AppLogger.error('Échec validation URL à la tentative $attempt: $e');
        state = state.copyWith(
          statusMessage: 'Attente URL valide (tentative $attempt)',
          progress: 0.3 + (0.2 * (attempt % 5) / 5),
          errorMessage: AppStrings.networkError,
        );
        if (context.mounted) {
          SnackbarManager.showError(context, AppStrings.networkError);
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

  Future<void> _checkAppVersion(BuildContext context) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      AppLogger.info('Version vérifiée.');
    } catch (e) {
      throw ApiException(AppStrings.errorMessage);
    }
  }

  void _handleError(BuildContext context, dynamic error) {
    String errorMessage;
    if (error is NoInternetException) {
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
      hasCriticalError: error is NoInternetException || error is ServerUnreachableException,
    );

    if (context.mounted) {
      SnackbarManager.showError(context, errorMessage);
    }
    AppLogger.error('Erreur SplashScreen : $error');
  }

  void _navigate(BuildContext context) {
    AppLogger.info('Navigation : Redirection vers ${RouteNames.home}');
    if (context.mounted) {
      context.goNamed(RouteNames.home);
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
      AppLogger.info('URL mise à jour manuellement : $url');
    } else {
      state = state.copyWith(errorMessage: AppStrings.invalidEmail);
      AppLogger.error('URL invalide : $url');
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
    AppLogger.info('SplashScreenNotifier disposé');
  }
}

final contextProvider = StateProvider<BuildContext?>((ref) => null);

final splashScreenProvider = StateNotifierProvider<SplashScreenNotifier, SplashScreenState>((ref) {
  return SplashScreenNotifier(
    ref.read(networkServiceProvider),
    ref,
  );
});
