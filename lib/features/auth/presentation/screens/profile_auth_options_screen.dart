import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';
import 'package:immuno_warriors/core/constants/app_assets.dart';
import 'package:immuno_warriors/core/constants/app_strings.dart';
import 'package:immuno_warriors/core/routes/route_names.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/shared/ui/futuristic_text.dart';
import 'package:immuno_warriors/shared/widgets/animations/particle_background.dart';
import 'package:immuno_warriors/shared/widgets/buttons/holographic_button.dart';
import 'package:immuno_warriors/shared/widgets/cards/neon_card.dart';
import 'package:immuno_warriors/shared/ui/screen_utils.dart';
import 'package:immuno_warriors/shared/widgets/animations/scan_effect.dart'; // Assurez-vous que c'est le bon widget (ScanEffect ou AdvancedScanEffect)
import 'package:immuno_warriors/shared/widgets/animations/pulse_widget.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';


class AppAnimations {
  static const Duration fadeInDuration = Duration(milliseconds: 800);
  static const Duration iconAnimationDuration = Duration(milliseconds: 2000); // Durée plus longue pour les icônes
  static const Duration backgroundAnimationDuration = Duration(seconds: 10); // Durée plus longue pour le fond
  static const Duration logoPulseDuration = Duration(seconds: 4);
  static const Duration buttonAnimationDuration = Duration(milliseconds: 600);
}

// Nouvelle classe pour centraliser les tailles
class AppSizes {
  static const double iconButtonSize = 55.0;
  static const double iconLottieSize = 35.0;
  static const double authOptionLottieSize = 80.0;
  static const double authOptionCardPadding = 40.0;
  static const double logoWidth = 150.0; // Largeur du logo Immuno Warriors
  static const double logoHeight = 80.0; // Hauteur du logo Immuno Warriors
  static const double backButtonHeight = 60.0; // Hauteur du bouton retour
  static const double backButtonLottieSize = 30.0; // Taille Lottie dans le bouton retour
}

class ProfileAuthOptionsScreen extends StatefulWidget {
  const ProfileAuthOptionsScreen({super.key});

  @override
  State<ProfileAuthOptionsScreen> createState() => _ProfileAuthOptionsScreenState();
}

