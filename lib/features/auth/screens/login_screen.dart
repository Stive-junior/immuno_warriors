import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';
import 'package:email_validator/email_validator.dart';

// Core Imports
import 'package:immuno_warriors/core/constants/app_assets.dart';
import 'package:immuno_warriors/core/constants/app_strings.dart';
import 'package:immuno_warriors/core/constants/app_animations.dart';
import 'package:immuno_warriors/core/routes/route_names.dart';
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
import 'package:immuno_warriors/shared/widgets/buttons/holographic_button.dart';
import 'package:immuno_warriors/shared/widgets/buttons/animated_icon_button.dart';
import 'package:immuno_warriors/shared/widgets/feedback/snackbar_manager.dart';
import 'package:immuno_warriors/shared/widgets/common/theme_selection_dialog.dart';

// Feature-specific Imports
import 'package:immuno_warriors/features/auth/providers/auth_provider.dart';

/// `LoginScreen` : Écran de connexion pour les utilisateurs existants.
///
/// Permet la connexion via email/mot de passe, avec option de réinitialisation de mot de passe
/// et placeholders pour la connexion sociale (Google, Facebook). Intègre des animations
/// futuristes et une interface utilisateur immersive.
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
  late AnimationController _backArrowController;

  @override
  void initState() {
    super.initState();
    _initAnimationControllers();
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
        duration: AppAnimations.iconAnimationDuration,
        vsync: this,
      )..repeat(reverse: true);
      _helpIconController = AnimationController(
        duration: AppAnimations.iconAnimationDuration,
        vsync: this,
      )..repeat();
      _backArrowController = AnimationController(
        duration: AppAnimations.iconAnimationDuration,
        vsync: this,
      )..repeat();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Échec de l\'initialisation des contrôleurs d\'animation',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  void dispose() {
    _scanController.dispose();
    _pulseController.dispose();
    _themeIconController.dispose();
    _helpIconController.dispose();
    _backArrowController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      final authNotifier = ref.read(authProvider.notifier);
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      await authNotifier.signIn(email: email, password: password);

      if (!mounted) return;
      final authState = ref.read(authProvider);

      if (authState.isSignedIn) {
        AppLogger.info('Utilisateur $email connecté avec succès.');
        SnackbarManager.showSnackbar(
          context,
          AppStrings.loginSuccess,
          backgroundColor: AppColors.successColor,
          textColor: AppColors.textColorPrimary,
        );
        context.goNamed(RouteNames.dashboard, extra: authState.userId);
      } else {
        AppLogger.error('Échec de la connexion: ${authState.errorMessage}');
        SnackbarManager.showSnackbar(
          context,
          authState.errorMessage ?? AppStrings.loginFailed,
          backgroundColor: AppColors.errorColor,
          textColor: AppColors.textColorPrimary,
        );
      }
    }
  }

  Future<void> _handleForgotPassword() async {
    final email = _emailController.text.trim();
    if (!EmailValidator.validate(email)) {
      SnackbarManager.showSnackbar(
        context,
        AppStrings.invalidEmail,
        backgroundColor: AppColors.errorColor,
        textColor: AppColors.textColorPrimary,
      );
      return;
    }

    try {
      await ref
          .read(authProvider.notifier)
          .sendPasswordResetEmail(email: email);
      SnackbarManager.showSnackbar(
        context,
        AppStrings.passwordResetEmailSent,
        backgroundColor: AppColors.successColor,
        textColor: AppColors.textColorPrimary,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Erreur lors de l\'envoi de l\'email de réinitialisation',
        error: e,
        stackTrace: stackTrace,
      );
      SnackbarManager.showSnackbar(
        context,
        AppStrings.passwordResetFailed,
        backgroundColor: AppColors.errorColor,
        textColor: AppColors.textColorPrimary,
      );
    }
  }

  void _signInWithGoogle() {
    AppLogger.info('Connexion avec Google pressée.');
    SnackbarManager.showSnackbar(
      context,
      AppStrings.socialLoginNotImplemented,
      backgroundColor: AppColors.warningColor,
      textColor: AppColors.textColorPrimary,
    );
  }

  void _signInWithFacebook() {
    AppLogger.info('Connexion avec Facebook pressée.');
    SnackbarManager.showSnackbar(
      context,
      AppStrings.socialLoginNotImplemented,
      backgroundColor: AppColors.warningColor,
      textColor: AppColors.textColorPrimary,
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => ThemeSelectionDialog(
            themeIconController: _themeIconController,
            onThemeSelected: (themeMode) {
              AppLogger.info('Thème changé pour : $themeMode');
            },
          ),
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
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Lottie.asset(
              AppAssets.backgroundAnimation,
              fit: BoxFit.cover,
              repeat: true,
              errorBuilder: (context, error, stackTrace) {
                AppLogger.error(
                  'Erreur de chargement de l\'animation Lottie',
                  error: error,
                  stackTrace: stackTrace,
                );
                return Container(color: AppColors.backgroundColor);
              },
            ),
          ),
          AdvancedScanEffect(
            controller: _scanController,
            scanColor: AppColors.virusGreen.withValues(red: 0.3),
            lineWidth: 1.0,
            blendMode: BlendMode.plus,
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * (isLandscape ? 0.05 : 0.08),
                vertical: screenHeight * (isLandscape ? 0.08 : 0.12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInDown(
                    duration: AppAnimations.fadeInDuration,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AnimatedIconButton(
                          animationAsset: AppAssets.backArrowAnimation,
                          tooltip: AppStrings.back,
                          onPressed:
                              () => context.goNamed(
                                RouteNames.profileAuthOptions,
                              ),
                          backgroundColor: Colors.blue.withValues(red: 0.2),
                          errorBuilder: (context, error, stackTrace) {
                            AppLogger.error(
                              'Erreur de chargement de Lottie: ${AppAssets.backArrowAnimation}',
                              error: error,
                              stackTrace: stackTrace,
                            );
                            return Icon(
                              Icons.arrow_back,
                              color: AppColors.textColorPrimary,
                            );
                          },
                        ),
                        Row(
                          children: [
                            AnimatedIconButton(
                              animationAsset: AppAssets.helpIconAnimation,
                              tooltip: AppStrings.help,
                              onPressed: () => context.goNamed(RouteNames.help),
                              backgroundColor: Colors.blue.withValues(
                                blue: 0.2,
                              ),
                              errorBuilder: (context, error, stackTrace) {
                                AppLogger.error(
                                  'Erreur de chargement de Lottie: ${AppAssets.helpIconAnimation}',
                                  error: error,
                                  stackTrace: stackTrace,
                                );
                                return Icon(
                                  Icons.help,
                                  color: AppColors.textColorPrimary,
                                );
                              },
                            ),
                            const SizedBox(width: 12),
                            AnimatedIconButton(
                              animationAsset: AppAssets.themeIconAnimation,
                              tooltip: AppStrings.theme,
                              onPressed: () => _showThemeDialog(context),
                              backgroundColor: Colors.blue.withValues(
                                blue: 0.2,
                              ),
                              errorBuilder: (context, error, stackTrace) {
                                AppLogger.error(
                                  'Erreur de chargement de Lottie: ${AppAssets.themeIconAnimation}',
                                  error: error,
                                  stackTrace: stackTrace,
                                );
                                return Icon(
                                  Icons.palette,
                                  color: AppColors.textColorPrimary,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          FadeInUp(
                            duration: AppAnimations.fadeInDuration,
                            child: PulseWidget(
                              controller: _pulseController,
                              minScale: 0.95,
                              maxScale: 1.05,
                              child: FuturisticText(
                                AppStrings.loginTitle,
                                size: isLandscape ? 36 : 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.04),
                          FadeInUp(
                            delay: AppAnimations.fadeInDuration,
                            duration: AppAnimations.fadeInDuration,
                            child: NeonCard(
                              glowColor: AppColors.virusGreen,
                              intensity: 0.3,
                              borderRadius: 16,
                              borderWidth: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(24),
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
                                          AppAssets.emailIconAnimation,
                                          width: 24,
                                          height: 24,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            AppLogger.error(
                                              'Erreur de chargement de Lottie: ${AppAssets.emailIconAnimation}',
                                              error: error,
                                              stackTrace: stackTrace,
                                            );
                                            return Icon(
                                              Icons.email,
                                              color:
                                                  AppColors.textColorSecondary,
                                            );
                                          },
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return AppStrings.invalidEmail;
                                          }
                                          if (!EmailValidator.validate(value)) {
                                            return AppStrings.invalidEmail;
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      InputField(
                                        controller: _passwordController,
                                        labelText: AppStrings.passwordHint,
                                        obscureText: _obscurePassword,
                                        prefixIcon: Lottie.asset(
                                          AppAssets.lockAnimation,
                                          width: 24,
                                          height: 24,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            AppLogger.error(
                                              'Erreur de chargement de Lottie: ${AppAssets.lockAnimation}',
                                              error: error,
                                              stackTrace: stackTrace,
                                            );
                                            return Icon(
                                              Icons.lock,
                                              color:
                                                  AppColors.textColorSecondary,
                                            );
                                          },
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Lottie.asset(
                                            _obscurePassword
                                                ? AppAssets.eyeClosedAnimation
                                                : AppAssets.eyeOpenAnimation,
                                            width: 24,
                                            height: 24,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              AppLogger.error(
                                                'Erreur de chargement de Lottie: ${_obscurePassword ? AppAssets.eyeClosedAnimation : AppAssets.eyeOpenAnimation}',
                                                error: error,
                                                stackTrace: stackTrace,
                                              );
                                              return Icon(
                                                _obscurePassword
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
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
                                          if (value == null || value.isEmpty) {
                                            return AppStrings.invalidPassword;
                                          }
                                          if (value.length < 6) {
                                            return AppStrings.weakPassword;
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: _handleForgotPassword,
                                          child: FuturisticText(
                                            AppStrings.forgotPassword,
                                            color: AppColors.primaryColor,
                                            size: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      VirusButton(
                                        onPressed:
                                            authLoading ? null : _handleSignIn,
                                        width: double.infinity,
                                        child:
                                            authLoading
                                                ? const CircularProgressIndicator(
                                                  color:
                                                      AppColors
                                                          .textColorPrimary,
                                                )
                                                : FuturisticText(
                                                  AppStrings.loginButton,
                                                  size: 16,
                                                  color:
                                                      AppColors
                                                          .textColorPrimary,
                                                ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.04),
                          FadeInUp(
                            delay: Duration(
                              milliseconds:
                                  AppAnimations.fadeInDuration.inMilliseconds +
                                  200,
                            ),
                            duration: AppAnimations.fadeInDuration,
                            child: Column(
                              children: [
                                FuturisticText(
                                  AppStrings.orConnectWith,
                                  color: AppColors.textColorSecondary,
                                  size: 16,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    VirusButton(
                                      onPressed: _signInWithGoogle,
                                      width: 60,
                                      child: Lottie.asset(
                                        AppAssets.googleLogoAnimation,
                                        width: 24,
                                        height: 24,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          AppLogger.error(
                                            'Erreur de chargement de Lottie: ${AppAssets.googleLogoAnimation}',
                                            error: error,
                                            stackTrace: stackTrace,
                                          );
                                          return Icon(
                                            Icons.g_mobiledata,
                                            color: AppColors.textColorPrimary,
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    VirusButton(
                                      onPressed: _signInWithFacebook,
                                      width: 60,
                                      child: Lottie.asset(
                                        AppAssets.facebookLogoAnimation,
                                        width: 24,
                                        height: 24,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          AppLogger.error(
                                            'Erreur de chargement de Lottie: ${AppAssets.facebookLogoAnimation}',
                                            error: error,
                                            stackTrace: stackTrace,
                                          );
                                          return Icon(
                                            Icons.facebook,
                                            color: AppColors.textColorPrimary,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.04),
                          FadeInUp(
                            delay: Duration(
                              milliseconds:
                                  AppAnimations.fadeInDuration.inMilliseconds +
                                  400,
                            ),
                            duration: AppAnimations.fadeInDuration,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FuturisticText(
                                  AppStrings.addNewAccount,
                                  color: AppColors.textColorSecondary,
                                  size: 14,
                                ),
                                TextButton(
                                  onPressed:
                                      () =>
                                          context.goNamed(RouteNames.register),
                                  child: FuturisticText(
                                    AppStrings.registerButton,
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    size: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
