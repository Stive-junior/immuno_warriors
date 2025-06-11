import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';

// Core Imports
import 'package:immuno_warriors/core/constants/app_assets.dart';
import 'package:immuno_warriors/core/constants/app_strings.dart';
import 'package:immuno_warriors/core/constants/app_sizes.dart';
import 'package:immuno_warriors/core/constants/app_animations.dart';
import 'package:immuno_warriors/core/routes/route_names.dart';
import 'package:immuno_warriors/features/auth/providers/auth_provider.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

// Shared UI Components
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/shared/ui/futuristic_text.dart';
import 'package:immuno_warriors/shared/ui/screen_utils.dart';

// Shared Widgets
import 'package:immuno_warriors/shared/widgets/cards/neon_card.dart';
import 'package:immuno_warriors/shared/widgets/forms/input_field.dart';
import 'package:immuno_warriors/shared/widgets/animations/scan_effect.dart';
import 'package:immuno_warriors/shared/widgets/animations/pulse_widget.dart';
import 'package:immuno_warriors/shared/widgets/animations/animated_border.dart';
import 'package:immuno_warriors/shared/widgets/buttons/action_button.dart';

import '../../../shared/widgets/buttons/holographic_button.dart';
import '../../../shared/widgets/common/theme_selection_dialog.dart';

