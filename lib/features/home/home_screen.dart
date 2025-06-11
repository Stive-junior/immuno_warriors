import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';

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
import 'package:immuno_warriors/shared/widgets/layout/responsive_grid.dart';
import 'package:immuno_warriors/shared/widgets/common/theme_selection_dialog.dart';
import 'package:immuno_warriors/shared/widgets/cards/user_profile_card.dart';
import 'package:immuno_warriors/shared/widgets/cards/add_profile_card.dart';
import 'package:immuno_warriors/shared/widgets/cards/profile_card_shimmer.dart';

// Feature-specific Imports
import 'package:immuno_warriors/features/auth/providers/auth_provider.dart';
import 'package:lottie/lottie.dart';
import '../../domain/entities/user_entity.dart';
import '../../shared/widgets/buttons/action_button.dart';
import '../../shared/widgets/buttons/holographic_button.dart';

/// `HomeScreen` : L'écran d'accueil principal affichant la liste des profils utilisateur.
///
/// Affiche soit les profils existants avec une carte pour ajouter un profil, soit uniquement
/// la carte pour ajouter un profil si aucun utilisateur n'existe.
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
  late AnimationController _addUserIconController;
  late AnimationController _logoVirusController;

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
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to initialize animation controllers',
        error: e,
        stackTrace: stackTrace,
      );
    }
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
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

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
                SizedBox(height: ScreenUtils.screenHeight(context) * 0.01),
                Expanded(
                  child: FadeInUp(
                    duration: AppAnimations.fadeInDuration,
                    child: RefreshIndicator(
                      onRefresh:
                          () async => ref.refresh(userListProvider.future),
                      color: AppColors.primaryColor,
                      backgroundColor: AppColors.secondaryColor.withOpacity(
                        0.8,
                      ),
                      child: asyncUsers.when(
                        data: (users) {
                          if (users.isNotEmpty) {
                            final List<Widget> userCards =
                                users
                                    .map(
                                      (user) => UserProfileCard(
                                        user: user,
                                        avatarController: _avatarController,
                                        onPressed:
                                            () => _handleUserSelection(user),
                                      ),
                                    )
                                    .toList();
                            userCards.add(
                              AddProfileCard(
                                onPressed:
                                    () => context.goNamed(
                                      RouteNames.profileAuthOptions,
                                    ),
                                addUserIconController: _addUserIconController,
                                isCentered: false,
                              ),
                            );
                            return SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: ResponsiveGrid(
                                minWidth: AppSizes.cardMinWidth,
                                children: userCards,
                              ),
                            );
                          } else {
                            return Center(
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: AddProfileCard(
                                  onPressed:
                                      () => context.goNamed(
                                        RouteNames.profileAuthOptions,
                                      ),
                                  addUserIconController: _addUserIconController,
                                  isCentered: true,
                                ),
                              ),
                            );
                          }
                        },
                        loading:
                            () => SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: ResponsiveGrid(
                                minWidth: AppSizes.cardMinWidth,
                                children: List.generate(
                                  isLandscape ? 8 : 6,
                                  (_) => const ProfileCardShimmer(),
                                )..add(
                                  AddProfileCard(
                                    onPressed:
                                        () => context.goNamed(
                                          RouteNames.profileAuthOptions,
                                        ),
                                    addUserIconController:
                                        _addUserIconController,
                                    isCentered: false,
                                  ),
                                ),
                              ),
                            ),
                        error: (error, stackTrace) {
                          AppLogger.error(
                            'Error loading user profiles',
                            error: error,
                            stackTrace: stackTrace,
                          );
                          return SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FuturisticText(
                                    AppStrings.profileLoadError,
                                    color: AppColors.errorColor,
                                    textAlign: TextAlign.center,
                                    size:
                                        16 *
                                        MediaQuery.of(context).textScaleFactor,
                                    shadows: [
                                      Shadow(
                                        color: AppColors.virusGreen.withOpacity(
                                          0.3,
                                        ),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  VirusButton(
                                    borderRadius: 12,
                                    borderColor: AppColors.virusGreen,
                                    elevation: 6,
                                    onPressed:
                                        () => ref.refresh(
                                          userListProvider.future,
                                        ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            AppSizes.buttonPaddingHorizontal,
                                        vertical:
                                            AppSizes.buttonPaddingVertical,
                                      ),
                                      child: FuturisticText(
                                        AppStrings.retry,
                                        size:
                                            14 *
                                            MediaQuery.of(
                                              context,
                                            ).textScaleFactor,
                                        color: AppColors.virusGreen,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  AddProfileCard(
                                    onPressed:
                                        () => context.goNamed(
                                          RouteNames.profileAuthOptions,
                                        ),
                                    addUserIconController:
                                        _addUserIconController,
                                    isCentered: true,
                                  ),
                                ],
                              ),
                            ),
                          );
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

  Widget _buildBackground() {
    return Positioned.fill(
      top: 0,
      bottom: 0,
      left: 0,
      right: 0,
      child: Lottie.asset(
        AppAssets.backgroundAnimation,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        repeat: true,
        controller: _backgroundController,
        errorBuilder: (context, error, stackTrace) {
          AppLogger.error(
            'Error loading background Lottie',
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
                semanticLabel: 'Fallback background icon',
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
    );
  }

  Future<void> _handleUserSelection(UserEntity user) async {
    final authNotifier = ref.read(authProvider.notifier);
    final bool isSessionValid = await authNotifier.checkSessionValidity();

    if (!mounted) return;

    if (isSessionValid) {
      context.goNamed(RouteNames.dashboard, extra: user.id);
    } else {
      context.goNamed(
        RouteNames.profileAuth,
        pathParameters: {'userId': user.id},
      );
    }
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => ThemeSelectionDialog(
            themeIconController: _themeIconController,
            onThemeSelected: (themeMode) {
              AppLogger.info('Theme changed to: $themeMode');
            },
          ),
    );
  }
}
