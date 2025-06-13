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
import 'package:immuno_warriors/shared/widgets/cards/glassmorphism_card.dart';
import 'package:immuno_warriors/shared/widgets/forms/input_field.dart';
import 'package:immuno_warriors/shared/widgets/animations/scan_effect.dart';
import 'package:immuno_warriors/shared/widgets/animations/pulse_widget.dart';
import 'package:immuno_warriors/shared/widgets/buttons/holographic_button.dart';
import 'package:immuno_warriors/shared/widgets/buttons/animated_icon_button.dart';
import 'package:immuno_warriors/shared/widgets/feedback/snackbar_manager.dart';
import 'package:immuno_warriors/shared/widgets/common/theme_selection_dialog.dart';

// Feature-specific Imports
import 'package:immuno_warriors/features/auth/providers/auth_provider.dart';

/// `RegisterScreen` : Écran d'inscription pour créer un nouveau compte utilisateur.
///
/// Gère un flux en deux étapes : sélection d'avatar, puis formulaire d'inscription
/// (nom d'utilisateur, email, mot de passe). Inclut des options de connexion sociale
/// et des animations futuristes.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _showAvatarSelection = true;
  String? _selectedAvatarUrl;

  late AnimationController _scanController;
  late AnimationController _pulseController;
  late AnimationController _formSlideController;
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
      _formSlideController = AnimationController(
        duration: AppAnimations.fadeInDuration,
        vsync: this,
      );
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
    _formSlideController.dispose();
    _themeIconController.dispose();
    _helpIconController.dispose();
    _backArrowController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _selectAvatar(String avatarUrl) {
    setState(() {
      _selectedAvatarUrl = avatarUrl;
      _showAvatarSelection = false;
    });
    _formSlideController.forward();
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate() && _selectedAvatarUrl != null) {
      final authNotifier = ref.read(authProvider.notifier);
      final username = _usernameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      await authNotifier.signUp(
        email: email,
        password: password,
        username: username,
        avatarUrl: _selectedAvatarUrl,
      );

      if (!mounted) return;
      final authState = ref.read(authProvider);

      if (authState.isSignedIn) {
        AppLogger.info('Utilisateur $email inscrit avec succès.');
        _showSuccessDialog(context, username);
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            context.goNamed(RouteNames.dashboard, extra: authState.userId);
          }
        });
      } else {
        AppLogger.error('Échec de l\'inscription: ${authState.errorMessage}');
        SnackbarManager.showSnackbar(
          context,
          authState.errorMessage ?? AppStrings.registerFailed,
          backgroundColor: AppColors.errorColor,
          textColor: AppColors.textColorPrimary,
        );
      }
    } else if (_selectedAvatarUrl == null) {
      SnackbarManager.showSnackbar(
        context,
        AppStrings.selectAvatar,
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

  void _showSuccessDialog(BuildContext context, String username) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundColor.withValues(blue: 0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.virusGreen, width: 2),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                AppAssets.successAnimation,
                width: 100,
                height: 100,
                repeat: false,
                errorBuilder: (context, error, stackTrace) {
                  AppLogger.error(
                    'Erreur de chargement de Lottie: ${AppAssets.successAnimation}',
                    error: error,
                    stackTrace: stackTrace,
                  );
                  return Icon(
                    Icons.check_circle,
                    color: AppColors.successColor,
                    size: 80,
                  );
                },
              ),
              const SizedBox(height: 16),
              FuturisticText(
                AppStrings.profileCreated,
                size: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.successColor,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              FuturisticText(
                '${AppStrings.welcomeToImmunoWarriors} $username!',
                size: 16,
                color: AppColors.textColorPrimary,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvatarSelectionSection(
    double screenWidth,
    double screenHeight,
    bool isLandscape,
  ) {
    return FadeInUp(
      duration: AppAnimations.fadeInDuration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PulseWidget(
            controller: _pulseController,
            minScale: 0.95,
            maxScale: 1.05,
            child: FuturisticText(
              AppStrings.chooseYourAvatar,
              size: isLandscape ? 36 : 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: screenHeight * 0.04),
          SizedBox(
            height: isLandscape ? screenHeight * 0.5 : screenHeight * 0.4,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: AppAssets.availableAvatars.length,
              itemBuilder: (context, index) {
                final avatarPath = AppAssets.availableAvatars[index];
                return VirusButton(
                  onPressed: () => _selectAvatar(avatarPath),
                  width: isLandscape ? screenHeight * 0.2 : screenWidth * 0.3,
                  child: Lottie.asset(
                    avatarPath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      AppLogger.error(
                        'Erreur de chargement de Lottie avatar: $avatarPath',
                        error: error,
                        stackTrace: stackTrace,
                      );
                      return Icon(
                        Icons.person,
                        color: AppColors.textColorPrimary,
                        size: 60,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationFormSection(
    double screenWidth,
    double screenHeight,
    bool isLandscape,
    bool authLoading,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(_formSlideController),
      child: FadeTransition(
        opacity: _formSlideController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PulseWidget(
              controller: _pulseController,
              minScale: 0.95,
              maxScale: 1.05,
              child: FuturisticText(
                AppStrings.registerTitle,
                size: isLandscape ? 36 : 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            GlassmorphismCard(
              blur: 15,
              opacity: 0.2,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      InputField(
                        controller: _usernameController,
                        labelText: AppStrings.enterUsername,
                        keyboardType: TextInputType.text,
                        prefixIcon: Lottie.asset(
                          AppAssets.userAvatarAnimation,
                          width: 24,
                          height: 24,
                          errorBuilder: (context, error, stackTrace) {
                            AppLogger.error(
                              'Erreur de chargement de Lottie: ${AppAssets.userAvatarAnimation}',
                              error: error,
                              stackTrace: stackTrace,
                            );
                            return Icon(
                              Icons.person,
                              color: AppColors.textColorPrimary,
                            );
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppStrings.invalidUsername;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      InputField(
                        controller: _emailController,
                        labelText: AppStrings.emailHint,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Lottie.asset(
                          AppAssets.emailIconAnimation,
                          width: 24,
                          height: 24,
                          errorBuilder: (context, error, stackTrace) {
                            AppLogger.error(
                              'Erreur de chargement de Lottie: ${AppAssets.emailIconAnimation}',
                              error: error,
                              stackTrace: stackTrace,
                            );
                            return Icon(
                              Icons.email,
                              color: AppColors.textColorPrimary,
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
                          errorBuilder: (context, error, stackTrace) {
                            AppLogger.error(
                              'Erreur de chargement de Lottie: ${AppAssets.lockAnimation}',
                              error: error,
                              stackTrace: stackTrace,
                            );
                            return Icon(
                              Icons.lock,
                              color: AppColors.textColorPrimary,
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
                            errorBuilder: (context, error, stackTrace) {
                              AppLogger.error(
                                'Erreur de chargement de Lottie: ${_obscurePassword ? AppAssets.eyeClosedAnimation : AppAssets.eyeOpenAnimation}',
                                error: error,
                                stackTrace: stackTrace,
                              );
                              return Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.textColorPrimary,
                              );
                            },
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
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
                      InputField(
                        controller: _confirmPasswordController,
                        labelText: AppStrings.confirmPasswordHint,
                        obscureText: _obscureConfirmPassword,
                        prefixIcon: Lottie.asset(
                          AppAssets.lockAnimation,
                          width: 24,
                          height: 24,
                          errorBuilder: (context, error, stackTrace) {
                            AppLogger.error(
                              'Erreur de chargement de Lottie: ${AppAssets.lockAnimation}',
                              error: error,
                              stackTrace: stackTrace,
                            );
                            return Icon(
                              Icons.lock_reset,
                              color: AppColors.textColorPrimary,
                            );
                          },
                        ),
                        suffixIcon: IconButton(
                          icon: Lottie.asset(
                            _obscureConfirmPassword
                                ? AppAssets.eyeClosedAnimation
                                : AppAssets.eyeOpenAnimation,
                            width: 24,
                            height: 24,
                            errorBuilder: (context, error, stackTrace) {
                              AppLogger.error(
                                'Erreur de chargement de Lottie: ${_obscureConfirmPassword ? AppAssets.eyeClosedAnimation : AppAssets.eyeOpenAnimation}',
                                error: error,
                                stackTrace: stackTrace,
                              );
                              return Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.textColorPrimary,
                              );
                            },
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppStrings.invalidPassword;
                          }
                          if (value != _passwordController.text) {
                            return AppStrings.passwordMismatch;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      VirusButton(
                        onPressed: authLoading ? null : _handleSignUp,
                        width: double.infinity,
                        child:
                            authLoading
                                ? const CircularProgressIndicator(
                                  color: AppColors.textColorPrimary,
                                )
                                : FuturisticText(
                                  AppStrings.registerButton,
                                  size: 18,
                                  color: AppColors.textColorPrimary,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            FadeInUp(
              delay: Duration(
                milliseconds: AppAnimations.fadeInDuration.inMilliseconds + 200,
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
                          errorBuilder: (context, error, stackTrace) {
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
                          errorBuilder: (context, error, stackTrace) {
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
                milliseconds: AppAnimations.fadeInDuration.inMilliseconds + 400,
              ),
              duration: AppAnimations.fadeInDuration,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FuturisticText(
                    AppStrings.alreadyHaveAccount,
                    color: AppColors.textColorSecondary,
                    size: 14,
                  ),
                  TextButton(
                    onPressed: () => context.goNamed(RouteNames.login),
                    child: FuturisticText(
                      AppStrings.signInHere,
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
            scanColor: AppColors.virusGreen.withValues(blue: 0.3),
            lineWidth: 2,
            blendMode: BlendMode.plus,
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * (isLandscape ? 0.05 : 0.08),
                vertical: screenHeight * (isLandscape ? 0.10 : 0.16),
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
                          onPressed: () {
                            if (!_showAvatarSelection) {
                              _formSlideController.reverse().then((_) {
                                setState(() {
                                  _showAvatarSelection = true;
                                  _selectedAvatarUrl = null;
                                });
                              });
                            } else {
                              context.goNamed(RouteNames.profileAuthOptions);
                            }
                          },
                          backgroundColor: Colors.blue.withValues(blue: 0.2),
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
                      child: AnimatedSwitcher(
                        duration: AppAnimations.fadeInDuration,
                        transitionBuilder: (
                          Widget child,
                          Animation<double> animation,
                        ) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child:
                            _showAvatarSelection
                                ? KeyedSubtree(
                                  key: const ValueKey('avatar_selection'),
                                  child: _buildAvatarSelectionSection(
                                    screenWidth,
                                    screenHeight,
                                    isLandscape,
                                  ),
                                )
                                : KeyedSubtree(
                                  key: const ValueKey('registration_form'),
                                  child: _buildRegistrationFormSection(
                                    screenWidth,
                                    screenHeight,
                                    isLandscape,
                                    authLoading,
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