class _ProfileAuthOptionsScreenState extends State<ProfileAuthOptionsScreen>
    with TickerProviderStateMixin { // Changé de SingleTickerProviderStateMixin
  late AnimationController _backgroundController;
  late AnimationController _helpIconController;
  late AnimationController _themeIconController;
  late AnimationController _logoController; // Contrôleur pour le logo Immuno Warriors
  late AnimationController _signInLottieController; // Contrôleur pour l'animation de connexion
  late AnimationController _signUpLottieController; // Contrôleur pour l'animation d'inscription
  late AnimationController _backArrowController; // Contrôleur pour l'animation de la flèche retour

  @override
  void initState() {
    super.initState();

    // Initialisation de tous les contrôleurs
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

    _logoController = AnimationController(
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

    _backArrowController = AnimationController(
      duration: AppAnimations.iconAnimationDuration,
      vsync: this,
    )..repeat();
  }



  @override
  void dispose() {
    _backgroundController.dispose();
    _helpIconController.dispose();
    _themeIconController.dispose();
    _logoController.dispose();
    _signInLottieController.dispose();
    _signUpLottieController.dispose();
    _backArrowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Animated Background (ParticleBackground ou Lottie)
          _buildBackground(),


          // 2. Scan Effect Overlay
          AdvancedScanEffect( // Assumed this is 'AdvancedScanEffect' or similar
            controller: _backgroundController, // Utilise le contrôleur du fond
            scanColor: AppColors.primaryColor.withOpacity(0.3),
            lineWidth: 3.0,
            blendMode: BlendMode.plus,
          ),

          // 3. Main Content
          SafeArea( // Assure que le contenu n'est pas sous la barre de statut/encoche
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtils.screenWidth(context) * (isLandscape ? 0.04 : 0.06),
                vertical: ScreenUtils.screenHeight(context) * 0.03, // Padding légèrement réduit
              ),
              child: Column(
                children: [
                  // Top Navigation Bar
                  _buildAppBar(),

                  // Main Content Area (rendu défilable)
                  Expanded(
                    child: SingleChildScrollView( // Permet le défilement si le contenu est trop grand
                      physics: const AlwaysScrollableScrollPhysics(), // Toujours défilable
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center, // Centre le contenu verticalement
                        children: [
                          SizedBox(height: ScreenUtils.screenHeight(context) * 0.05),



                          SizedBox(height: ScreenUtils.screenHeight(context) * 0.10),

                          // Authentication Options (Login / Register Cards)
                          _buildAuthOptions(context, isLandscape),

                          SizedBox(height: ScreenUtils.screenHeight(context) * 0.05),

                          // Back Button
                          _buildBackButton(),

                          SizedBox(height: ScreenUtils.screenHeight(context) * 0.03), // Espace en bas
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

  // --- Widgets de construction ---

  // Optionnel: Si vous voulez le Lottie background au lieu de ParticleBackground
  Widget _buildBackground() {
    return Positioned.fill(
      child: Lottie.asset(
        AppAssets.backgroundAnimation,
        fit: BoxFit.cover,
        repeat: true,
        controller: _backgroundController,
        errorBuilder: (context, error, stackTrace) {
          AppLogger.error('Error loading background Lottie', error: error, stackTrace: stackTrace);
          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  AppColors.backgroundColor.withOpacity(0.9),
                  AppColors.secondaryColor.withOpacity(0.7),
                ],
                center: Alignment.topLeft,
                radius: 1.5,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar() {
    return FadeInDown(
      duration: AppAnimations.fadeInDuration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo Immuno Warriors (image statique)
          PulseWidget(
            controller: _logoController,
            child: Image.asset(
              AppAssets.splashVirus,
              width: AppSizes.logoWidth,
              height: AppSizes.logoHeight,
              fit: BoxFit.contain,
              semanticLabel: AppStrings.appName, // Utilisation du nom de l'app pour l'accessibilité
            ),
          ),


          Row(
            children: [
              _buildActionButton(
                AppAssets.helpIconAnimation,
                AppStrings.help,
                    () => context.goNamed(RouteNames.help),
                _helpIconController,
              ),
              SizedBox(width: ScreenUtils.screenWidth(context) * 0.02),
              _buildActionButton(
                AppAssets.themeIconAnimation,
                AppStrings.theme,
                    () => _showThemeDialog(context),
                _themeIconController,
              ),

              SizedBox(width: ScreenUtils.screenWidth(context) * 0.02),

              _buildActionButton(
                AppAssets.geminiIconAnimation,
                AppStrings.theme,
                    () => context.goNamed(RouteNames.gemini),
                _themeIconController,
              ),

            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String asset, String tooltip, VoidCallback onPressed, AnimationController controller) {
    return Semantics(
      label: tooltip,
      button: true,
      child: SizedBox(
        width: AppSizes.iconButtonSize,
        height: AppSizes.iconButtonSize,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: NeonCard( // Utilisation de NeonCard pour les boutons d'action
            glowColor: AppColors.primaryColor,
            child: Center(
              child: Lottie.asset(
                asset,
                width: AppSizes.iconLottieSize,
                height: AppSizes.iconLottieSize,
                controller: controller, // Utilisation du contrôleur spécifique
                repeat: true,
                errorBuilder: (context, error, stackTrace) {
                  AppLogger.error('Error loading Lottie: $asset', error: error, stackTrace: stackTrace);
                  return Icon(
                    tooltip == AppStrings.help ? Icons.help : Icons.palette,
                    color: AppColors.textColorPrimary,
                    size: AppSizes.iconLottieSize,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthOptions(BuildContext context, bool isLandscape) {
    // Utilise Row pour mettre les cartes côte à côte. Wrap pour le responsive.
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: ScreenUtils.screenWidth(context) * 0.09, // Espacement entre les cartes
      runSpacing: ScreenUtils.screenHeight(context) * 0.03, // Espacement entre les lignes (si wrap)
      children: [
        FadeInLeft(
          delay: const Duration(milliseconds: 200),
          duration: AppAnimations.buttonAnimationDuration,
          child: _buildAuthOptionCard(
            lottieAsset: AppAssets.signInAnimation,
            title: AppStrings.loginButton,
            description: AppStrings.loginDescription,
            glowColor: AppColors.primaryColor,
            onPressed: () => context.goNamed(RouteNames.login),
            controller: _signInLottieController,
          ),
        ),
        FadeInRight(
          delay: const Duration(milliseconds: 400),
          duration: AppAnimations.buttonAnimationDuration,
          child: _buildAuthOptionCard(
            lottieAsset: AppAssets.signUpAnimation,
            title: AppStrings.registerButton,
            description: AppStrings.registerDescription, // Assurez-vous d'avoir cette string
            glowColor: AppColors.healthColor, // Couleur pour le bouton d'inscription
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
      child: NeonCard(
        glowColor: glowColor,
        child: HolographicButton(
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.authOptionCardPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  lottieAsset,
                  width: 55,
                  height: 55,
                  controller: controller,
                  repeat: true,
                  errorBuilder: (context, error, stackTrace) {
                    AppLogger.error('Error loading Lottie: $lottieAsset', error: error, stackTrace: stackTrace);
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
                  color: glowColor,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return FadeInUp(
      delay: const Duration(milliseconds: 600),
      duration: AppAnimations.buttonAnimationDuration,
      child: SizedBox(
        height: AppSizes.backButtonHeight, // Hauteur fixe pour le bouton retour
        child: HolographicButton(
          onPressed: () => context.goNamed(RouteNames.home),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  AppAssets.backArrowAnimation,
                  width: AppSizes.backButtonLottieSize,
                  height: AppSizes.backButtonLottieSize,
                  controller: _backArrowController,
                  repeat: true,
                  errorBuilder: (context, error, stackTrace) {
                    AppLogger.error('Error loading Lottie: ${AppAssets.backArrowAnimation}',
                        error: error, stackTrace: stackTrace);
                    return Icon(
                      Icons.arrow_back,
                      color: AppColors.textColorSecondary,
                      size: AppSizes.backButtonLottieSize,
                    );
                  },
                ),
                const SizedBox(width: 8),
                FuturisticText(
                  AppStrings.back,
                  color: AppColors.textColorSecondary,
                  size: 16 * MediaQuery.of(context).textScaleFactor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: NeonCard(
          glowColor: AppColors.primaryAccentColor,
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FuturisticText(
                  AppStrings.selectTheme,
                  size: 24 * MediaQuery.of(context).textScaleFactor,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                _buildThemeOption(AppStrings.lightTheme, Icons.light_mode),
                _buildThemeOption(AppStrings.darkTheme, Icons.dark_mode),
                _buildThemeOption(AppStrings.systemTheme, Icons.settings_suggest),
                const SizedBox(height: 20),
                HolographicButton( // Bouton Fermer dans le dialogue
                  onPressed: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: FuturisticText(
                      AppStrings.close,
                      size: 16 * MediaQuery.of(context).textScaleFactor,
                      color: AppColors.textColorPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeOption(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryAccentColor, size: 28), // Icône plus grande
      title: FuturisticText(
        title,
        color: AppColors.textColorPrimary,
        size: 18 * MediaQuery.of(context).textScaleFactor,
      ),
      trailing: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textColorSecondary, size: 20),
      onTap: () {
        AppLogger.info('$title theme selected');
        // Implémentez la logique de changement de thème ici
        Navigator.pop(context);
      },
      // Effets visuels au survol/clic
      hoverColor: AppColors.primaryColor.withOpacity(0.1),
      focusColor: AppColors.primaryColor.withOpacity(0.15),
      splashColor: AppColors.primaryColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
