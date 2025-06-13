import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';

// Core Imports
import 'package:immuno_warriors/core/constants/app_assets.dart';
import 'package:immuno_warriors/core/constants/app_strings.dart';
import 'package:immuno_warriors/core/constants/app_animations.dart';
import 'package:immuno_warriors/core/constants/app_sizes.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/core/routes/route_names.dart';

// Shared UI Components
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/shared/ui/screen_utils.dart';
import 'package:immuno_warriors/shared/ui/futuristic_text.dart';

// Shared Widgets
import 'package:immuno_warriors/shared/widgets/animations/pulse_widget.dart';
import 'package:immuno_warriors/shared/widgets/animations/scan_effect.dart';
import 'package:immuno_warriors/shared/widgets/buttons/holographic_button.dart';
import 'package:immuno_warriors/shared/widgets/common/theme_selection_dialog.dart';
import 'package:immuno_warriors/shared/widgets/buttons/action_button.dart';
import 'package:immuno_warriors/shared/widgets/feedback/snackbar_manager.dart';

// Feature-specific Imports
import 'package:immuno_warriors/features/auth/providers/auth_provider.dart';
import 'package:immuno_warriors/features/auth/providers/user_provider.dart';
import 'package:immuno_warriors/domain/entities/user_entity.dart';

