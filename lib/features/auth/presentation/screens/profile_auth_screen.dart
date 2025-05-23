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
import 'package:immuno_warriors/shared/widgets/forms/input_field.dart';
import 'package:immuno_warriors/shared/widgets/buttons/neuomorphic_button.dart';
import 'package:immuno_warriors/shared/ui/screen_utils.dart';
import 'package:immuno_warriors/shared/widgets/loaders/circular_indicator.dart';
import 'package:immuno_warriors/shared/widgets/animations/scan_effect.dart';
import 'package:immuno_warriors/shared/widgets/animations/pulse_widget.dart';
import 'package:immuno_warriors/shared/widgets/animations/animated_border.dart';
import 'package:immuno_warriors/shared/widgets/buttons/animated_icon_button.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart'; // Import AppLogger

import '../../../../domain/entities/user_entity.dart';

/// ProfileAuthScreen : Écran d'authentification pour un profil utilisateur existant.
///
/// Permet à l'utilisateur de saisir son mot de passe pour accéder à son profil
/// si sa session a expiré ou s'il se connecte depuis un autre appareil.
class ProfileAuthScreen extends ConsumerStatefulWidget {
  final String? userId;

  const ProfileAuthScreen({super.key, required this.userId});

  @override
  ConsumerState<ProfileAuthScreen> createState() => _ProfileAuthScreenState();
}

