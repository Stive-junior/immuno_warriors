// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:immuno_warriors/core/routes/route_names.dart';
import 'package:lottie/lottie.dart';
import 'package:immuno_warriors/core/constants/app_assets.dart';
import 'package:immuno_warriors/core/constants/app_strings.dart';
import 'package:immuno_warriors/core/exceptions/app_exception.dart';
import 'package:immuno_warriors/core/exceptions/network_exceptions.dart';
import 'package:immuno_warriors/core/services/auth_service.dart';
import 'package:immuno_warriors/core/services/network_service.dart';
import 'package:immuno_warriors/core/services/user_service.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/features/auth/providers/auth_provider.dart';
import 'package:immuno_warriors/features/auth/providers/user_provider.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/shared/widgets/buttons/holographic_button.dart';
import 'package:immuno_warriors/shared/widgets/feedback/snackbar_manager.dart';
import 'package:immuno_warriors/shared/ui/futuristic_text.dart';

// Modèle d'état pour le SplashScreen, encapsulant toutes les informations nécessaires à l'affichage.
class SplashScreenState {
  final double progress; // Progression de l'initialisation (0.0 à 1.0).
  final String
  statusMessage; // Message affiché à l'utilisateur (ex. "Vérification réseau").
  final String? errorMessage; // Message d'erreur en cas de problème.
  final bool isLoading; // Indique si le chargement est en cours.
  final bool
  hasCriticalError; // Indique une erreur bloquante (ex. pas de réseau).
  final bool isAuthenticated; // Indique si l'utilisateur est authentifié.
  final bool isInitialized; // Indique si l'initialisation est terminée.
  final bool showContinueButton; // Affiche le bouton "Continuer" si true.

  SplashScreenState({
    this.progress = 0.0,
    this.statusMessage = '',
    this.errorMessage,
    this.isLoading = false,
    this.hasCriticalError = false,
    this.isAuthenticated = false,
    this.isInitialized = false,
    this.showContinueButton = false,
  });

  // Méthode pour créer une copie de l'état avec des modifications.
  SplashScreenState copyWith({
    double? progress,
    String? statusMessage,
    String? errorMessage,
    bool? isLoading,
    bool? hasCriticalError,
    bool? isAuthenticated,
    bool? isInitialized,
    bool? showContinueButton,
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
    );
  }
}

// Notifier pour gérer l'état du SplashScreen et orchestrer l'initialisation.
class SplashScreenNotifier extends StateNotifier<SplashScreenState> {
  final AuthService _authService; // Service pour gérer l'authentification.
  final NetworkService
  _networkService; // Service pour vérifier la connectivité.
  final UserService
  _userService; // Service pour charger les données utilisateur.
  final Ref _ref; // Référence Riverpod pour accéder aux providers.

  SplashScreenNotifier(
    this._authService,
    this._networkService,
    this._userService,
    this._ref,
  ) : super(SplashScreenState());

