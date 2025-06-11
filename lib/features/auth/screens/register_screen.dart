import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';
import 'package:immuno_warriors/core/constants/app_assets.dart';
import 'package:immuno_warriors/core/constants/app_strings.dart';
import 'package:immuno_warriors/core/routes/route_names.dart';
import 'package:immuno_warriors/features/auth/providers/auth_provider.dart';
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

/// RegisterScreen : Écran d'inscription pour créer un nouveau compte utilisateur.
///
/// Ce widget gère un flux d'inscription en deux étapes :
/// 1. Sélection de l'avatar.
/// 2. Saisie des informations de compte (nom d'utilisateur, email, mot de passe).
/// Il inclut également des options de connexion sociale et des animations futuristes.
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

  // État pour contrôler l'affichage des sections
  bool _showAvatarSelection = true;
  String? _selectedAvatarUrl; // URL de l'avatar sélectionné

  late AnimationController _scanController;
  late AnimationController _pulseController;
  late AnimationController
  _formSlideController; // Contrôleur pour l'animation du formulaire

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

    _formSlideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _scanController.dispose();
    _pulseController.dispose();
    _formSlideController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Gère la sélection d'un avatar et la transition vers le formulaire d'inscription.
  void _selectAvatar(String avatarUrl) {
    setState(() {
      _selectedAvatarUrl = avatarUrl;
      _showAvatarSelection = false; // Passe à l'affichage du formulaire
    });
    _formSlideController.forward(); // Démarre l'animation du formulaire
  }

  /// Gère le processus d'inscription de l'utilisateur.
  ///
  /// Valide le formulaire et tente de créer un nouveau compte via le service d'authentification.
  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate() && _selectedAvatarUrl != null) {
      final authNotifier = ref.read(authProvider.notifier);
      final username = _usernameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      await authNotifier.signUp(
        email: email,
        password: password,
        username: username, // Passe le nom d'utilisateur
        avatarUrl: _selectedAvatarUrl, // Passe l'URL de l'avatar
      );

      if (!mounted) return;
      final authState = ref.read(authProvider);

      if (authState.isSignedIn) {
        AppLogger.info(
          'User $email signed up successfully. Navigating to dashboard.',
        );
        // Afficher un message de succès avant la navigation
        _showSuccessDialog(context, username);
        // Naviguer vers le dashboard après un court délai pour l'animation du dialogue
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            context.goNamed(RouteNames.dashboard, extra: authState.user?.id);
          }
        });
      } else {
        AppLogger.error('Sign up failed: ${authState.errorMessage}');
        // Afficher un message d'erreur et revenir à la page d'accueil
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authState.errorMessage ?? AppStrings.registerFailed),
            backgroundColor: AppColors.errorColor,
          ),
        );
        // Revenir à la page d'accueil en cas d'échec
        context.goNamed(RouteNames.home);
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
        backgroundColor: AppColors.warningColor,
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
        backgroundColor: AppColors.warningColor,
      ),
    );
  }

  /// Affiche une boîte de dialogue pour la sélection du thème.
  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.secondaryColor,
          title: FuturisticText(
            AppStrings.theme,
            color: AppColors.primaryColor,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: FuturisticText(
                  AppStrings.lightTheme,
                  color: AppColors.textColorPrimary,
                ),
                onTap: () {
                  AppLogger.info('Light theme selected.');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: FuturisticText(
                  AppStrings.darkTheme,
                  color: AppColors.textColorPrimary,
                ),
                onTap: () {
                  AppLogger.info('Dark theme selected.');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: FuturisticText(
                  AppStrings.systemTheme,
                  color: AppColors.textColorPrimary,
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

  /// Affiche un dialogue de succès après la création du profil.
  void _showSuccessDialog(BuildContext context, String username) {
    showDialog(
      context: context,
      barrierDismissible: false, // Empêche la fermeture en tapant à l'extérieur
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.secondaryColor.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
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
                    'Error loading Lottie: ${AppAssets.successAnimation}',
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
              const SizedBox(height: 20),
              FuturisticText(
                AppStrings.profileCreated,
                size: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.successColor,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
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

  /// Construit la section de sélection de l'avatar.
  Widget _buildAvatarSelectionSection(
    double screenWidth,
    double screenHeight,
    bool isLandscape,
  ) {
    return FadeInUp(
      duration: const Duration(milliseconds: 700),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FuturisticText(
            AppStrings.chooseYourAvatar,
            size: isLandscape ? 36 : 28,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.04),
          SizedBox(
            height:
                isLandscape
                    ? screenHeight * 0.4
                    : screenWidth *
                        0.4, // Taille adaptée pour le défilement horizontal
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: AppAssets.availableAvatars.length,
              itemBuilder: (context, index) {
                final avatarPath = AppAssets.availableAvatars[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: NeuomorphicButton(
                    onPressed: () => _selectAvatar(avatarPath),
                    borderRadius: BorderRadius.circular(20),
                    depth: 8,
                    intensity: 0.6,
                    blur: 15,
                    color: AppColors.secondaryColor,
                    child: Container(
                      width:
                          isLandscape ? screenHeight * 0.3 : screenWidth * 0.3,
                      height:
                          isLandscape ? screenHeight * 0.3 : screenWidth * 0.3,
                      padding: const EdgeInsets.all(10),
                      child: Lottie.asset(
                        avatarPath,
                        fit: BoxFit.contain,
                        repeat: true,
                        errorBuilder: (context, error, stackTrace) {
                          AppLogger.error(
                            'Error loading Lottie avatar: $avatarPath',
                            error: error,
                            stackTrace: stackTrace,
                          );
                          return Icon(
                            Icons.person,
                            color: AppColors.textColorPrimary,
                            size: 60,
                          ); // Fallback
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Construit la section du formulaire d'inscription.
  Widget _buildRegistrationFormSection(
    double screenWidth,
    double screenHeight,
    bool isLandscape,
    bool authLoading,
  ) {
    return SlideTransition(
      // Animation de glissement
      position: Tween<Offset>(
        begin: const Offset(0, 1), // Commence en bas
        end: Offset.zero, // Glisse vers sa position finale
      ).animate(_formSlideController),
      child: FadeTransition(
        // Animation de fondu
        opacity: _formSlideController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Titre de l'écran d'inscription
            FuturisticText(
              AppStrings.registerTitle,
              size: isLandscape ? 36 : 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.04),

            GlassmorphismCard(
              blur: 15,
              opacity: 0.2,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Champ Nom d'utilisateur
                      InputField(
                        controller: _usernameController,
                        labelText: AppStrings.enterUsername, // Nouvelle chaîne
                        keyboardType: TextInputType.text,
                        prefixIcon: Lottie.asset(
                          AppAssets
                              .userAvatarAnimation, // Utiliser une icône d'utilisateur
                          width: 24,
                          height: 24,
                          errorBuilder: (context, error, stackTrace) {
                            AppLogger.error(
                              'Error loading Lottie: ${AppAssets.userAvatarAnimation}',
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
                            return 'Veuillez entrer un nom d\'utilisateur.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Champ Email
                      InputField(
                        controller: _emailController,
                        labelText: AppStrings.emailHint,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Lottie.asset(
                          AppAssets
                              .lockAnimation, // Placeholder, à remplacer par une icône email si disponible
                          width: 24,
                          height: 24,
                          errorBuilder: (context, error, stackTrace) {
                            AppLogger.error(
                              'Error loading Lottie: ${AppAssets.lockAnimation}',
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
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return AppStrings.invalidEmail;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Champ Mot de passe
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
                              'Error loading Lottie: ${AppAssets.lockAnimation}',
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
                                'Error loading Lottie: ${_obscurePassword ? AppAssets.eyeClosedAnimation : AppAssets.eyeOpenAnimation}',
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
                      const SizedBox(height: 20),
                      // Champ Confirmer mot de passe
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
                              'Error loading Lottie: ${AppAssets.lockAnimation}',
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
                                'Error loading Lottie: ${_obscureConfirmPassword ? AppAssets.eyeClosedAnimation : AppAssets.eyeOpenAnimation}',
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
                      const SizedBox(height: 30),
                      // Bouton Créer le compte
                      NeuomorphicButton(
                        onPressed: authLoading ? null : _handleSignUp,
                        borderRadius: BorderRadius.circular(12),
                        depth: 8,
                        intensity: 0.6,
                        blur: 15,
                        color: AppColors.primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child:
                              authLoading
                                  ? CircularProgressIndicator(
                                    color: AppColors.textColorPrimary,
                                  )
                                  : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Lottie.asset(
                                        AppAssets.signUpAnimation,
                                        width: 24,
                                        height: 24,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          AppLogger.error(
                                            'Error loading Lottie: ${AppAssets.signUpAnimation}',
                                            error: error,
                                            stackTrace: stackTrace,
                                          );
                                          return Icon(
                                            Icons.person_add,
                                            color: AppColors.textColorPrimary,
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 12),
                                      FuturisticText(
                                        AppStrings.registerAccount,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textColorPrimary,
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
            SizedBox(height: screenHeight * 0.04),

            // Option de connexion sociale
            Column(
              children: [
                FuturisticText(
                  AppStrings.orConnectWith,
                  color: AppColors.textColorSecondary,
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
                      color: AppColors.secondaryColor,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Lottie.asset(
                          AppAssets.googleLogoAnimation,
                          width: 30,
                          height: 30,
                          errorBuilder: (context, error, stackTrace) {
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
                      color: AppColors.secondaryColor,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Lottie.asset(
                          AppAssets.facebookLogoAnimation,
                          width: 30,
                          height: 30,
                          errorBuilder: (context, error, stackTrace) {
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
            SizedBox(height: screenHeight * 0.04),

            // Lien vers la page de connexion
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FuturisticText(
                  AppStrings.alreadyHaveAccount,
                  color: AppColors.textColorSecondary,
                  size: 14,
                ),
                TextButton(
                  onPressed:
                      () => context.goNamed(RouteNames.loginFromRegister),
                  child: FuturisticText(
                    AppStrings.signInHere,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    size: 14,
                  ),
                ),
              ],
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
                return Container(color: AppColors.backgroundColor);
              },
            ),
          ),

          // 2. Scan Effect Overlay
          Positioned.fill(
            child: AdvancedScanEffect(
              controller: _scanController,
              scanColor: AppColors.primaryColor.withOpacity(0.3),
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
                          borderColor: AppColors.primaryColor.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(8),
                          child: Center(
                            child: FuturisticText(
                              AppStrings.appName,
                              size: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
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
                            backgroundColor: Colors.blue.withOpacity(0.2),
                            errorBuilder: (context, error, stackTrace) {
                              AppLogger.error(
                                'Error loading Lottie: ${AppAssets.helpIconAnimation}',
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
                            backgroundColor: Colors.blue.withOpacity(0.2),
                            errorBuilder: (context, error, stackTrace) {
                              AppLogger.error(
                                'Error loading Lottie: ${AppAssets.themeIconAnimation}',
                                error: error,
                                stackTrace: stackTrace,
                              );
                              return Icon(
                                Icons.palette,
                                color: AppColors.textColorPrimary,
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                          AnimatedIconButton(
                            animationAsset: AppAssets.geminiIconAnimation,
                            tooltip: AppStrings.gemini,
                            onPressed: () => context.goNamed(RouteNames.gemini),
                            backgroundColor: Colors.blue.withOpacity(0.2),
                            errorBuilder: (context, error, stackTrace) {
                              AppLogger.error(
                                'Error loading Lottie: ${AppAssets.geminiIconAnimation}',
                                error: error,
                                stackTrace: stackTrace,
                              );
                              return Icon(
                                Icons.psychology,
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
                  child: Center(
                    child: SingleChildScrollView(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
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
                                ? _buildAvatarSelectionSection(
                                  screenWidth,
                                  screenHeight,
                                  isLandscape,
                                )
                                : _buildRegistrationFormSection(
                                  screenWidth,
                                  screenHeight,
                                  isLandscape,
                                  authLoading,
                                ),
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
                        onPressed: () {
                          if (!_showAvatarSelection) {
                            // Si on est sur le formulaire, revenir à la sélection d'avatar
                            _formSlideController.reverse().then((_) {
                              setState(() {
                                _showAvatarSelection = true;
                                _selectedAvatarUrl =
                                    null; // Réinitialise l'avatar sélectionné
                              });
                            });
                          } else {
                            // Sinon, revenir à la page précédente (AuthOptions ou Home)
                            context.pop();
                          }
                        },
                        borderRadius: BorderRadius.circular(10),
                        depth: 6,
                        intensity: 0.4,
                        blur: 8,
                        color: AppColors.secondaryColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Lottie.asset(
                                AppAssets.backArrowAnimation,
                                width: 30,
                                height: 30,
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
                              const SizedBox(width: 8),
                              FuturisticText(
                                AppStrings.back,
                                color: AppColors.textColorSecondary,
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
