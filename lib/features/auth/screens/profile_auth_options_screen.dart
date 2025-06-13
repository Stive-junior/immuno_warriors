import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';

// Core Imports
import 'package:immuno_warriors/core/constants/app_assets.dart';
import 'package:immuno_warriors/core/constants/app_strings.dart';
import 'package:immuno_warriors/core/constants/app_animations.dart';
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
import 'package:immuno_warriors/shared/widgets/buttons/animated_icon_button.dart';
import 'package:immuno_warriors/shared/widgets/common/theme_selection_dialog.dart';

/// `ProfileAuthOptionsScreen` : Écran permettant de choisir entre connexion et inscription.
///
/// Affiche deux boutons animés pour naviguer vers LoginScreen ou RegisterScreen.
class ProfileAuthOptionsScreen extends ConsumerStatefulWidget {
  const ProfileAuthOptionsScreen({super.key});

  @override
  ConsumerState<ProfileAuthOptionsScreen> createState() =>
      _ProfileAuthOptionsScreenState();
}

class _ProfileAuthOptionsScreenState
    extends ConsumerState<ProfileAuthOptionsScreen>
    with TickerProviderStateMixin {
  late AnimationController _scanController;
  late AnimationController _pulseController;
  late AnimationController _themeIconController;
  late AnimationController _helpIconController;

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
    _themeIconController = AnimationController(
      duration: AppAnimations.iconAnimationDuration,
      vsync: this,
    )..repeat(reverse: true);
    _helpIconController = AnimationController(
      duration: AppAnimations.iconAnimationDuration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _scanController.dispose();
    _pulseController.dispose();
    _themeIconController.dispose();
    _helpIconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ScreenUtils.getScreenWidth(context);
    final screenHeight = ScreenUtils.getScreenHeight(context);
    final isLandscape =
        ScreenUtils.getScreenOrientation(context) == Orientation.landscape;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fond animé
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
          // Effet de scan
          Positioned.fill(
            child: AdvancedScanEffect(
              controller: _scanController,
              scanColor: AppColors.primaryColor.withOpacity(0.3),
              lineWidth: 3.0,
              blendMode: BlendMode.plus,
            ),
          ),
          // Contenu principal
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * (isLandscape ? 0.04 : 0.06),
              vertical: screenHeight * (isLandscape ? 0.06 : 0.1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête
                FadeInDown(
                  duration: const Duration(milliseconds: 700),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedIconButton(
                        animationAsset: AppAssets.backArrowAnimation,
                        tooltip: AppStrings.back,
                        onPressed: () => context.goNamed(RouteNames.home),
                        backgroundColor: Colors.transparent,
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
                            backgroundColor: Colors.blue.withOpacity(0.2),
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
                            backgroundColor: Colors.blue.withOpacity(0.2),
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
                // Contenu principal
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FadeInUp(
                            duration: const Duration(milliseconds: 500),
                            child: PulseWidget(
                              controller: _pulseController,
                              child: FuturisticText(
                                AppStrings.welcomeToImmunoWarriors,
                                size: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.05),

                          FadeInLeft(
                            duration: const Duration(milliseconds: 600),
                            child: _buildAuthOptionCard(
                              lottieAsset: AppAssets.userAvatarAnimation,
                              title: AppStrings.registerButton,
                              description: AppStrings.registerDescription,
                              glowColor: AppColors.secondaryAccentColor,
                              onPressed:
                                  () => context.goNamed(RouteNames.register),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),

                          FadeInRight(
                            duration: const Duration(milliseconds: 600),
                            child: _buildAuthOptionCard(
                              lottieAsset: AppAssets.userAvatarAnimation,
                              title: AppStrings.registerButton,
                              description: AppStrings.registerDescription,
                              glowColor: AppColors.secondaryAccentColor,
                              onPressed:
                                  () => context.goNamed(RouteNames.login),
                            ),
                          ),
                        ],
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
      builder:
          (context) => ThemeSelectionDialog(
            themeIconController: _themeIconController,
            onThemeSelected: (themeMode) {
              AppLogger.info('Thème changé pour : $themeMode');
            },
          ),
    );
  }

  Widget _buildAuthOptionCard({
    required String lottieAsset,
    required String title,
    required String description,
    required Color glowColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 250,
      child: VirusButton(
        borderRadius: 16,
        borderColor: AppColors.primaryAccentColor,
        elevation: 8,
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                lottieAsset,
                width: 65,
                height: 65,
                repeat: true,
                errorBuilder: (context, error, stackTrace) {
                  AppLogger.error(
                    'Error loading Lottie: $lottieAsset',
                    error: error,
                    stackTrace: stackTrace,
                  );
                  return Icon(
                    title == AppStrings.loginButton
                        ? Icons.login
                        : Icons.person_add,
                    color: glowColor,
                    size: 35,
                  );
                },
              ),
              const SizedBox(height: 20),
              FuturisticText(
                title,
                size: 24 * MediaQuery.of(context).textScaleFactor,
                fontWeight: FontWeight.bold,
                color: AppColors.textColorPrimary,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              FuturisticText(
                description,
                size: 12 * MediaQuery.of(context).textScaleFactor,
                color: AppColors.primaryAccentColor,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
