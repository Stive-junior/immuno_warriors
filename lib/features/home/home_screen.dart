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
import 'package:immuno_warriors/shared/widgets/cards/glassmorphism_card.dart';
import 'package:immuno_warriors/shared/widgets/loaders/shimmer_loader.dart';
import 'package:immuno_warriors/shared/widgets/animations/pulse_widget.dart';
import 'package:immuno_warriors/shared/widgets/animations/scan_effect.dart'; // Assuming this is AdvancedScanEffect
import 'package:immuno_warriors/shared/ui/screen_utils.dart';
import 'package:immuno_warriors/shared/ui/futuristic_text.dart';
import 'package:immuno_warriors/shared/widgets/layout/responsive_grid.dart';
import 'package:immuno_warriors/shared/widgets/buttons/neuomorphic_button.dart';
import 'package:immuno_warriors/shared/widgets/loaders/circular_indicator.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import '../../domain/entities/user_entity.dart';


class AppAnimations {
  static const Duration fadeInDuration = Duration(milliseconds: 800);
  static const Duration iconAnimationDuration = Duration(milliseconds: 2000); // Durée plus longue pour les icônes
  static const Duration backgroundAnimationDuration = Duration(seconds: 10); // Durée plus longue pour le fond
  static const Duration logoPulseDuration = Duration(seconds: 4);
  static const Duration cardAnimationDuration = Duration(milliseconds: 600);
}


class AppSizes {
  static const double iconButtonSize = 5.0;
  static const double iconLottieSize = 100.0;
  static const double cardMinWidth = 160.0;
  static const double avatarSize = 80.0;
  static const double logoWidth = 150.0;
  static const double logoHeight = 80.0;
  static const double addUserLottieSize = 60.0;
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _avatarController;
  late AnimationController _helpIconController;
  late AnimationController _themeIconController;
  late AnimationController _geminiIconController;
  late AnimationController _addUserIconController;
  late AnimationController _logoVirusController;

  @override
  void initState() {
    super.initState();



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

    _addUserIconController = AnimationController(
      duration: AppAnimations.iconAnimationDuration,
      vsync: this,
    )..repeat(reverse: true);

    _logoVirusController = AnimationController(
      duration: AppAnimations.logoPulseDuration,
      vsync: this,
    )..repeat(reverse: true);
  }