  // Initialise le SplashScreen en vérifiant le réseau, la session, le profil, et les ressources.
  Future<void> initialize(BuildContext context) async {
    if (!context.mounted) return; // Vérifie si le contexte est valide.
    state = state.copyWith(
      isLoading: true,
      statusMessage: AppStrings.initializing,
      progress: 0.0,
    );

    try {
      // Étape 1 : Vérification de la connexion réseau.
      final networkStart = DateTime.now();
      await _checkNetwork(context);
      AppLogger.info(
        'Vérification réseau terminée en ${DateTime.now().difference(networkStart).inMilliseconds}ms',
      );
      state = state.copyWith(
        progress: 0.25,
        statusMessage: AppStrings.networkChecked,
      );

      // Étape 2 : Vérification de la session utilisateur.
      final sessionStart = DateTime.now();
      final isAuthenticated = await _checkSession(context);
      AppLogger.info(
        'Vérification session terminée en ${DateTime.now().difference(sessionStart).inMilliseconds}ms',
      );
      state = state.copyWith(
        progress: 0.5,
        statusMessage: AppStrings.sessionChecked,
        isAuthenticated: isAuthenticated,
      );

      // Étape 3 : Chargement du profil utilisateur si authentifié.
      if (isAuthenticated) {
        final profileStart = DateTime.now();
        await _loadUserProfile(context);
        AppLogger.info(
          'Chargement profil terminé en ${DateTime.now().difference(profileStart).inMilliseconds}ms',
        );
        state = state.copyWith(
          progress: 0.75,
          statusMessage: AppStrings.profileLoaded,
        );
      }

      // Étape 4 : Chargement des ressources utilisateur si authentifié.
      if (isAuthenticated) {
        final resourcesStart = DateTime.now();
        await _loadUserResources(context);
        AppLogger.info(
          'Chargement ressources terminé en ${DateTime.now().difference(resourcesStart).inMilliseconds}ms',
        );
        state = state.copyWith(
          progress: 1.0,
          statusMessage: AppStrings.resourcesLoaded,
        );
      }

      // Étape 5 : Vérification de la version de l'application (nouvelle fonctionnalité).
      final versionStart = DateTime.now();
      await _checkAppVersion(context);
      AppLogger.info(
        'Vérification version terminée en ${DateTime.now().difference(versionStart).inMilliseconds}ms',
      );

      // Finalisation de l'initialisation.
      state = state.copyWith(
        isLoading: false,
        isInitialized: true,
        showContinueButton: true,
      );

      // Pause pour un effet visuel fluide.
      await Future.delayed(const Duration(seconds: 1));
      if (!context.mounted) return;

      // Navigation automatique si non authentifié.
      if (!isAuthenticated) {
        _navigate(context);
      }
    } catch (e) {
      if (context.mounted) {
        _handleError(context, e);
      }
    }
  }

  // Vérifie la connectivité réseau.
  Future<void> _checkNetwork(BuildContext context) async {
    try {
      if (!await _networkService.isConnected) {
        throw NoInternetException();
      }
      if (!await _networkService.isServerReachable()) {
        throw ServerUnreachableException();
      }
      if (context.mounted) {
        SnackbarManager.showSnackbar(
          context,
          AppStrings.networkSuccess,
          backgroundColor: AppColors.successColor,
          textColor: AppColors.textColorPrimary,
          animationAsset:
              AppAssets.successAnimation, // Fallback vers successAnimation.
        );
      }
    } catch (e) {
      AppLogger.error('Erreur de réseau : $e');
      throw ApiException(AppStrings.networkError);
    }
  }

  // Vérifie la validité de la session utilisateur.
  Future<bool> _checkSession(BuildContext context) async {
    try {
      final isAuthenticated = await _authService.verifyToken();
      if (context.mounted) {
        SnackbarManager.showSnackbar(
          context,
          isAuthenticated
              ? AppStrings.sessionSuccess
              : AppStrings.sessionExpired,
          backgroundColor:
              isAuthenticated ? AppColors.successColor : AppColors.warningColor,
          textColor: AppColors.textColorPrimary,
          animationAsset:
              AppAssets.successAnimation, // Fallback vers successAnimation.
        );
      }
      return isAuthenticated;
    } catch (e) {
      AppLogger.error('Erreur de vérification de session : $e');
      throw ApiException(AppStrings.sessionError);
    }
  }

  // Charge le profil utilisateur.
  Future<void> _loadUserProfile(BuildContext context) async {
    try {
      final result = await _userService.getUserProfile();
      result.fold((error) => throw error, (profile) {
        _ref.read(userProvider.notifier).loadUserProfile();
        if (context.mounted) {
          SnackbarManager.showSnackbar(
            context,
            AppStrings.profileSuccess,
            backgroundColor: AppColors.successColor,
            textColor: AppColors.textColorPrimary,
            animationAsset: AppAssets.successAnimation,
          );
        }
      });
    } catch (e) {
      AppLogger.error('Erreur de chargement du profil : $e');
      throw ApiException(AppStrings.profileError);
    }
  }

  // Charge les ressources utilisateur.
  Future<void> _loadUserResources(BuildContext context) async {
    try {
      final result = await _userService.getUserResources();
      result.fold((error) => throw error, (resources) {
        _ref.read(userProvider.notifier).loadUserResources();
        if (context.mounted) {
          SnackbarManager.showSnackbar(
            context,
            AppStrings.resourcesSuccess,
            backgroundColor: AppColors.successColor,
            textColor: AppColors.textColorPrimary,
            animationAsset: AppAssets.successAnimation,
          );
        }
      });
    } catch (e) {
      AppLogger.error('Erreur de chargement des ressources : $e');
      throw ApiException(AppStrings.resourcesError);
    }
  }