class _ProfileAuthScreenState extends ConsumerState<ProfileAuthScreen>
    with TickerProviderStateMixin {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  UserEntity? _user;
  bool _isLoading = false;
  String? _errorMessage;

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
    // _loadUserProfile()
  }

  @override
  void dispose() {
    _scanController.dispose();
    _pulseController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  Future<void> _authenticateProfile() async {
    if (_formKey.currentState!.validate() && _user != null) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      try {

        final isAuthenticated = await ref.read(authProvider.notifier).authenticateUser(
            widget.userId!,
            _passwordController.text
        );

        if (isAuthenticated) {
          if (!mounted) return; // Vérification du context
          AppLogger.info('User ${_user!.email} authenticated successfully. Navigating to dashboard.');
          context.goNamed(RouteNames.dashboard, extra: _user!.id); // Passe l'ID réel de l'utilisateur
        } else {
          setState(() => _errorMessage = AppStrings.invalidPassword);
          AppLogger.warning('Authentication failed for user ${widget.userId}. Invalid credentials.');
        }
      } catch (e, stackTrace) {
        setState(() => _errorMessage = e.toString());
        AppLogger.error('Error during authentication for user ${widget.userId}', error: e, stackTrace: stackTrace);
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Gère la demande de réinitialisation de mot de passe.
  ///
  /// Envoie un email de réinitialisation à l'adresse de l'utilisateur.
  Future<void> _forgotPassword() async {
    if (widget.userId == null || widget.userId!.isEmpty) {
      setState(() => _errorMessage = AppStrings.enterEmailForPasswordReset);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Appelle le service d'authentification pour envoyer l'email de réinitialisation
      await ref.read(authServiceProvider).sendPasswordResetEmail(email: widget.userId!);
      setState(() {
        _errorMessage = AppStrings.passwordResetEmailSent;
      });
      AppLogger.info('Password reset email sent to ${widget.userId}.');
    } catch (e, stackTrace) {
      setState(() => _errorMessage = AppStrings.passwordResetFailed);
      AppLogger.error('Error sending password reset email to ${widget.userId}', error: e, stackTrace: stackTrace);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Construit l'état de chargement de l'écran.
  Widget _buildLoadingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(color: AppColors.primaryColor),
        const SizedBox(height: 20),
        FuturisticText(AppStrings.loading, color: AppColors.textColorPrimary),
      ],
    );
  }

  /// Construit l'état d'erreur de l'écran.
  Widget _buildErrorState(String message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline, color: AppColors.errorColor, size: 50),
        const SizedBox(height: 20),
        FuturisticText(message, color: AppColors.errorColor, textAlign: TextAlign.center),
        const SizedBox(height: 20),
        NeuomorphicButton(
          onPressed: () => context.pop(), // Revenir à l'écran précédent
          borderRadius: BorderRadius.circular(12),
          depth: 8,
          intensity: 0.6,
          blur: 15,
          color: AppColors.secondaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: FuturisticText(AppStrings.back, color: AppColors.textColorPrimary),
          ),
        ),
      ],
    );
  }

  /// Construit le contenu principal d'authentification une fois les données utilisateur chargées.
  Widget _buildAuthContent(BuildContext context, UserEntity user) {
    final screenWidth = ScreenUtils.getScreenWidth(context);
    final screenHeight = ScreenUtils.getScreenHeight(context);
    final isLandscape = ScreenUtils.getScreenOrientation(context) == Orientation.landscape;

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
    // En-tête avec animation de pulsation
    FadeInUp(
    duration: const Duration(milliseconds: 500),
    child: PulseWidget(
    controller: _pulseController,
    child: AnimatedBorder(
    animationController: _pulseController,
    width: screenWidth * (isLandscape ? 0.4 : 0.7),
    height: 60,
    borderWidth: 2,
    borderColor: AppColors.primaryColor.withOpacity(0.8),
    borderRadius: BorderRadius.circular(12),
    child: Center(
    child: FuturisticText(
    AppStrings.profileAuthentication,
    size: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
    ),
    ),
    ),
    ),
    ),
    SizedBox(height: screenHeight * 0.05),

    // Section Avatar Utilisateur et Formulaire
    Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    // Section Avatar
    FadeInLeft(
    duration: const Duration(milliseconds: 500),
    child: Column(
    children: [
    Hero(
    tag: 'avatar-${user.id}',
    child: CircularIndicator(
    strokeWidth: 3,
    valueColor: AlwaysStoppedAnimation<Color>(
    AppColors.primaryColor.withOpacity(0.8)),
    backgroundColor: AppColors.secondaryColor.withOpacity(0.4),
    child: ClipRRect(
    borderRadius: BorderRadius.circular(60),
    child: Lottie.asset(
    user.avatarUrl ?? AppAssets.userAvatarAnimation,
    width: 120,
    height: 120,
    fit: BoxFit.cover,
    frameRate: FrameRate.max,
    repeat: true,
    errorBuilder: (context, error, stackTrace) {
    AppLogger.error('Error loading user avatar Lottie: ${user.avatarUrl}', error: error, stackTrace: stackTrace);
    return Lottie.asset(
    AppAssets.userAvatarAnimation,
    width: 120,
    height: 120,
    );
    },
    ),
    )
    ),
    ),
    const SizedBox(height: 10),
    FuturisticText(
    user.username ?? AppStrings.unknownUser,
    textAlign: TextAlign.center,
    fontWeight: FontWeight.w600,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    size: 18,
    ),
    ],
    ),
    ),
    SizedBox(width: screenWidth * 0.05),

    // Section Formulaire
    Expanded(
    child: FadeInRight(
    duration: const Duration(milliseconds: 500),
    child: Form( // Enveloppe avec le widget Form
    key: _formKey,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    InputField(
    controller: _passwordController,
    labelText: AppStrings.enterPassword,
    obscureText: _obscurePassword,
    prefixIcon: Lottie.asset(
    AppAssets.lockAnimation,
    width: 24,
    height: 24,
    errorBuilder: (context, error, stackTrace) {
    AppLogger.error('Error loading Lottie: ${AppAssets.lockAnimation}', error: error, stackTrace: stackTrace);
    return Icon(Icons.lock, color: AppColors.textColorPrimary); // Fallback
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
    AppLogger.error('Error loading Lottie: ${_obscurePassword ? AppAssets.eyeClosedAnimation : AppAssets.eyeOpenAnimation}', error: error, stackTrace: stackTrace);
    return Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: AppColors.textColorPrimary); // Fallback
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
    return AppStrings.enterPassword;
    }
    return null;
    },
    ),
    SizedBox(height: screenHeight * 0.02), // Espacement réduit

    // Bouton "Mot de passe oublié ?"
    Align(
    alignment: Alignment.centerRight,
    child: TextButton(
    onPressed: _forgotPassword,
    child: FuturisticText(
    AppStrings.forgotPassword,
    color: AppColors.primaryColor, // Utilise la couleur primaire pour les liens
    size: 14,
    fontWeight: FontWeight.w500,
    ),
    ),
    ),
    SizedBox(height: screenHeight * 0.02), // Espacement réduit

    // Bouton Authentifier
    NeuomorphicButton(
    onPressed: _isLoading ? null : _authenticateProfile,
    borderRadius: BorderRadius.circular(12),
    depth: 8,
    intensity: 0.6,
    blur: 15,
    color: AppColors.primaryColor,
    child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    if (_isLoading)
    const CircularProgressIndicator(color: Colors.white)
    else
    Lottie.asset(
    AppAssets.fingerprintAnimation,
    width: 24,
    height: 24,
    errorBuilder: (context, error, stackTrace) {
    AppLogger.error('Error loading Lottie: ${AppAssets.fingerprintAnimation}', error: error, stackTrace: stackTrace);
    return Icon(Icons.fingerprint, color: AppColors.textColorPrimary); // Fallback
    },
    ),
    const SizedBox(width: 12),
    FuturisticText(
    _isLoading
    ? AppStrings.authenticating
        : AppStrings.authenticate,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    size: 18,
    ),
    ],
    ),
    ),
    ),

    if (_errorMessage != null)
    Padding(
    padding: const EdgeInsets.only(top: 16.0),
    child: FuturisticText(
    _errorMessage!,
    color: AppColors.errorColor,
    textAlign: TextAlign.center,
    ),
    ),
    ],
    ),
    ),
    ),
    ),
    ],
    ),
    ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ScreenUtils.getScreenWidth(context);
    final screenHeight = ScreenUtils.getScreenHeight(context);
    final isLandscape = ScreenUtils.getScreenOrientation(context) == Orientation.landscape;

    // Surveille le FutureProvider pour obtenir les données de l'utilisateur
    final asyncCurrentUser = ref.watch(currentUserDataProvider);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Fond animé
          Positioned.fill(
            child: Lottie.asset(
              AppAssets.backgroundAnimation,
              fit: BoxFit.cover,
              repeat: true,
              errorBuilder: (context, error, stackTrace) {
                AppLogger.error('Error loading background Lottie: ${AppAssets.backgroundAnimation}', error: error, stackTrace: stackTrace);
                return Container(color: AppColors.backgroundColor); // Fallback simple
              },
            ),
          ),

          // 2. Effet de scan superposé
          Positioned.fill(
            child: AdvancedScanEffect(
              controller: _scanController,
              scanColor: AppColors.primaryColor.withOpacity(0.3),
              lineWidth: 3.0,
              blendMode: BlendMode.plus,
            ),
          ),

          // 3. Contenu principal
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * (isLandscape ? 0.04 : 0.06),
              vertical: screenHeight * (isLandscape ? 0.06 : 0.1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Barre de navigation supérieure avec bouton retour
                FadeInDown(
                  duration: const Duration(milliseconds: 700),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedIconButton(
                        animationAsset: AppAssets.backArrowAnimation,
                        tooltip: AppStrings.back,
                        onPressed: () => context.pop(),
                        backgroundColor: Colors.transparent,
                        errorBuilder: (context, error, stackTrace) {
                          AppLogger.error('Error loading Lottie: ${AppAssets.backArrowAnimation}', error: error, stackTrace: stackTrace);
                          return Icon(Icons.arrow_back, color: AppColors.textColorPrimary); // Fallback
                        },
                      ),
                      Row(
                        children: [
                          AnimatedIconButton(
                            animationAsset: AppAssets.helpIconAnimation,
                            tooltip: AppStrings.help,
                            onPressed: () => context.goNamed(RouteNames.help),
                            backgroundColor: Colors.blue.withOpacity(0.2),
                            errorBuilder: (context, error, stackTrace) {
                              AppLogger.error('Error loading Lottie: ${AppAssets.helpIconAnimation}', error: error, stackTrace: stackTrace);
                              return Icon(Icons.help, color: AppColors.textColorPrimary); // Fallback
                            },
                          ),
                          const SizedBox(width: 12),
                          AnimatedIconButton(
                            animationAsset: AppAssets.themeIconAnimation,
                            tooltip: AppStrings.theme,
                            onPressed: () => _showThemeDialog(context),
                            backgroundColor: Colors.blue.withOpacity(0.2),
                            errorBuilder: (context, error, stackTrace) {
                              AppLogger.error('Error loading Lottie: ${AppAssets.themeIconAnimation}', error: error, stackTrace: stackTrace);
                              return Icon(Icons.palette, color: AppColors.textColorPrimary); // Fallback
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
                      child: asyncCurrentUser.when(
                        data: (user) {
                          if (user == null) {
                            return _buildErrorState(AppStrings.profileNotFound);
                          }
                          _user = user;
                          return _buildAuthContent(context, user);
                        },
                        loading: () => _buildLoadingState(),
                        error: (error, stack) {
                          AppLogger.error('Error loading user profile in ProfileAuthScreen', error: error, stackTrace: stack);
                          return _buildErrorState('${AppStrings.profileLoadError}: ${error.toString()}');
                        },
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


  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.secondaryColor,
          title: FuturisticText(AppStrings.theme, color: AppColors.primaryColor),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: FuturisticText(AppStrings.lightTheme, color: AppColors.textColorPrimary),
                onTap: () {
                  AppLogger.info('Light theme selected.');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: FuturisticText(AppStrings.darkTheme, color: AppColors.textColorPrimary),
                onTap: () {
                  AppLogger.info('Dark theme selected.');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: FuturisticText(AppStrings.systemTheme, color: AppColors.textColorPrimary),
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
}