/// `HomeScreen` : Écran principal affichant le profil utilisateur et des options si authentifié,
/// ou redirigeant vers l'authentification si nécessaire.
///
/// - Si authentifié avec session valide : Profil à gauche, options (modifier profil, paramètres, déconnexion) à droite.
/// - Si session expirée : Redirige vers ProfileAuthScreen.
/// - Si non authentifié : Redirige vers ProfileAuthOptionsScreen.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _avatarController;
  late AnimationController _helpIconController;
  late AnimationController _themeIconController;
  late AnimationController _geminiIconController;
  late AnimationController _logoVirusController;

  @override
  void initState() {
    super.initState();
    _initAnimationControllers();
    // Vérifier la session au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _checkSessionAndRedirect();
      }
    });
  }

  void _initAnimationControllers() {
    try {
      _backgroundController = AnimationController(
        duration: AppAnimations.backgroundAnimationDuration,
        vsync: this,
      )..repeat(reverse: true);

      _avatarController = AnimationController(
        duration: AppAnimations.iconAnimationDuration,
        vsync: this,
      )..repeat(reverse: true);

      _helpIconController = AnimationController(
        duration: AppAnimations.iconAnimationDuration,
        vsync: this,
      )..repeat();

      _themeIconController = AnimationController(
        duration: AppAnimations.iconAnimationDuration,
        vsync: this,
      )..repeat(reverse: true);

      _geminiIconController = AnimationController(
        duration: AppAnimations.iconAnimationDuration,
        vsync: this,
      )..repeat();

      _logoVirusController = AnimationController(
        duration: AppAnimations.logoPulseDuration,
        vsync: this,
      )..repeat(reverse: true);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Échec de l\'initialisation des contrôleurs d\'animation',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _checkSessionAndRedirect() async {
    final isAuthenticated = ref.read(isAuthenticatedProvider);
    final userId = ref.read(currentUserIdProvider);
    final isSessionValid = ref.read(
      authProvider.select((state) => state.isSessionValid),
    );

    if (!isAuthenticated) {
      if (mounted) {
        context.goNamed(RouteNames.profileAuthOptions);
      }
    } else if (!isSessionValid && userId != null) {
      if (mounted) {
        context.goNamed(
          RouteNames.profileAuth,
          pathParameters: {'userId': userId},
        );
      }
    } else {
      // Charger le profil si authentifié et session valide
      await ref.read(userProvider.notifier).loadUserProfile();
    }
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _avatarController.dispose();
    _helpIconController.dispose();
    _themeIconController.dispose();
    _geminiIconController.dispose();
    _logoVirusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final isLoading = ref.watch(authLoadingProvider);
    final errorMessage = ref.watch(errorMessageProvider);
    final userProfile = ref.watch(userProfileProvider);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // Si non authentifié ou session expirée, le redirect est géré dans initState
    if (!isAuthenticated || userProfile == null) {
      return const SizedBox.shrink(); // Écran vide pendant la redirection
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackground(),
          AdvancedScanEffect(
            controller: _backgroundController,
            scanColor: AppColors.virusGreen.withOpacity(0.3),
            lineWidth: 1.0,
            blendMode: BlendMode.plus,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
                  ScreenUtils.screenWidth(context) *
                  (isLandscape ? 0.05 : 0.08),
              vertical:
                  ScreenUtils.screenHeight(context) *
                  (isLandscape ? 0.08 : 0.12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: ScreenUtils.screenHeight(context) * 0.02),
                Expanded(
                  child:
                      isLoading
                          ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          )
                          : errorMessage != null
                          ? _buildErrorState(errorMessage)
                          : _buildAuthenticatedView(userProfile, isLandscape),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: Lottie.asset(
        AppAssets.backgroundAnimation,
        fit: BoxFit.cover,
        repeat: true,
        controller: _backgroundController,
        errorBuilder: (context, error, stackTrace) {
          AppLogger.error(
            'Erreur de chargement de l\'animation Lottie',
            error: error,
            stackTrace: stackTrace,
          );
          return Container(
            color: AppColors.backgroundColor,
            child: Center(
              child: Icon(
                Icons.biotech_rounded,
                color: AppColors.virusGreen.withOpacity(0.5),
                size: 100,
                semanticLabel: 'Icône de fond de secours',
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return FadeInDown(
      duration: AppAnimations.fadeInDuration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PulseWidget(
            controller: _logoVirusController,
            minScale: 0.95,
            maxScale: 1.05,
            child: Image.asset(
              AppAssets.splashVirus,
              width: AppSizes.logoWidth,
              height: AppSizes.logoHeight,
              fit: BoxFit.contain,
              semanticLabel: AppStrings.appName,
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        ActionButton(
          lottieAsset: AppAssets.helpIconAnimation,
          tooltip: AppStrings.help,
          onPressed: () => context.goNamed(RouteNames.help),
          controller: _helpIconController,
          fallbackIcon: Icons.help_outline,
        ),
        SizedBox(width: ScreenUtils.screenWidth(context) * 0.02),
        ActionButton(
          lottieAsset: AppAssets.themeIconAnimation,
          tooltip: AppStrings.theme,
          onPressed: () => _showThemeDialog(context),
          controller: _themeIconController,
          fallbackIcon: Icons.palette_outlined,
        ),
        SizedBox(width: ScreenUtils.screenWidth(context) * 0.02),
        ActionButton(
          lottieAsset: AppAssets.geminiIconAnimation,
          tooltip: AppStrings.gemini,
          onPressed: () => context.goNamed(RouteNames.gemini),
          controller: _geminiIconController,
          fallbackIcon: Icons.psychology_outlined,
        ),
      ],
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: FadeInUp(
        duration: AppAnimations.fadeInDuration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FuturisticText(
              errorMessage,
              color: AppColors.errorColor,
              textAlign: TextAlign.center,
              size: 16 * MediaQuery.of(context).textScaleFactor,
              shadows: [
                Shadow(
                  color: AppColors.virusGreen.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            const SizedBox(height: 20),
            VirusButton(
              onPressed:
                  () => ref.read(authProvider.notifier).checkSessionValidity(),
              width: 200,
              child: FuturisticText(
                AppStrings.retry,
                size: 14 * MediaQuery.of(context).textScaleFactor,
                color: AppColors.textColorPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthenticatedView(UserEntity user, bool isLandscape) {
    return FadeInUp(
      duration: AppAnimations.fadeInDuration,
      child:
          isLandscape
              ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildProfileCard(user)),
                  SizedBox(width: ScreenUtils.screenWidth(context) * 0.04),
                  Expanded(child: _buildOptionsCard()),
                ],
              )
              : Column(
                children: [
                  _buildProfileCard(user),
                  SizedBox(height: ScreenUtils.screenHeight(context) * 0.04),
                  Expanded(child: _buildOptionsCard()),
                ],
              ),
    );
  }

  Widget _buildProfileCard(UserEntity user) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.virusGreen, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.successColor.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PulseWidget(
            controller: _avatarController,
            minScale: 0.95,
            maxScale: 1.05,
            child: CircleAvatar(
              radius: 50,
              backgroundImage:
                  user.avatar != null ? NetworkImage(user.avatar!) : null,
              backgroundColor: AppColors.primaryColor,
              child:
                  user.avatar == null
                      ? Icon(
                        Icons.person,
                        size: 50,
                        color: AppColors.textColorPrimary,
                      )
                      : null,
            ),
          ),
          const SizedBox(height: 16),
          FuturisticText(
            user.username ?? 'Utilisateur',
            size: 24 * MediaQuery.of(context).textScaleFactor,
            fontWeight: FontWeight.bold,
            color: AppColors.textColorPrimary,
          ),
          const SizedBox(height: 8),
          FuturisticText(
            user.email,
            size: 16 * MediaQuery.of(context).textScaleFactor,
            color: AppColors.textColorSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.virusGreen, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.successColor.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          VirusButton(
            onPressed: () => _showUpdateProfileDialog(context),
            width: 200,
            child: FuturisticText(
              AppStrings.updateProfile,
              size: 16 * MediaQuery.of(context).textScaleFactor,
              color: AppColors.textColorPrimary,
            ),
          ),
          const SizedBox(height: 16),
          VirusButton(
            onPressed: () => context.goNamed(RouteNames.settings),
            width: 200,
            child: FuturisticText(
              AppStrings.settings,
              size: 16 * MediaQuery.of(context).textScaleFactor,
              color: AppColors.textColorPrimary,
            ),
          ),
          const SizedBox(height: 16),
          VirusButton(
            onPressed: () async {
              await ref.read(authProvider.notifier).signOut();
              if (mounted) {
                SnackbarManager.showSnackbar(
                  context,
                  AppStrings.signOutSuccess,
                  backgroundColor: AppColors.successColor,
                  textColor: AppColors.textColorPrimary,
                );
                context.goNamed(RouteNames.profileAuthOptions);
              }
            },
            width: 200,
            child: FuturisticText(
              AppStrings.signOut,
              size: 16 * MediaQuery.of(context).textScaleFactor,
              color: AppColors.errorColor,
            ),
          ),
        ],
      ),
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

  void _showUpdateProfileDialog(BuildContext context) {
    final usernameController = TextEditingController(
      text: ref.read(currentUsernameProvider) ?? '',
    );
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.backgroundColor.withOpacity(0.9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppColors.virusGreen, width: 2),
            ),
            title: FuturisticText(
              AppStrings.updateProfile,
              size: 20,
              color: AppColors.textColorPrimary,
            ),
            content: TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: AppStrings.username,
                labelStyle: TextStyle(color: AppColors.textColorSecondary),
                filled: true,
                fillColor: AppColors.backgroundColor.withOpacity(0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.virusGreen),
                ),
              ),
              style: TextStyle(color: AppColors.textColorPrimary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: FuturisticText(
                  AppStrings.cancel,
                  size: 14,
                  color: AppColors.textColorSecondary,
                ),
              ),
              VirusButton(
                onPressed: () async {
                  await ref
                      .read(userProvider.notifier)
                      .updateUserProfile(
                        username: usernameController.text.trim(),
                      );
                  if (mounted) {
                    Navigator.pop(context);
                    SnackbarManager.showSnackbar(
                      context,
                      AppStrings.profileUpdated,
                      backgroundColor: AppColors.successColor,
                      textColor: AppColors.textColorPrimary,
                    );
                  }
                },
                width: 100,
                child: FuturisticText(
                  AppStrings.save,
                  size: 14,
                  color: AppColors.textColorPrimary,
                ),
              ),
            ],
          ),
    );
  }
}