  // Vérifie la version de l'application (nouvelle fonctionnalité).
  Future<void> _checkAppVersion(BuildContext context) async {
    try {
      // Simule une vérification de version (à implémenter selon votre service).
      await Future.delayed(const Duration(milliseconds: 500));
      AppLogger.info('Version de l\'application vérifiée.');
    } catch (e) {
      AppLogger.error('Erreur de vérification de version : $e');
      throw ApiException('Erreur de vérification de version.');
    }
  }

  // Gère les erreurs en mettant à jour l'état et en affichant un message.
  void _handleError(BuildContext context, dynamic error) {
    final errorMessage =
        error is ApiException ? error.message : AppStrings.errorMessage;
    state = state.copyWith(
      isLoading: false,
      errorMessage: errorMessage,
      hasCriticalError:
          error is NoInternetException || error is ServerUnreachableException,
    );
    if (context.mounted) {
      SnackbarManager.showSnackbar(
        context,
        errorMessage,
        backgroundColor: AppColors.errorColor,
        textColor: AppColors.textColorPrimary,
        animationAsset: AppAssets.successAnimation, // Fallback.
      );
    }
    AppLogger.error('Erreur dans SplashScreen : $error');
  }

  // Navigue vers la page appropriée selon l'état d'authentification.
  void _navigate(BuildContext context) {
    if (context.mounted) {
      context.goNamed(
        state.isAuthenticated ? RouteNames.home : RouteNames.login,
      );
    }
  }

  // Réessaie l'initialisation en cas d'erreur.
  void retry(BuildContext context) {
    state = state.copyWith(
      errorMessage: null,
      hasCriticalError: false,
      progress: 0.0,
      statusMessage: AppStrings.initializing,
    );
    initialize(context);
  }

  // Efface l'erreur affichée.
  void clearError() {
    state = state.copyWith(errorMessage: null, hasCriticalError: false);
  }

  // Déclenche la navigation manuelle via le bouton "Continuer".
  void continueNavigation(BuildContext context) {
    _navigate(context);
  }
}

// Fournisseur Riverpod pour le SplashScreen.
final splashScreenProvider =
    StateNotifierProvider<SplashScreenNotifier, SplashScreenState>((ref) {
      return SplashScreenNotifier(
        ref.read(authServiceProvider),
        ref.read(networkServiceProvider),
        ref.read(userServiceProvider),
        ref,
      );
    });

// Widget principal du SplashScreen.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _MegaSplashScreenState();
}