  @override
  void dispose() {
    _backgroundController.dispose();
    _avatarController.dispose();
    _helpIconController.dispose();
    _themeIconController.dispose();
    _geminiIconController.dispose();
    _addUserIconController.dispose();
    _logoVirusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncUsers = ref.watch(userListProvider);
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: Stack(
        children: [

          _buildBackground(),

          // Effet de scan utilisant le contrôleur de fond
          AdvancedScanEffect( // Assuming 'ScanEffect' is the correct name (AdvancedScanEffect in previous version)
            controller: _backgroundController,
            scanColor: AppColors.primaryColor.withOpacity(0.3),
            lineWidth: 3.0,
            blendMode: BlendMode.plus,
          ),

          // Contenu principal
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtils.screenWidth(context) * (isLandscape ? 0.04 : 0.06),
              vertical: ScreenUtils.screenHeight(context) * 0.08, // Padding réduit
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête avec le logo et les boutons d'action
                _buildHeader(),

                SizedBox(height: ScreenUtils.screenHeight(context) * 0.04),

                // Grille des utilisateurs ou carte d'ajout
                Expanded(
                  child: FadeInUp(
                    duration: AppAnimations.fadeInDuration,
                    child: _buildUserGrid(asyncUsers, isLandscape),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Widgets de construction ---

  Widget _buildBackground() {
    return Positioned.fill(
      child: Lottie.asset(
        AppAssets.backgroundAnimation,
        fit: BoxFit.cover,
        repeat: true,
        controller: _backgroundController,
        errorBuilder: (context, error, stackTrace) {
          AppLogger.error('Error loading background Lottie', error: error, stackTrace: stackTrace);
          // Fallback avec un dégradé radial futuriste
          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  AppColors.backgroundColor.withOpacity(0.8),
                  AppColors.secondaryColor.withOpacity(0.6),
                  AppColors.primaryColor.withOpacity(0.2),
                ],
                center: Alignment.topLeft,
                radius: 1.8,
                stops: const [0.0, 0.7, 1.0],
              ),
            ),
            child: Center(
              child: PulseWidget(
                controller: _backgroundController,
                child: Icon(
                  Icons.biotech_rounded,
                  color: AppColors.primaryColor.withOpacity(0.7),
                  size: 100,
                  semanticLabel: 'Fallback background icon',
                ),
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
          // Logo Virus plus grand et pulsant
          PulseWidget(
            controller: _logoVirusController,
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

        _buildAnimatedButton(

'assets/animations/help_icon.json',

          AppStrings.help,

              () => context.goNamed(RouteNames.help),

        ),

        const SizedBox(width: 12),

        _buildAnimatedButton(

          AppAssets.themeIconAnimation,

          AppStrings.theme,

              () => _showThemeDialog(context),

        ),

        const SizedBox(width: 12),

        _buildAnimatedButton(

          AppAssets.geminiIconAnimation,

          AppStrings.gemini,

              () => context.goNamed(RouteNames.gemini),

        ),

      ],

    );

  }


  Widget _buildAnimatedButton(String asset, String tooltip, VoidCallback onPressed) {

    return SizedBox(

      width: 48,

      height: 48,

      child: IconButton(

        icon: Lottie.asset(

          asset,

          width: 39,

          height: 39,

          controller: _geminiIconController,

          onLoaded: (composition) {

            _geminiIconController.duration = composition.duration;

          },

        ),

        tooltip: tooltip,

        onPressed: onPressed,

        style: IconButton.styleFrom(

          backgroundColor: Colors.transparent.withOpacity(0.2),

          shape: RoundedRectangleBorder(

            borderRadius: BorderRadius.circular(12),

          ),

        ),

      ),

    );

  }



  Widget _buildUserGrid(AsyncValue<List<UserEntity>> asyncUsers, bool isLandscape) {
    return RefreshIndicator(
      onRefresh: () async => ref.refresh(userListProvider.future),
      color: AppColors.primaryColor,
      backgroundColor: AppColors.secondaryColor.withOpacity(0.8),
      child: asyncUsers.when(
        data: (users) {
          if (users.isEmpty) {
            // Si pas d'utilisateurs, afficher seulement la carte "Ajouter un profil" au centre
            return Center(
              child: _buildAddProfileCard(isCentered: true), // Passer un flag pour le centrage
            );
          } else {
            // Sinon, afficher la grille des utilisateurs + la carte d'ajout
            final List<Widget> userCards = users.map((user) => _buildUserProfileCard(user)).toList();
            userCards.add(_buildAddProfileCard(isCentered: false)); // Carte d'ajout non centrée ici
            return SingleChildScrollView( // Permet le défilement de la grille
              physics: const AlwaysScrollableScrollPhysics(), // Toujours défilable
              child: ResponsiveGrid(
                minWidth: AppSizes.cardMinWidth,
                children: userCards,
              ),
            );
          }
        },
        loading: () => SingleChildScrollView( // Défilable pendant le chargement
          physics: const AlwaysScrollableScrollPhysics(),
          child: ResponsiveGrid(
            minWidth: AppSizes.cardMinWidth,
            children: List.generate(
              isLandscape ? 8 : 6,
                  (_) => const _FuturisticProfileCardShimmer(),
            )..add(_buildAddProfileCard(isCentered: false)), // Ajouter la carte d'ajout au shimmer
          ),
        ),
        error: (error, stackTrace) {
          AppLogger.error('Error loading user profiles', error: error, stackTrace: stackTrace);
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FuturisticText(
                  AppStrings.profileLoadError,
                  color: AppColors.errorColor,
                  textAlign: TextAlign.center,
                  size: 16 * MediaQuery.of(context).textScaleFactor,
                ),
                const SizedBox(height: 10),
                NeuomorphicButton(
                  onPressed: () => ref.refresh(userListProvider.future),
                  borderRadius: BorderRadius.circular(12),
                  depth: 6,
                  intensity: 0.5,
                  color: AppColors.secondaryColor.withOpacity(0.3),
                  child: FuturisticText(
                    AppStrings.welcomeToImmunoWarriors,
                    size: 14 * MediaQuery.of(context).textScaleFactor,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                _buildAddProfileCard(isCentered: false), // Ajouter la carte d'ajout même en cas d'erreur
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserProfileCard(UserEntity user) {
    return FadeIn(
      duration: AppAnimations.cardAnimationDuration,
      child: GlassmorphismCard(
        borderRadius: BorderRadius.circular(16),
        blur: 10,
        opacity: 0.9,
        // Ajout d'une hauteur fixe pour unifier la taille des cartes
        child: SizedBox(
          height: 200, // Hauteur fixe pour les cartes de profil
          child: InkWell(
            onTap: () => _handleUserSelection(user),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Centrer le contenu verticalement
                children: [
                  Hero(
                    tag: 'avatar-${user.id}',
                    child: CircularIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor.withOpacity(0.8)),
                      backgroundColor: AppColors.secondaryColor.withOpacity(0.4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppSizes.avatarSize / 2),
                        child: Semantics(
                          label: '${AppStrings.appName} ${user.username ?? AppStrings.unknownUser}',
                          child: Lottie.asset(
                            user.avatarUrl ?? AppAssets.userAvatarAnimation,
                            width: AppSizes.avatarSize,
                            height: AppSizes.avatarSize,
                            fit: BoxFit.contain,
                            repeat: true,
                            controller: _avatarController,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(), // Prend l'espace disponible
                  FuturisticText(
                    user.username ?? AppStrings.unknownUser,
                    size: 16 * MediaQuery.of(context).textScaleFactor,
                    fontWeight: FontWeight.w600,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center, // Centrer le texte
                  ),
                  const SizedBox(height: 5),
                  FuturisticText(
                    user.email,
                    size: 12 * MediaQuery.of(context).textScaleFactor,
                    color: AppColors.textColorSecondary, // Couleur secondaire pour l'email
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center, // Centrer le texte
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddProfileCard({bool isCentered = false}) {


    final double lottieSize = isCentered ? AppSizes.addUserLottieSize * 1.5 : AppSizes.addUserLottieSize;

    return FadeIn(
      duration: AppAnimations.cardAnimationDuration,
      child: PulseWidget(
        controller: _addUserIconController,

          child: SizedBox( // Utilisation de SizedBox pour contrôler la taille de la carte
            height: double.maxFinite,
            child: NeuomorphicButton(
              onPressed: () => context.goNamed(RouteNames.profileAuthOptions),
              borderRadius: BorderRadius.circular(16),
              depth: 8,
              intensity: 0.6,
              blur: 8,
              color: AppColors.secondaryColor.withOpacity(0.4),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column( // Changé en Column pour centrer le Lottie et le texte
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min, // S'adapte au contenu
                  children: [
                    Semantics(
                      label: AppStrings.addNewAccount,
                      child: Lottie.asset(
                        AppAssets.signUpAnimation,
                        width: lottieSize,
                        height: lottieSize,
                        controller: _addUserIconController,
                        repeat: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FuturisticText(
                      AppStrings.addNewAccount,
                      size: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColorPrimary,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),

      ),
    );
  }

  Future<void> _handleUserSelection(UserEntity user) async {
    final authState = ref.read(authProvider);
    final isSessionValid = await ref.read(authProvider.notifier).checkSessionValidity();

    if (!mounted) return;

    if (authState.isSignedIn && isSessionValid) {
      context.goNamed(RouteNames.dashboard, extra: user.id);
    } else {
      context.goNamed(RouteNames.profileAuth, pathParameters: {'userId': user.email});
    }
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundColor.withOpacity(0.95), // Fond sombre pour le dialogue
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.primaryAccentColor.withOpacity(0.5), width: 2), // Bordure lumineuse
        ),
        title: Center(
          child: FuturisticText(
            AppStrings.theme,
            color: AppColors.primaryColor,
            size: 24 * MediaQuery.of(context).textScaleFactor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(color: AppColors.borderColor, height: 15, thickness: 1),
            _buildThemeOption(AppStrings.lightTheme, ThemeMode.light),
            _buildThemeOption(AppStrings.darkTheme, ThemeMode.dark),
            _buildThemeOption(AppStrings.systemTheme, ThemeMode.system),
            const Divider(color: AppColors.borderColor, height: 2, thickness: 1),

          ],
        ),
      ),
    );
  }

  ListTile _buildThemeOption(String title, ThemeMode themeMode) {
    return ListTile(
      tileColor: Colors.transparent, // Assurer la transparence du fond
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      title: FuturisticText(
        title,
        color: AppColors.textColorPrimary,
        size: 18 * MediaQuery.of(context).textScaleFactor,
      ),
      trailing: Icon(
        Icons.ac_unit,
        color: AppColors.primaryAccentColor.withOpacity(0.8),
        size: 20,
      ),
      onTap: () {
        AppLogger.info('$title theme selected');

        Navigator.pop(context);
      },

      hoverColor: AppColors.primaryColor.withOpacity(0.1),
      focusColor: AppColors.primaryColor.withOpacity(0.15),
      splashColor: AppColors.primaryColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}

class _FuturisticProfileCardShimmer extends StatelessWidget {
  const _FuturisticProfileCardShimmer();

  @override
  Widget build(BuildContext context) {
    return GlassmorphismCard(
      borderRadius: BorderRadius.circular(16),
      blur: 10,
      opacity: 0.1,
      child: SizedBox( // Utilisation de SizedBox pour correspondre à la hauteur fixe des cartes
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShimmerLoader(
                baseColor: AppColors.shimmerBaseColor,
                highlightColor: AppColors.shimmerHighlightColor,
                child: CircleAvatar(radius: AppSizes.avatarSize / 2, backgroundColor: Colors.grey.shade700),
              ),
              const Spacer(),
              ShimmerLoader(
                baseColor: AppColors.shimmerBaseColor,
                highlightColor: AppColors.shimmerHighlightColor,
                child: SizedBox(width: 100, height: 16, child: ColoredBox(color: Colors.grey.shade700)),
              ),
              const SizedBox(height: 5),
              ShimmerLoader(
                baseColor: AppColors.shimmerBaseColor,
                highlightColor: AppColors.shimmerHighlightColor,
                child: SizedBox(width: 140, height: 12, child: ColoredBox(color: Colors.grey.shade700)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}