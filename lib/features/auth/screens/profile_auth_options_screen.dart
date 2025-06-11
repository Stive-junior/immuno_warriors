import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';

// Core Imports
import 'package:immuno_warriors/core/constants/app_assets.dart';
import 'package:immuno_warriors/core/constants/app_strings.dart';
import 'package:immuno_warriors/core/routes/route_names.dart';
import 'package:immuno_warriors/core/constants/app_animations.dart';
import 'package:immuno_warriors/core/constants/app_sizes.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

// Shared UI Components
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/shared/ui/screen_utils.dart';
import 'package:immuno_warriors/shared/ui/futuristic_text.dart';

// Shared Widgets
import 'package:immuno_warriors/shared/widgets/animations/pulse_widget.dart';
import 'package:immuno_warriors/shared/widgets/animations/scan_effect.dart';
import 'package:immuno_warriors/shared/widgets/common/theme_selection_dialog.dart';
import 'package:immuno_warriors/shared/widgets/buttons/action_button.dart';
import 'package:immuno_warriors/shared/widgets/buttons/holographic_button.dart';

class ProfileAuthOptionsScreen extends ConsumerStatefulWidget {
  const ProfileAuthOptionsScreen({super.key});

  @override
  ConsumerState<ProfileAuthOptionsScreen> createState() => _ProfileAuthOptionsScreenState();
}

class _ProfileAuthOptionsScreenState extends ConsumerState<ProfileAuthOptionsScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _helpIconController;
  late AnimationController _themeIconController;
  late AnimationController _geminiIconController;
  late AnimationController _logoVirusController;
  late AnimationController _signInLottieController;
  late AnimationController _signUpLottieController;
  late AnimationController _backIconController;

  @override
  void initState() {
    super.initState();
    _initAnimationControllers();
  }

  void _initAnimationControllers() {
    try {
      _backgroundController = AnimationController(
        duration: AppAnimations.backgroundAnimationDuration,
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

      _signInLottieController = AnimationController(
        duration: AppAnimations.iconAnimationDuration,
        vsync: this,
      )..repeat();

      _signUpLottieController = AnimationController(
        duration: AppAnimations.iconAnimationDuration,
        vsync: this,
      )..repeat(reverse: true);

      _backIconController = AnimationController(
        duration: AppAnimations.iconAnimationDuration,
        vsync: this,
      )..repeat();
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize animation controllers', error: e, stackTrace: stackTrace);
    }
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _helpIconController.dispose();
    _themeIconController.dispose();
    _geminiIconController.dispose();
    _logoVirusController.dispose();
    _signInLottieController.dispose();
    _signUpLottieController.dispose();
    _backIconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

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
              horizontal: ScreenUtils.screenWidth(context) * (isLandscape ? 0.05 : 0.08),
              vertical: ScreenUtils.screenHeight(context) * (isLandscape ? 0.08 : 0.12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: ScreenUtils.screenHeight(context) * 0.02),
                Expanded(
                  child: FadeInUp(
                    duration: AppAnimations.fadeInDuration,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: ScreenUtils.screenHeight(context) * 0.05),
                          _buildAuthOptions(context, isLandscape),
                          SizedBox(height: ScreenUtils.screenHeight(context) * 0.05),

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

  Widget _buildBackground() {
    return Positioned.fill(
      child: Lottie.asset(
        AppAssets.backgroundAnimation,
        fit: BoxFit.cover,
        controller: _backgroundController,
        repeat: true,
        errorBuilder: (context, error, stackTrace) {
          AppLogger.error('Error loading background Lottie', error: error, stackTrace: stackTrace);
          return Container(
            color: AppColors.backgroundColor,
            child: Center(
              child: Icon(
                Icons.biotech_rounded,
                color: AppColors.virusGreen.withOpacity(0.5),
                size: 100,
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
          Row(
            children: [
              ActionButton(
                lottieAsset: AppAssets.backArrowAnimation,
                tooltip: AppStrings.help,
                onPressed: () => context.goNamed(RouteNames.home),
                controller: _backIconController,
                fallbackIcon: Icons.arrow_back,
              ),
              SizedBox(width: ScreenUtils.screenWidth(context) * 0.003),
              ActionButton(
                lottieAsset: AppAssets.helpIconAnimation,
                tooltip: AppStrings.help,
                onPressed: () => context.goNamed(RouteNames.help),
                controller: _helpIconController,
                fallbackIcon: Icons.help_outline,
              ),
              SizedBox(width: ScreenUtils.screenWidth(context) * 0.003),
              ActionButton(
                lottieAsset: AppAssets.themeIconAnimation,
                tooltip: AppStrings.theme,
                onPressed: () => _showThemeDialog(context),
                controller: _themeIconController,
                fallbackIcon: Icons.palette_outlined,
              ),
              SizedBox(width: ScreenUtils.screenWidth(context) * 0.003),
              ActionButton(
                lottieAsset: AppAssets.geminiIconAnimation,
                tooltip: AppStrings.gemini,
                onPressed: () => context.goNamed(RouteNames.gemini),
                controller: _geminiIconController,
                fallbackIcon: Icons.psychology_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAuthOptions(BuildContext context, bool isLandscape) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: ScreenUtils.screenWidth(context) * 0.1,
      runSpacing: ScreenUtils.screenHeight(context) * 0.5,
      children: [
        FadeInLeft(
          delay: const Duration(milliseconds: 200),
          duration: AppAnimations.durationFast,
          child: _buildAuthOptionCard(
            lottieAsset: AppAssets.addUserAnimation,
            title: AppStrings.loginButton,
            description: AppStrings.loginDescription,
            glowColor: AppColors.secondaryAccentColor,
            onPressed: () => context.goNamed(RouteNames.login),
            controller: _signInLottieController,
          ),
        ),
        FadeInRight(
          delay: const Duration(milliseconds: 400),
          duration: AppAnimations.durationFast,
          child: _buildAuthOptionCard(
            lottieAsset: AppAssets.userAvatarAnimation,
            title: AppStrings.registerButton,
            description: AppStrings.registerDescription,
            glowColor: AppColors.secondaryAccentColor,
            onPressed: () => context.goNamed(RouteNames.register),
            controller: _signUpLottieController,
          ),
        ),
      ],
    );
  }

  Widget _buildAuthOptionCard({
    required String lottieAsset,
    required String title,
    required String description,
    required Color glowColor,
    required VoidCallback onPressed,
    required AnimationController controller,
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
                controller: controller,
                repeat: true,
                errorBuilder: (context, error, stackTrace) {
                  AppLogger.error('Error loading Lottie: $lottieAsset',
                      error: error, stackTrace: stackTrace);
                  return Icon(
                    title == AppStrings.loginButton ? Icons.login : Icons.person_add,
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



  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ThemeSelectionDialog(
        themeIconController: _themeIconController,
        onThemeSelected: (themeMode) {
          AppLogger.info('Theme changed to: $themeMode');
        },
      ),
    );
  }
}