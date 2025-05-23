import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';
import 'package:immuno_warriors/core/constants/app_assets.dart';
import 'package:immuno_warriors/core/constants/app_strings.dart';
import 'package:immuno_warriors/core/routes/route_names.dart';
import 'package:immuno_warriors/features/auth/presentation/providers/auth_provider.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/shared/ui/futuristic_text.dart';
import 'package:immuno_warriors/shared/widgets/cards/glassmorphism_card.dart';
import 'package:immuno_warriors/shared/widgets/forms/input_field.dart';
import 'package:immuno_warriors/shared/widgets/buttons/neuomorphic_button.dart';
import 'package:immuno_warriors/shared/ui/screen_utils.dart';
import 'package:immuno_warriors/shared/widgets/animations/scan_effect.dart';
import 'package:immuno_warriors/shared/widgets/animations/pulse_widget.dart';
import 'package:immuno_warriors/shared/widgets/animations/animated_border.dart';
import 'package:immuno_warriors/shared/widgets/buttons/animated_icon_button.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

/// LoginScreen : Écran de connexion pour les utilisateurs existants.
///
/// Ce widget permet aux utilisateurs de se connecter avec leur email et mot de passe,
/// ou via des options de connexion sociale (Google, Facebook - à implémenter).
/// Il intègre des animations futuristes et une interface utilisateur immersive.
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

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanController.dispose();
    _pulseController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Gère le processus de connexion de l'utilisateur.
  ///
  /// Valide le formulaire et tente de connecter l'utilisateur via le service d'authentification.
  Future<void> _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      final authNotifier = ref.read(authProvider.notifier);
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      await authNotifier.signIn(email: email, password: password);

      if (!mounted) return; // Vérifie si le widget est toujours monté après l'opération asynchrone
      final authState = ref.read(authProvider);

      if (authState.isSignedIn) {
        AppLogger.info(
          'User $email signed in successfully. Navigating to dashboard.',
        );
        // Naviguer vers le tableau de bord après une connexion réussie
        context.goNamed(RouteNames.dashboard, extra: authState.user?.id);
      } else {
        AppLogger.error('Sign in failed: ${authState.errorMessage}');
        // Afficher un message d'erreur à l'utilisateur (ex: SnackBar, Dialog)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authState.errorMessage ?? AppStrings.loginFailed),
            backgroundColor: AppColors.errorColor, // Utilisation de la nouvelle couleur
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
          color: AppColors.textColorPrimary, // Utilisation de la nouvelle couleur
        ),
        backgroundColor: AppColors.interfaceColorDark, // Utilisation de la nouvelle couleur
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
          color: AppColors.textColorPrimary, // Utilisation de la nouvelle couleur
        ),
        backgroundColor: AppColors.interfaceColorDark, // Utilisation de la nouvelle couleur
      ),
    );
  }

  /// Affiche une boîte de dialogue pour la sélection du thème.
  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.secondaryColor, // Utilisation de la nouvelle couleur
          title: FuturisticText(
            AppStrings.theme,
            color: AppColors.primaryColor, // Utilisation de la nouvelle couleur
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: FuturisticText(
                  AppStrings.lightTheme,
                  color: AppColors.textColorPrimary, // Utilisation de la nouvelle couleur
                ),
                onTap: () {
                  AppLogger.info('Light theme selected.');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: FuturisticText(
                  AppStrings.darkTheme,
                  color: AppColors.textColorPrimary, // Utilisation de la nouvelle couleur
                ),
                onTap: () {
                  AppLogger.info('Dark theme selected.');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: FuturisticText(
                  AppStrings.systemTheme,
                  color: AppColors.textColorPrimary, // Utilisation de la nouvelle couleur
                ),
                onTap: () {
                  AppLogger.info('System theme selected.');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Animated Background
          Positioned.fill(
            child: Lottie.asset(
              AppAssets.backgroundAnimation,
              fit: BoxFit.cover,
              repeat: true,
              errorBuilder: (context, error, stackTrace) {
                AppLogger.error(
                  'Error loading background Lottie: ${AppAssets.backgroundAnimation}',
                  error: error,
                  stackTrace: stackTrace,
                );
                return Container(color: AppColors.backgroundColor); // Utilisation de la nouvelle couleur
              },
            ),
          ),

          // 2. Scan Effect Overlay
          Positioned.fill(
            child: AdvancedScanEffect(
              controller: _scanController,
              scanColor: AppColors.primaryColor.withOpacity(0.3), // Utilisation de la nouvelle couleur
              lineWidth: 3.0,
              blendMode: BlendMode.plus,
            ),
          ),

          // 3. Main Content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * (isLandscape ? 0.04 : 0.06),
              vertical: screenHeight * (isLandscape ? 0.06 : 0.1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Navigation Bar
                FadeInDown(
                  duration: const Duration(milliseconds: 700),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Animated App Title
                      PulseWidget(
                        controller: _pulseController,
                        child: AnimatedBorder(
                          animationController: _pulseController,
                          width: screenWidth * 0.3,
                          height: 40,
                          borderWidth: 2,
                          borderColor: AppColors.primaryColor.withOpacity(0.8), // Utilisation de la nouvelle couleur
                          borderRadius: BorderRadius.circular(8),
                          child: Center(
                            child: FuturisticText(
                              AppStrings.appName,
                              size: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor, // Utilisation de la nouvelle couleur
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          AnimatedIconButton(
                            animationAsset: AppAssets.helpIconAnimation,
                            tooltip: AppStrings.help,
                            onPressed: () => context.goNamed(RouteNames.help),
                            backgroundColor: AppColors.primaryAccentColor.withOpacity(0.2), // Utilisation de la nouvelle couleur
                            errorBuilder: (context, error, stackTrace) {
                              AppLogger.error(
                                'Error loading Lottie: ${AppAssets.helpIconAnimation}',
                                error: error,
                                stackTrace: stackTrace,
                              );
                              return Icon(
                                Icons.help,
                                color: AppColors.textColorPrimary, // Utilisation de la nouvelle couleur
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                          AnimatedIconButton(
                            animationAsset: AppAssets.themeIconAnimation,
                            tooltip: AppStrings.theme,
                            onPressed: () => _showThemeDialog(context),
                            backgroundColor: AppColors.primaryAccentColor.withOpacity(0.2), // Utilisation de la nouvelle couleur
                            errorBuilder: (context, error, stackTrace) {
                              AppLogger.error(
                                'Error loading Lottie: ${AppAssets.themeIconAnimation}',
                                error: error,
                                stackTrace: stackTrace,
                              );
                              return Icon(
                                Icons.palette,
                                color: AppColors.textColorPrimary, // Utilisation de la nouvelle couleur
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                          AnimatedIconButton(
                            animationAsset: AppAssets.geminiIconAnimation,
                            tooltip: AppStrings.gemini,
                            onPressed: () => context.goNamed(RouteNames.gemini),
                            backgroundColor: AppColors.primaryAccentColor.withOpacity(0.2), // Utilisation de la nouvelle couleur
                            errorBuilder: (context, error, stackTrace) {
                              AppLogger.error(
                                'Error loading Lottie: ${AppAssets.geminiIconAnimation}',
                                error: error,
                                stackTrace: stackTrace,
                              );
                              return Icon(
                                Icons.psychology,
                                color: AppColors.textColorPrimary, // Utilisation de la nouvelle couleur
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
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Titre de l'écran de connexion
                          FadeInDown(
                            duration: const Duration(milliseconds: 600),
                            child: FuturisticText(
                              AppStrings.loginTitle,
                              size: isLandscape ? 36 : 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor, // Utilisation de la nouvelle couleur
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.04),

                          FadeInUp(
                            duration: const Duration(milliseconds: 700),
                            child: GlassmorphismCard(
                              blur: 15,
                              opacity: 0.2,
                              borderRadius: BorderRadius.circular(16),
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
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
                                          width: 24,
                                          height: 24,
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
                                              color: AppColors.textColorPrimary, // Utilisation de la nouvelle couleur
                                            );
                                          },
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
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
                                      const SizedBox(height: 20),
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
                                              'Error loading Lottie: ${AppAssets.lockAnimation}',
                                              error: error,
                                              stackTrace: stackTrace,
                                            );
                                            return Icon(
                                              Icons.lock,
                                              color: AppColors.textColorPrimary, // Utilisation de la nouvelle couleur
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
                                                'Error loading Lottie: ${_obscurePassword ? AppAssets.eyeClosedAnimation : AppAssets.eyeOpenAnimation}',
                                                error: error,
                                                stackTrace: stackTrace,
                                              );
                                              return Icon(
                                                _obscurePassword
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: AppColors.textColorPrimary, // Utilisation de la nouvelle couleur
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
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 30),
                                      NeuomorphicButton(
                                        onPressed:
                                        authLoading ? null : _handleSignIn,
                                        borderRadius: BorderRadius.circular(12),
                                        depth: 8,
                                        intensity: 0.6,
                                        blur: 15,
                                        color: AppColors.primaryColor, // Utilisation de la nouvelle couleur
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          child:
                                          authLoading
                                              ? CircularProgressIndicator(
                                            color:
                                            AppColors.textColorPrimary, // Utilisation de la nouvelle couleur
                                          )
                                              : Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            children: [
                                              Lottie.asset(
                                                AppAssets
                                                    .signInAnimation,
                                                width: 24,
                                                height: 24,
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
                                                    color: AppColors
                                                        .textColorPrimary, // Utilisation de la nouvelle couleur
                                                  );
                                                },
                                              ),
                                              const SizedBox(
                                                  width: 12),
                                              FuturisticText(
                                                AppStrings
                                                    .loginButton,
                                                fontWeight:
                                                FontWeight.w600,
                                                color: AppColors
                                                    .textColorPrimary, // Utilisation de la nouvelle couleur
                                                size: 18,
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
                          SizedBox(height: screenHeight * 0.04),

                          // Option de connexion sociale
                          FadeInUp(
                            delay: const Duration(milliseconds: 800),
                            duration: const Duration(milliseconds: 700),
                            child: Column(
                              children: [
                                FuturisticText(
                                  AppStrings.orConnectWith,
                                  color: AppColors.textColorSecondary, // Utilisation de la nouvelle couleur
                                  size: 16,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Bouton Google
                                    NeuomorphicButton(
                                      onPressed: _signInWithGoogle,
                                      borderRadius: BorderRadius.circular(12),
                                      depth: 6,
                                      intensity: 0.5,
                                      blur: 10,
                                      color: AppColors.secondaryColor, // Utilisation de la nouvelle couleur
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Lottie.asset(
                                          AppAssets.googleLogoAnimation,
                                          width: 30,
                                          height: 30,
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
                                            return Image.asset(
                                              'https://placehold.co/30x30/ffffff/000000?text=G',
                                            ); // Fallback image
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    // Bouton Facebook
                                    NeuomorphicButton(
                                      onPressed: _signInWithFacebook,
                                      borderRadius: BorderRadius.circular(12),
                                      depth: 6,
                                      intensity: 0.5,
                                      blur: 10,
                                      color: AppColors.secondaryColor, // Utilisation de la nouvelle couleur
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Lottie.asset(
                                          AppAssets.facebookLogoAnimation,
                                          width: 30,
                                          height: 30,
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
                                            return Image.asset(
                                              'https://placehold.co/30x30/3b5998/ffffff?text=f',
                                            ); // Fallback image
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.04),

                          // Lien vers la page d'inscription
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FuturisticText(
                                AppStrings.alreadyHaveAccount,
                                color: AppColors.textColorSecondary, // Utilisation de la nouvelle couleur
                                size: 14,
                              ),
                              TextButton(
                                onPressed: () =>
                                    context.goNamed(RouteNames.register),
                                child: FuturisticText(
                                  AppStrings.signInHere,
                                  color: AppColors.primaryColor, // Utilisation de la nouvelle couleur
                                  fontWeight: FontWeight.bold,
                                  size: 14,
                                ),
                              ),
                            ],
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
                    delay: const Duration(milliseconds: 1000),
                    duration: const Duration(milliseconds: 600),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: NeuomorphicButton(
                        onPressed: () => context.pop(), // Revenir à la page précédente
                        borderRadius: BorderRadius.circular(10),
                        depth: 6,
                        intensity: 0.4,
                        blur: 8,
                        color: AppColors.secondaryColor, // Utilisation de la nouvelle couleur
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Lottie.asset(
                                AppAssets.backArrowAnimation,
                                width: 30,
                                height: 30,
                                errorBuilder: (context, error, stackTrace) {
                                  AppLogger.error('Error loading Lottie: ${AppAssets.backArrowAnimation}', error: error, stackTrace: stackTrace);
                                  return Icon(Icons.arrow_back, color: AppColors.textColorPrimary); // Utilisation de la nouvelle couleur
                                },
                              ),
                              const SizedBox(width: 8),
                              FuturisticText(
                                AppStrings.back,
                                color: AppColors.textColorSecondary, // Utilisation de la nouvelle couleur
                                size: 16,
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
        ],
      ),
    );
  }
}