// État du SplashScreen avec animations et gestion visuelle.
class _MegaSplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Contrôleur pour les animations.
  late Animation<double> _buttonAnimation; // Animation du bouton "Continuer".
  late Animation<double> _orbitAnimation; // Animation des éléments orbitaux.
  late Animation<double> _pulseAnimation; // Animation du logo pulsant.
  late Animation<double>
  _particleAnimation; // Nouvelle animation pour les particules.
  final List<OrbitingElement> _orbitingElements =
      []; // Liste des éléments orbitaux.
  final List<Particle> _particles =
      []; // Nouvelle liste pour les particules dynamiques.

  @override
  void initState() {
    super.initState();

    // Initialisation des éléments orbitaux et particules.
    _initializeOrbitingElements();
    _initializeParticles();

    // Configuration du contrôleur d'animation.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 12,
      ), // Durée augmentée pour plus d'effets.
    );

    // Animation du bouton "Continuer".
    _buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.8, 1.0, curve: Curves.elasticOut),
      ),
    );

    // Animation des éléments orbitaux.
    _orbitAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );

    // Animation du logo pulsant.
    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.2), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.2, end: 1.0), weight: 50),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Animation des particules (nouvelle).
    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    // Lancer l'initialisation après le premier frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(splashScreenProvider.notifier).initialize(context);
        _controller.repeat(); // Répéter pour un effet continu.
      }
    });
  }

  // Initialise les éléments orbitaux avec des paramètres variés.
  void _initializeOrbitingElements() {
    final random = Random();
    _orbitingElements.addAll([
      OrbitingElement(
        radius: 120,
        speed: 1.5,
        size: 12,
        color: AppColors.primaryColor.withValues(blue: 0.8),
        startAngle: random.nextDouble() * 2 * pi,
      ),
      OrbitingElement(
        radius: 150,
        speed: 1.2,
        size: 16,
        color: AppColors.secondaryColor.withValues(blue: 0.8),
        startAngle: random.nextDouble() * 2 * pi,
      ),
      OrbitingElement(
        radius: 180,
        speed: 0.8,
        size: 8,
        color: AppColors.primaryAccentColor.withValues(blue: 0.8),
        startAngle: random.nextDouble() * 2 * pi,
      ),
      OrbitingElement(
        radius: 200,
        speed: 1.0,
        size: 10,
        color: AppColors.buttonAccentColor.withValues(blue: 0.7),
        startAngle: random.nextDouble() * 2 * pi,
      ),
      OrbitingElement(
        radius: 220,
        speed: 0.9,
        size: 14,
        color: AppColors.buttonAccentColor.withValues(blue: 0.6),
        startAngle: random.nextDouble() * 2 * pi,
      ),
    ]);
  }

  // Initialise les particules dynamiques pour un effet visuel supplémentaire.
  void _initializeParticles() {
    final random = Random();
    for (int i = 0; i < 50; i++) {
      _particles.add(
        Particle(
          x: random.nextDouble(),
          y: random.nextDouble(),
          speed: random.nextDouble() * 0.5 + 0.2,
          size: random.nextDouble() * 4 + 2,
          color: AppColors.primaryColor.withValues(
            blue: random.nextDouble() * 0.5 + 0.3,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Construit l'effet de bulle pour la barre de progression.
  Widget _buildBubbleEffect(double value) {
    return CustomPaint(
      painter: MegaBubbleProgressPainter(
        value: value,
        color: AppColors.primaryColor,
      ),
    );
  }

  // Construit les éléments orbitaux animés.
  Widget _buildOrbitingElements() {
    return AnimatedBuilder(
      animation: _orbitAnimation,
      builder: (context, child) {
        return Stack(
          children:
              _orbitingElements.map((element) {
                final angle =
                    element.startAngle +
                    (_orbitAnimation.value * element.speed);
                return Positioned(
                  left:
                      cos(angle) * element.radius +
                      MediaQuery.of(context).size.width / 2 -
                      element.size / 2,
                  top:
                      sin(angle) * element.radius +
                      MediaQuery.of(context).size.height / 2 -
                      100,
                  child: Container(
                    width: element.size,
                    height: element.size,
                    decoration: BoxDecoration(
                      color: element.color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: element.color.withValues(blue: 0.8),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
        );
      },
    );
  }

  // Construit le logo pulsant avec un effet de lumière.
  Widget _buildPulsingLogo() {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.secondaryColor.withValues(blue: 0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondaryAccentColor.withValues(blue: 0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            AppAssets.splashVirus,
            width: 120,
            height: 120,
            errorBuilder: (context, error, stackTrace) {
              AppLogger.error(
                'Erreur de chargement de l\'image',
                error: error,
                stackTrace: stackTrace,
              );
              return Container(color: AppColors.primaryColor);
            },
          ),
        ),
      ),
    );
  }

  // Construit l'anneau néon avec progression.
  Widget _buildNeonRing() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: NeonRingPainter(
            progress: ref.watch(splashScreenProvider).progress,
            color: AppColors.primaryColor,
          ),
          size: Size(MediaQuery.of(context).size.width, 200),
        );
      },
    );
  }

  // Construit un effet de particules dynamiques.
  Widget _buildParticleEffect(Size size) {
    return AnimatedBuilder(
      animation: _particleAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(
            particles: _particles,
            animationValue: _particleAnimation.value,
            size: size,
          ),
          size: size,
        );
      },
    );
  }

  // Construit un dialogue d'erreur personnalisé.
  Widget _buildErrorDialog(BuildContext context, String errorMessage) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor.withValues(blue: 0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.buttonAccentColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.buttonAccentColor.withValues(blue: 0.4),
              blurRadius: 15,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FuturisticText(
              AppStrings.errorTitle,
              size: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.errorColor,
            ),
            const SizedBox(height: 16),
            FuturisticText(
              errorMessage,
              size: 16,
              color: AppColors.textColorPrimary,
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            VirusButton(
              onPressed: () {
                ref.read(splashScreenProvider.notifier).retry(context);
              },
              width: 200,
              child: FuturisticText(
                AppStrings.retry,
                size: 16,
                color: AppColors.textColorPrimary,
              ),
            ),
            const SizedBox(height: 16),
            VirusButton(
              onPressed: () {
                ref.read(splashScreenProvider.notifier).clearError();
              },
              width: 200,
              child: FuturisticText(
                AppStrings.cancel,
                size: 16,
                color: AppColors.textColorPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(splashScreenProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Fond animé avec Lottie.
          Positioned.fill(
            child: Lottie.asset(
              AppAssets.backgroundAnimation,
              fit: BoxFit.cover,
              repeat: true,
              animate: true,
              errorBuilder: (context, error, stackTrace) {
                AppLogger.error(
                  'Erreur de chargement Lottie',
                  error: error,
                  stackTrace: stackTrace,
                );
                return Container(color: AppColors.backgroundColor);
              },
            ),
          ),
          // Effet de particules dynamiques.
          Positioned.fill(child: _buildParticleEffect(size)),
          // Gradient overlay pour un effet futuriste.
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.5,
                  colors: [
                    AppColors.primaryColor.withValues(blue: 0.05),
                    AppColors.backgroundColor.withValues(blue: 0.9),
                  ],
                ),
              ),
            ),
          ),
          // Éléments orbitaux animés.
          _buildOrbitingElements(),
          // Anneau néon centré.
          Positioned(
            top: size.height / 2 - 150,
            left: size.width / 2 - 150,
            child: _buildNeonRing(),
          ),
          // Contenu principal.
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo pulsant.
                _buildPulsingLogo(),
                const SizedBox(height: 30),
                // Barre de progression.
                SizedBox(
                  width: size.width * 0.7,
                  height: 30,
                  child: Stack(
                    children: [
                      // Fond de la barre.
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryAccentColor,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: AppColors.secondaryColor,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColor.withValues(
                                blue: 0.1,
                              ),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      // Barre de progression avec effet de bulles.
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: _buildBubbleEffect(state.progress),
                      ),
                      // Indicateur de progression (logo animé).
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Positioned(
                            left: state.progress * (size.width * 0.7 - 40),
                            top: 0,
                            child: Container(
                              width: 40,
                              height: 30,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  AppAssets.splashVirus,
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    AppLogger.error(
                                      'Erreur de chargement de l\'image',
                                      error: error,
                                      stackTrace: stackTrace,
                                    );
                                    return Container(
                                      color: AppColors.primaryColor,
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      // Pourcentage de progression.
                      Center(
                        child: FuturisticText(
                          '${(state.progress * 100).toStringAsFixed(0)}%',
                          size: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Texte de statut avec transition animée.
                SizedBox(
                  width: size.width * 0.8,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.2),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: FuturisticText(
                      state.statusMessage,
                      key: ValueKey<String>(state.statusMessage),
                      textAlign: TextAlign.center,
                      size: 18,
                      color: AppColors.textColorPrimary.withValues(blue: 0.9),
                      shadows: [
                        Shadow(
                          blurRadius: 15,
                          color: AppColors.primaryColor.withValues(blue: 0.7),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                // Bouton "Continuer" avec animation.
                if (state.showContinueButton)
                  ScaleTransition(
                    scale: _buttonAnimation,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 1000),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryColor,
                            AppColors.primaryAccentColor,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withValues(blue: 0.6),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: VirusButton(
                        onPressed: () {
                          ref
                              .read(splashScreenProvider.notifier)
                              .continueNavigation(context);
                        },
                        width: 200,
                        child: FuturisticText(
                          AppStrings.continueButtonText,
                          size: 16,
                          color: AppColors.textColorPrimary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Dialogue d'erreur si nécessaire.
          if (state.hasCriticalError)
            _buildErrorDialog(
              context,
              state.errorMessage ?? AppStrings.errorMessage,
            ),
        ],
      ),
    );
  }
}

// Modèle pour un élément orbital.
class OrbitingElement {
  final double radius; // Rayon de l'orbite.
  final double speed; // Vitesse de rotation.
  final double size; // Taille de l'élément.
  final Color color; // Couleur de l'élément.
  final double startAngle; // Angle initial.

  OrbitingElement({
    required this.radius,
    required this.speed,
    required this.size,
    required this.color,
    required this.startAngle,
  });
}

// Modèle pour une particule dynamique.
class Particle {
  double x; // Position X normalisée (0 à 1).
  double y; // Position Y normalisée (0 à 1).
  final double speed; // Vitesse de déplacement.
  final double size; // Taille de la particule.
  final Color color; // Couleur de la particule.

  Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.color,
  });
}

// Peintre pour la barre de progression avec effet de bulles.
class MegaBubbleProgressPainter extends CustomPainter {
  final double value; // Valeur de progression (0.0 à 1.0).
  final Color color; // Couleur principale.

  MegaBubbleProgressPainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final progressWidth = size.width * value;

    // Fond avec gradient.
    final gradient = LinearGradient(
      colors: [color.withValues(blue: 0.8), color.withValues(blue: 0.4)],
    );
    final paint =
        Paint()
          ..shader = gradient.createShader(
            Rect.fromLTWH(0, 0, progressWidth, size.height),
          )
          ..style = PaintingStyle.fill;

    // Barre de progression principale.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, progressWidth, size.height),
        Radius.circular(size.height / 2),
      ),
      paint,
    );

    // Effet de bulles dynamiques.
    final bubblePaint =
        Paint()
          ..color = Colors.white.withValues(blue: 0.5)
          ..style = PaintingStyle.fill;

    final rng = Random((value * 1000).toInt());

    for (int i = 0; i < 20; i++) {
      final bubbleSize = rng.nextDouble() * 10 + 2;
      final bubbleX = rng.nextDouble() * progressWidth;
      final bubbleY = rng.nextDouble() * size.height;

      if (bubbleX + bubbleSize < progressWidth) {
        canvas.drawCircle(Offset(bubbleX, bubbleY), bubbleSize, bubblePaint);

        if (bubbleSize > 5) {
          canvas.drawCircle(
            Offset(bubbleX - bubbleSize * 0.3, bubbleY - bubbleSize * 0.3),
            bubbleSize * 0.3,
            Paint()..color = Colors.white.withValues(blue: 0.8),
          );
        }
      }
    }

    // Bordure lumineuse.
    final borderPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, progressWidth, size.height),
        Radius.circular(size.height / 2),
      ),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant MegaBubbleProgressPainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.color != color;
  }
}

// Peintre pour l'anneau néon.
class NeonRingPainter extends CustomPainter {
  final double progress; // Progression de l'anneau (0.0 à 1.0).
  final Color color; // Couleur principale.

  NeonRingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const radius = 150.0;
    const strokeWidth = 8.0;

    // Anneau de fond.
    final backgroundPaint =
        Paint()
          ..color = color.withValues(blue: 0.1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Anneau de progression.
    final progressPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );

    // Effet de points autour de l'anneau.
    final dotPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    const dotCount = 24;
    for (var i = 0; i < dotCount; i++) {
      final angle = 2 * pi * i / dotCount - pi / 2;
      final dotPosition = center + Offset(cos(angle), sin(angle)) * radius;

      if (angle + pi / 2 <= sweepAngle) {
        canvas.drawCircle(dotPosition, 4, dotPaint);
        canvas.drawCircle(
          dotPosition,
          6,
          Paint()
            ..color = color.withValues(blue: 0.3)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
        );
      }
    }

    // Effet de lumière au point de progression.
    if (progress > 0) {
      final progressAngle = 2 * pi * progress - pi / 2;
      final progressPosition =
          center + Offset(cos(progressAngle), sin(progressAngle)) * radius;

      canvas.drawCircle(
        progressPosition,
        12,
        Paint()
          ..color = color.withValues(blue: 0.8)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
      );
    }
  }

  @override
  bool shouldRepaint(covariant NeonRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles; // Liste des particules.
  final double animationValue; // Valeur d'animation (0.0 à 1.0).
  final Size size; // Taille du canvas.

  ParticlePainter({
    required this.particles,
    required this.animationValue,
    required this.size,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var particle in particles) {
      // Met à jour la position Y de la particule.
      particle.y += particle.speed * animationValue / 100;
      if (particle.y > 1) particle.y -= 1; // Boucle vers le haut.

      // Calcule les coordonnées réelles.
      final x = particle.x * size.width;
      final y = particle.y * size.height;

      paint.color = particle.color;
      canvas.drawCircle(Offset(x, y), particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