/// LoginScreen : Écran de connexion pour les utilisateurs existants.
///
/// Ce widget permet aux utilisateurs de se connecter avec leur email et mot de passe,
/// ou via des options de connexion sociale. Il intègre des animations futuristes
/// et une interface utilisateur immersive, cohérente avec le thème Immuno Warriors.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  late AnimationController _scanController;
  late AnimationController _pulseController;
  late AnimationController _themeIconController;
  late AnimationController _helpIconController;
  late AnimationController _geminiIconController;
  late AnimationController _signInLottieController;
  late AnimationController _googleLottieController;
  late AnimationController _facebookLottieController;
  late AnimationController _backArrowController;

  @override
  void initState() {
    super.initState();
    _initAnimationControllers();
    // _preloadLottieAssets(); // Suppression de l'appel au préchargement
  }

  void _initAnimationControllers() {
    try {
      _scanController = AnimationController(
        duration: AppAnimations.scanEffectDuration,
        vsync: this,
      )..repeat(reverse: true);
      _pulseController = AnimationController(
        duration: AppAnimations.pulseAnimationDuration,
        vsync: this,
      )..repeat(reverse: true);
      _themeIconController = AnimationController(
        duration: AppAnimations.durationLong,
        vsync: this,
      )..repeat(reverse: true);
      _helpIconController = AnimationController(
        duration: AppAnimations.durationLong,
        vsync: this,
      )..repeat();
      _geminiIconController = AnimationController(
        duration: AppAnimations.durationLong,
        vsync: this,
      )..repeat(reverse: true);
      _signInLottieController = AnimationController(
        duration: AppAnimations.durationLong,
        vsync: this,
      )..repeat();
      _googleLottieController = AnimationController(
        duration: AppAnimations.durationLong,
        vsync: this,
      )..repeat(reverse: true);
      _facebookLottieController = AnimationController(
        duration: AppAnimations.durationLong,
        vsync: this,
      )..repeat();
      _backArrowController = AnimationController(
        duration: AppAnimations.durationLong,
        vsync: this,
      )..repeat();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to initialize animation controllers',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // Suppression complète de la fonction _preloadLottieAssets()

  @override
  void dispose() {
    _scanController.dispose();
    _pulseController.dispose();
    _themeIconController.dispose();
    _helpIconController.dispose();
    _geminiIconController.dispose();
    _signInLottieController.dispose();
    _googleLottieController.dispose();
    _facebookLottieController.dispose();
    _backArrowController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Gère le processus de connexion de l'utilisateur.
  Future<void> _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      final authNotifier = ref.read(authProvider.notifier);
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      await authNotifier.signIn(email: email, password: password);

      if (!mounted) return;
      final authState = ref.read(authProvider);

      if (authState.isSignedIn) {
        AppLogger.info(
          'User $email signed in successfully. Navigating to dashboard.',
        );
        context.goNamed(RouteNames.dashboard, extra: authState.user?.id);
      } else {
        AppLogger.error('Sign in failed: ${authState.errorMessage}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: FuturisticText(
              authState.errorMessage ?? AppStrings.loginFailed,
              color: AppColors.textColorPrimary,
            ),
            backgroundColor: AppColors.errorColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
            ),
            margin: const EdgeInsets.all(AppSizes.paddingMedium),
          ),
        );
      }
    }
  }

  /// Gère la connexion avec Google (à implémenter).
  void _signInWithGoogle() {
    AppLogger.info('Sign in with Google pressed.');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: FuturisticText(
          'Fonctionnalité Google à implémenter',
          color: AppColors.textColorPrimary,
        ),
        backgroundColor: AppColors.interfaceColorDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        ),
        margin: const EdgeInsets.all(AppSizes.paddingMedium),
      ),
    );
  }

  /// Gère la connexion avec Facebook (à implémenter).
  void _signInWithFacebook() {
    AppLogger.info('Sign in with Facebook pressed.');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: FuturisticText(
          'Fonctionnalité Facebook à implémenter',
          color: AppColors.textColorPrimary,
        ),
        backgroundColor: AppColors.interfaceColorDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        ),
        margin: const EdgeInsets.all(AppSizes.paddingMedium),
      ),
    );
  }

  /// Affiche une boîte de dialogue pour la sélection du thème en utilisant le nouveau widget.
  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return ThemeSelectionDialog(
          themeIconController: _themeIconController,
          onThemeSelected: (themeMode) {
            // TODO: Implémenter la logique de changement de thème ici
            AppLogger.info('Theme changed to: $themeMode');
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ScreenUtils.getScreenWidth(context);
    final screenHeight = ScreenUtils.getScreenHeight(context);
    final isLandscape =
        ScreenUtils.getScreenOrientation(context) == Orientation.landscape;
    final authLoading = ref.watch(authLoadingProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Animated Background
          Positioned.fill(
            child: Lottie.asset(
              AppAssets.backgroundAnimation,
              fit: BoxFit.cover,
              repeat: true,
              controller: _scanController,
              errorBuilder: (context, error, stackTrace) {
                AppLogger.error(
                  'Error loading background Lottie: ${AppAssets.backgroundAnimation}',
                  error: error,
                  stackTrace: stackTrace,
                );
                return Container(color: AppColors.backgroundColor);
              },
            ),
          ),

          // 2. Scan Effect Overlay
          Positioned.fill(
            child: AdvancedScanEffect(
              controller: _scanController,
              scanColor: AppColors.primaryColor.withOpacity(0.3),
              lineWidth: AppSizes.defaultBorderWidth,
              blendMode: BlendMode.plus,
            ),
          ),

          // 3. Main Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * (isLandscape ? 0.04 : 0.06),
                vertical: screenHeight * (isLandscape ? 0.03 : 0.05),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Navigation Bar
                  FadeInDown(
                    duration: AppAnimations.durationNormal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Animated App Title
                        PulseWidget(
                          controller: _pulseController,
                          minScale: 0.98,
                          maxScale: 1.02,
                          child: AnimatedBorder(
                            animationController: _pulseController,
                            width: screenWidth * (isLandscape ? 0.2 : 0.3),
                            height: AppSizes.buttonHeight,
                            borderWidth: AppSizes.defaultBorderWidth,
                            borderColor: AppColors.primaryColor.withOpacity(
                              0.8,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppSizes.buttonRadius,
                            ),
                            child: Center(
                              child: FuturisticText(
                                AppStrings.appName,
                                size: AppSizes.fontSizeLarge,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                                shadows: [
                                  Shadow(
                                    color: AppColors.primaryColor.withOpacity(
                                      0.3,
                                    ),
                                    blurRadius: 6,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Action Buttons
                        Row(
                          children: [
                            ActionButton(
                              lottieAsset: AppAssets.helpIconAnimation,
                              tooltip: AppStrings.help,
                              onPressed: () => context.goNamed(RouteNames.help),
                              controller: _helpIconController,
                              fallbackIcon: Icons.help_outline,
                            ),
                            SizedBox(width: AppSizes.spaceSmall),
                            ActionButton(
                              lottieAsset: AppAssets.themeIconAnimation,
                              tooltip: AppStrings.theme,
                              onPressed: () => _showThemeDialog(context),
                              controller: _themeIconController,
                              fallbackIcon: Icons.palette_outlined,
                            ),
                            SizedBox(width: AppSizes.spaceSmall),
                            ActionButton(
                              lottieAsset: AppAssets.geminiIconAnimation,
                              tooltip: AppStrings.gemini,
                              onPressed:
                                  () => context.goNamed(RouteNames.gemini),
                              controller: _geminiIconController,
                              fallbackIcon: Icons.psychology_outlined,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),

                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Titre de l'écran de connexion
                            FadeInDown(
                              duration: AppAnimations.durationSlow,
                              child: FuturisticText(
                                AppStrings.loginTitle,
                                size:
                                    isLandscape
                                        ? AppSizes.fontSizeHeading
                                        : AppSizes.fontSizeExtraLarge,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                                textAlign: TextAlign.center,
                                shadows: [
                                  Shadow(
                                    color: AppColors.primaryColor.withOpacity(
                                      0.5,
                                    ),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: AppSizes.spaceExtraLarge),

                            FadeInUp(
                              duration: AppAnimations.durationLong,
                              child: NeonCard(
                                glowColor: AppColors.primaryColor,
                                intensity: 0.2,
                                borderRadius: AppSizes.defaultCardRadius,
                                borderWidth: AppSizes.defaultBorderWidth,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                    AppSizes.paddingLarge,
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        InputField(
                                          controller: _emailController,
                                          labelText: AppStrings.emailHint,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          prefixIcon: Lottie.asset(
                                            AppAssets.lockAnimation,
                                            width: AppSizes.iconSizeMedium,
                                            height: AppSizes.iconSizeMedium,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              AppLogger.error(
                                                'Error loading Lottie: ${AppAssets.lockAnimation}',
                                                error: error,
                                                stackTrace: stackTrace,
                                              );
                                              return Icon(
                                                Icons.email,
                                                color:
                                                    AppColors
                                                        .textColorSecondary,
                                              );
                                            },
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return AppStrings.invalidEmail;
                                            }
                                            if (!RegExp(
                                              r'^[^@]+@[^@]+\.[^@]+',
                                            ).hasMatch(value)) {
                                              return AppStrings.invalidEmail;
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(
                                          height: AppSizes.spaceMedium,
                                        ),
                                        InputField(
                                          controller: _passwordController,
                                          labelText: AppStrings.passwordHint,
                                          obscureText: _obscurePassword,
                                          prefixIcon: Lottie.asset(
                                            AppAssets.lockAnimation,
                                            width: AppSizes.iconSizeMedium,
                                            height: AppSizes.iconSizeMedium,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              AppLogger.error(
                                                'Error loading Lottie: ${AppAssets.lockAnimation}',
                                                error: error,
                                                stackTrace: stackTrace,
                                              );
                                              return Icon(
                                                Icons.lock,
                                                color:
                                                    AppColors
                                                        .textColorSecondary,
                                              );
                                            },
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Lottie.asset(
                                              _obscurePassword
                                                  ? AppAssets.eyeClosedAnimation
                                                  : AppAssets.eyeOpenAnimation,
                                              width: AppSizes.iconSizeMedium,
                                              height: AppSizes.iconSizeMedium,
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
                                                AppLogger.error(
                                                  'Error loading Lottie: ${_obscurePassword ? AppAssets.eyeClosedAnimation : AppAssets.eyeOpenAnimation}',
                                                  error: error,
                                                  stackTrace: stackTrace,
                                                );
                                                return Icon(
                                                  _obscurePassword
                                                      ? Icons
                                                          .visibility_off_outlined
                                                      : Icons
                                                          .visibility_outlined,
                                                  color:
                                                      AppColors
                                                          .textColorSecondary,
                                                );
                                              },
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _obscurePassword =
                                                    !_obscurePassword;
                                              });
                                            },
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return AppStrings.invalidPassword;
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(
                                          height: AppSizes.spaceExtraLarge,
                                        ),
                                        VirusButton(
                                          onPressed:
                                              authLoading
                                                  ? null
                                                  : _handleSignIn,
                                          borderRadius: AppSizes.buttonRadius,
                                          borderColor: AppColors.primaryColor,
                                          elevation: AppSizes.defaultElevation,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: AppSizes.paddingMedium,
                                            ),
                                            child:
                                                authLoading
                                                    ? CircularProgressIndicator(
                                                      color:
                                                          AppColors
                                                              .textColorPrimary,
                                                    )
                                                    : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Lottie.asset(
                                                          AppAssets
                                                              .signInAnimation,
                                                          width:
                                                              AppSizes
                                                                  .iconSizeMedium,
                                                          height:
                                                              AppSizes
                                                                  .iconSizeMedium,
                                                          controller:
                                                              _signInLottieController,
                                                          repeat: true,
                                                          errorBuilder: (
                                                            context,
                                                            error,
                                                            stackTrace,
                                                          ) {
                                                            AppLogger.error(
                                                              'Error loading Lottie: ${AppAssets.signInAnimation}',
                                                              error: error,
                                                              stackTrace:
                                                                  stackTrace,
                                                            );
                                                            return Icon(
                                                              Icons.login,
                                                              color:
                                                                  AppColors
                                                                      .textColorPrimary,
                                                            );
                                                          },
                                                        ),
                                                        const SizedBox(
                                                          width:
                                                              AppSizes
                                                                  .spaceSmall,
                                                        ),
                                                        FuturisticText(
                                                          AppStrings
                                                              .loginButton,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              AppColors
                                                                  .textColorPrimary,
                                                          size:
                                                              AppSizes
                                                                  .fontSizeMedium,
                                                        ),
                                                      ],
                                                    ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: AppSizes.spaceExtraLarge),

                            // Option de connexion sociale
                            FadeInUp(
                              delay: AppAnimations.durationExtraSlow,
                              duration: AppAnimations.durationLong,
                              child: Column(
                                children: [
                                  FuturisticText(
                                    AppStrings.orConnectWith,
                                    color: AppColors.textColorSecondary,
                                    size: AppSizes.fontSizeMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: AppSizes.spaceLarge),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Bouton Google
                                      VirusButton(
                                        onPressed: _signInWithGoogle,
                                        borderRadius: AppSizes.buttonRadius,
                                        borderColor:
                                            AppColors.secondaryAccentColor,
                                        elevation:
                                            AppSizes.defaultElevation / 2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                            AppSizes.paddingMedium,
                                          ),
                                          child: Lottie.asset(
                                            AppAssets.googleLogoAnimation,
                                            width: AppSizes.iconSizeLarge,
                                            height: AppSizes.iconSizeLarge,
                                            controller: _googleLottieController,
                                            repeat: true,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              AppLogger.error(
                                                'Error loading Lottie: ${AppAssets.googleLogoAnimation}',
                                                error: error,
                                                stackTrace: stackTrace,
                                              );
                                              return Icon(
                                                Icons.g_mobiledata,
                                                color: AppColors.primaryColor,
                                                size: AppSizes.iconSizeLarge,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: AppSizes.spaceLarge,
                                      ),
                                      // Bouton Facebook
                                      VirusButton(
                                        onPressed: _signInWithFacebook,
                                        borderRadius: AppSizes.buttonRadius,
                                        borderColor:
                                            AppColors.secondaryAccentColor,
                                        elevation:
                                            AppSizes.defaultElevation / 2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                            AppSizes.paddingMedium,
                                          ),
                                          child: Lottie.asset(
                                            AppAssets.facebookLogoAnimation,
                                            width: AppSizes.iconSizeLarge,
                                            height: AppSizes.iconSizeLarge,
                                            controller:
                                                _facebookLottieController,
                                            repeat: true,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              AppLogger.error(
                                                'Error loading Lottie: ${AppAssets.facebookLogoAnimation}',
                                                error: error,
                                                stackTrace: stackTrace,
                                              );
                                              return Icon(
                                                Icons.facebook,
                                                color: AppColors.primaryColor,
                                                size: AppSizes.iconSizeLarge,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: AppSizes.spaceExtraLarge),

                            // Lien vers la page d'inscription
                            FadeInUp(
                              delay: AppAnimations.durationExtraLong,
                              duration: AppAnimations.durationLong,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FuturisticText(
                                    AppStrings.addNewAccount,
                                    color: AppColors.textColorSecondary,
                                    size: AppSizes.fontSizeSmall,
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => context.goNamed(
                                          RouteNames.register,
                                        ),
                                    child: FuturisticText(
                                      AppStrings.registerButton,
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      size: AppSizes.fontSizeSmall,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Bouton Retour (en bas de l'écran)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FadeInUp(
                      delay: AppAnimations.durationExtraLong,
                      duration: AppAnimations.durationLong,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: AppSizes.paddingLarge,
                        ),
                        child: VirusButton(
                          onPressed: () => context.pop(),
                          borderRadius: AppSizes.buttonRadius,
                          borderColor: AppColors.secondaryAccentColor,
                          elevation: AppSizes.defaultElevation / 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.buttonPaddingHorizontal,
                              vertical: AppSizes.buttonPaddingVertical,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Lottie.asset(
                                  AppAssets.backArrowAnimation,
                                  width: AppSizes.iconSizeMedium,
                                  height: AppSizes.iconSizeMedium,
                                  controller: _backArrowController,
                                  repeat: true,
                                  errorBuilder: (context, error, stackTrace) {
                                    AppLogger.error(
                                      'Error loading Lottie: ${AppAssets.backArrowAnimation}',
                                      error: error,
                                      stackTrace: stackTrace,
                                    );
                                    return Icon(
                                      Icons.arrow_back,
                                      color: AppColors.textColorPrimary,
                                    );
                                  },
                                ),
                                const SizedBox(width: AppSizes.spaceSmall),
                                FuturisticText(
                                  AppStrings.back,
                                  color: AppColors.textColorSecondary,
                                  size: AppSizes.fontSizeMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
