import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:immuno_warriors/core/constants/app_assets.dart';
import 'package:immuno_warriors/core/constants/app_strings.dart';
import 'package:immuno_warriors/core/routes/route_names.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/features/splash/painters.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/shared/ui/futuristic_text.dart';
import 'package:immuno_warriors/shared/widgets/buttons/action_button.dart';
import 'package:immuno_warriors/shared/widgets/feedback/snackbar_manager.dart';
import 'package:immuno_warriors/features/auth/providers/auth_provider.dart';
import 'package:immuno_warriors/features/auth/providers/user_provider.dart';
import 'package:immuno_warriors/domain/entities/user_entity.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider pour détecter si c'est la première visite
final isFirstTimeUserProvider = StateProvider<bool>((ref) => true);

/// Écran d'accueil futuriste avec onboarding pour nouveaux utilisateurs.
/// - Non authentifié : Onboarding carousel, logo animé, options d'authentification.
/// - Authentifié : Profil utilisateur avec dashboard et options dynamiques.
/// - Thème cyberpunk avec grille hexagonale, particules interactives, et orbits 3D.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _particleAnimation;
  late Animation<double> _logoPulseAnimation;
  final List<Particle> _particles = [];
  final List<OrbitingElement> _orbitingElements = [];
  Offset? _touchPosition;
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    // Initialisation des animations
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
    _logoPulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
    _controller.repeat(reverse: true); // Animation répétée avec inversion
    _initializeParticles();
    _initializeOrbitingElements();
    _checkFirstTimeUser();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkSession());
  }

  void _initializeParticles() {
    final random = Random();
    for (int i = 0; i < 50; i++) {
      _particles.add(
        Particle(
          x: random.nextDouble(),
          y: random.nextDouble(),
          speed: random.nextDouble() * 0.15 + 0.05,
          size: random.nextDouble() * 1.5 + 0.5,
          color: AppColors.primaryColor.withOpacity(random.nextDouble() * 0.3 + 0.1),
        ),
      );
    }
  }

  void _initializeOrbitingElements() {
    final random = Random();
    _orbitingElements.addAll([
      OrbitingElement(
        radius: 60,
        speed: 1.5,
        size: 6,
        color: AppColors.primaryColor.withOpacity(0.5),
        startAngle: random.nextDouble() * 2 * pi,
      ),
      OrbitingElement(
        radius: 80,
        speed: 1.2,
        size: 8,
        color: AppColors.secondaryColor.withOpacity(0.5),
        startAngle: random.nextDouble() * 2 * pi,
      ),
    ]);
  }

  Future<void> _checkFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;
    if (isFirstTime) {
      setState(() {
        _showOnboarding = true;
      });
      await prefs.setBool('isFirstTime', false);
      ref.read(isFirstTimeUserProvider.notifier).state = false;
    }
  }

  Future<void> _checkSession() async {
    final isAuthenticated = ref.read(isAuthenticatedProvider);
    final userId = ref.read(currentUserIdProvider);
    final isSessionValid = ref.read(authProvider.select((state) => state.isSessionValid));
    AppLogger.info(
      'État auth : isAuthenticated=$isAuthenticated, isSessionValid=$isSessionValid, userId=$userId',
    );
    if (isAuthenticated && !isSessionValid && userId != null) {
      context.goNamed(RouteNames.profileAuth, pathParameters: {'userId': userId});
    } else if (isAuthenticated) {
      try {
        await ref.read(userProvider.notifier).loadUserProfile();
        if (mounted) {
          SnackbarManager.showToast(context, AppStrings.welcomeFighter);
        }
      } catch (e, stackTrace) {
        AppLogger.error('Échec chargement profil', error: e, stackTrace: stackTrace);
        SnackbarManager.showError(context, AppStrings.profileError);
        await ref.read(authProvider.notifier).signOut();
        context.goNamed(RouteNames.profileAuthOptions);
      }
    }
  }

  void _handleTouch(Offset position) {
    setState(() {
      _touchPosition = position;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final userProfile = ref.watch(userProfileProvider);
    final isFirstTime = ref.watch(isFirstTimeUserProvider);
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: GestureDetector(
        onPanUpdate: (details) => _handleTouch(details.globalPosition),
        onPanEnd: (_) => setState(() => _touchPosition = null),
        child: Stack(
          fit: StackFit.expand,
          children: [
            RepaintBoundary(
              child: HexGridBackground(size: size),
            ),
            RepaintBoundary(
              child: CustomPaint(
                painter: ParticlePainter(
                  particles: _particles,
                  animationValue: _particleAnimation.value,
                  size: size,
                  touchPosition: _touchPosition,
                ),
              ),
            ),
            RepaintBoundary(
              child: CustomPaint(
                painter: OrbitingElementsPainter(
                  elements: _orbitingElements,
                  animationValue: _particleAnimation.value,
                  size: size,
                ),
              ),
            ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        child: Column(
                          children: [
                            _buildHeader(),
                            if (_showOnboarding && isFirstTime && !isAuthenticated)
                              _buildOnboardingView(size, isLandscape)
                            else
                              isAuthenticated && userProfile != null
                                  ? _buildProfileView(userProfile, isLandscape)
                                  : _buildWelcomeView(size, isLandscape),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ScaleTransition(
          scale: _logoPulseAnimation,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.textColorSecondary.withOpacity(0.4), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.textColorPrimary.withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                AppAssets.splashVirus,
                width: 34,
                height: 34,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.biotech,
                  size: 24,
                  color: AppColors.textColorPrimary,
                ),
              ),
            ),
          ),
        ),
        Row(
          children: [
            ActionButton(
              imageAsset: AppAssets.helpIcon,
              fallbackIcon: Icons.support,
              tooltip: AppStrings.help,
              onPressed: () => context.goNamed(RouteNames.help),
            ),
            const SizedBox(width: 6),
            ActionButton(
              imageAsset: AppAssets.themeIcon,
              fallbackIcon: Icons.brightness_6,
              tooltip: AppStrings.theme,
              onPressed: () => _showThemeDialog(),
            ),
            const SizedBox(width: 6),
            ActionButton(
              imageAsset: AppAssets.geminiIcon,
              fallbackIcon: Icons.auto_awesome,
              tooltip: AppStrings.gemini,
              onPressed: () => context.goNamed(RouteNames.gemini),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOnboardingView(Size size, bool isLandscape) {
    return SizedBox(
      height: isLandscape ? size.height * 0.7 : size.height * 0.8,
      child: OnboardingCarousel(
        onSkip: () {
          setState(() {
            _showOnboarding = false;
          });
        },
        onStart: () {
          setState(() {
            _showOnboarding = false;
          });
          context.goNamed(RouteNames.profileAuthOptions);
        },
      ),
    );
  }

  Widget _buildWelcomeView(Size size, bool isLandscape) {
    return isLandscape
        ? Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: _buildWelcomeLogo(size)),
        Expanded(child: _buildWelcomeOptions()),
      ],
    )
        : Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildWelcomeLogo(size),
        const SizedBox(height: 12),
        TypingText(
          text: AppStrings.welcomeFighter,
          style: FuturisticTextStyle(
            size: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textColorPrimary,
            withGlow: true,
          ),
          speed: const Duration(milliseconds: 80),
        ),
        const SizedBox(height: 10),
        _buildWelcomeOptions(),
      ],
    );
  }

  Widget _buildWelcomeLogo(Size size) {
    return ScaleTransition(
      scale: _logoPulseAnimation,
      child: Container(
        width: size.width * 0.3,
        height: size.width * 0.3,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.textColorPrimary.withOpacity(0.5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.textColorSecondary.withOpacity(0.3),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            AppAssets.splashVirus,
            width: size.width * 0.3,
            height: size.width * 0.3,
            errorBuilder: (_, __, ___) => Icon(
              Icons.biotech,
              size: size.width * 0.15,
              color: AppColors.virusGreen,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeOptions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NeonButton(
          text: AppStrings.continueButtonText,
          icon: Icons.auto_awesome_outlined,
          onPressed: () => context.goNamed(RouteNames.profileAuthOptions),
        ),
        const SizedBox(height: 8),
        NeonButton(
          text: AppStrings.demo,
          icon: Icons.play_circle,
          onPressed: () => context.goNamed(RouteNames.home), // Corrected route
        ),
        const SizedBox(height: 8),
        NeonButton(
          text: AppStrings.about,
          icon: Icons.info,
          onPressed: () => context.goNamed(RouteNames.home), // Corrected route
        ),
        const SizedBox(height: 8),
        NeonButton(
          text: AppStrings.exit,
          icon: Icons.exit_to_app,
          onPressed: () => _showExitDialog(),
          color: AppColors.errorColor,
        ),
      ],
    );
  }

  Widget _buildProfileView(UserEntity user, bool isLandscape) {
    return isLandscape
        ? Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildProfileCard(user)),
        const SizedBox(width: 12),
        Expanded(child: _buildOptionsCard(user)),
      ],
    )
        : Column(
      children: [
        _buildProfileCard(user),
        const SizedBox(height: 12),
        Expanded(child: _buildOptionsCard(user)),
      ],
    );
  }

  Widget _buildProfileCard(UserEntity user) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.virusGreen.withOpacity(0.5), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.virusGreen.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.secondaryColor.withOpacity(0.5), width: 1.5),
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: user.avatar != null ? NetworkImage(user.avatar!) : null,
              backgroundColor: AppColors.primaryColor.withOpacity(0.5),
              child: user.avatar == null
                  ? Icon(Icons.person, size: 35, color: AppColors.textColorPrimary)
                  : null,
            ),
          ),
          const SizedBox(height: 6),
          FuturisticText(
            user.username ?? AppStrings.defaultUsername,
            size: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textColorPrimary,
            withGlow: true,
          ),
          const SizedBox(height: 4),
          FuturisticText(
            user.email,
            size: 12,
            color: AppColors.textColorSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsCard(UserEntity user) {
    final isSessionValid = ref.watch(authProvider.select((state) => state.isSessionValid));
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.virusGreen.withOpacity(0.5), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.virusGreen.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isSessionValid)
            NeonButton(
              text: AppStrings.dashboardTitle,
              icon: Icons.dashboard,
              onPressed: () => context.goNamed(RouteNames.dashboard),
            ),
          if (!isSessionValid)
            NeonButton(
              text: AppStrings.signInHere,
              icon: Icons.lock_open,
              onPressed: () => context.goNamed(
                RouteNames.profileAuth,
                pathParameters: {'userId': user.id},
              ),
            ),
          const SizedBox(height: 8),
          NeonButton(
            text: AppStrings.settings,
            icon: Icons.settings,
            onPressed: () => context.goNamed(RouteNames.settings),
          ),
          const SizedBox(height: 8),
          NeonButton(
            text: AppStrings.signOut,
            icon: Icons.logout,
            onPressed: () => _showSignOutDialog(),
            color: AppColors.errorColor,
          ),
        ],
      ),
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundColor.withOpacity(0.95),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.virusGreen.withOpacity(0.5)),
        ),
        title: FuturisticText(
          AppStrings.selectTheme,
          size: 16,
          color: AppColors.textColorPrimary,
          withGlow: true,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NeonButton(
              text: AppStrings.lightTheme,
              onPressed: () {
                Navigator.pop(context);
                AppLogger.info('Thème clair sélectionné');
              },
            ),
            const SizedBox(height: 8),
            NeonButton(
              text: AppStrings.darkTheme,
              onPressed: () {
                Navigator.pop(context);
                AppLogger.info('Thème sombre sélectionné');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundColor.withOpacity(0.95),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.virusGreen.withOpacity(0.5)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppAssets.splashVirus,
              width: 40,
              height: 40,
              errorBuilder: (_, __, ___) => Icon(
                Icons.logout,
                size: 40,
                color: AppColors.errorColor,
              ),
            ),
            const SizedBox(height: 6),
            FuturisticText(
              AppStrings.signOut,
              size: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textColorPrimary,
              withGlow: true,
            ),
            const SizedBox(height: 6),
            FuturisticText(
              AppStrings.signOutConfirm,
              size: 12,
              color: AppColors.textColorSecondary,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: FuturisticText(
              AppStrings.cancel,
              size: 12,
              color: AppColors.textColorSecondary,
            ),
          ),
          NeonButton(
            text: AppStrings.yes,
            onPressed: () async {
              await ref.read(authProvider.notifier).signOut();
              if (mounted) {
                Navigator.pop(context);
                SnackbarManager.showToast(context, AppStrings.signOutSuccess);
                context.goNamed(RouteNames.profileAuthOptions);
              }
            },
            width: 80,
            height: 32,
            color: AppColors.errorColor,
          ),
        ],
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundColor.withOpacity(0.95),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.textColorSecondary.withOpacity(0.5)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppAssets.splashVirus,
              width: 40,
              height: 40,
              errorBuilder: (_, __, ___) => Icon(
                Icons.exit_to_app,
                size: 40,
                color: AppColors.interfaceColorLight,
              ),
            ),
            const SizedBox(height: 6),
            FuturisticText(
              AppStrings.exit,
              size: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textColorPrimary,
              withGlow: true,
            ),
            const SizedBox(height: 6),
            FuturisticText(
              AppStrings.exitConfirm,
              size: 12,
              color: AppColors.textColorSecondary,
            ),
          ],
        ),
        actions: [
          NeonButton(
            text: AppStrings.cancel,
            onPressed: () => Navigator.pop(context),
            width: 80,
            height: 32,
          ),
          NeonButton(
            text: AppStrings.yes,
            onPressed: () {
              Navigator.pop(context);
              SystemNavigator.pop();
            },
            width: 80,
            height: 32,
            color: AppColors.errorColor,
          ),
        ],
      ),
    );
  }
}

/// Bouton néon avec effet de particules à l'appui
class NeonButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color? color;
  final double width;
  final double height;

  const NeonButton({
    super.key,
    required this.text,
    this.icon,
    required this.onPressed,
    this.color,
    this.width = 160,
    this.height = 36,
  });

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  final List<Particle> _emitParticles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _glowAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  void _emitParticle() {
    final random = Random();
    for (int i = 0; i < 10; i++) {
      _emitParticles.add(
        Particle(
          x: 0.5,
          y: 0.5,
          speed: random.nextDouble() * 0.3 + 0.1,
          size: random.nextDouble() * 2 + 1,
          color: (widget.color ?? AppColors.secondaryColor).withOpacity(0.6),
        ),
      );
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _emitParticles.clear());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _emitParticle();
        widget.onPressed();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: ParticlePainter(
              particles: _emitParticles,
              animationValue: _glowAnimation.value,
              size: Size(widget.width, widget.height),
            ),
            size: Size(widget.width, widget.height),
          ),
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: (AppColors.textColorPrimary).withOpacity(0.6),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (AppColors.secondaryColor)
                          .withOpacity(0.3 * _glowAnimation.value),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                  gradient: LinearGradient(
                    colors: [
                      AppColors.backgroundColor.withOpacity(0.9),
                      (widget.color ?? AppColors.secondaryColor).withOpacity(0.2),
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, size: 16, color: AppColors.textColorSecondary),
                      const SizedBox(width: 6),
                    ],
                    FuturisticText(
                      widget.text,
                      size: 14,
                      color: AppColors.textColorPrimary,
                      withGlow: true,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Carousel d'onboarding pour nouveaux utilisateurs
class OnboardingCarousel extends StatefulWidget {
  final VoidCallback onSkip;
  final VoidCallback onStart;

  const OnboardingCarousel({
    super.key,
    required this.onSkip,
    required this.onStart,
  });

  @override
  State<OnboardingCarousel> createState() => _OnboardingCarouselState();
}

class _OnboardingCarouselState extends State<OnboardingCarousel>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
                _animationController.reset();
                _animationController.forward();
              });
            },
            children: [
              _buildOnboardingPage(
                image: AppAssets.splashVirus,
                title: AppStrings.welcomeFighter,
                description: AppStrings.onboardingWelcome,
                size: size,
              ),
              _buildOnboardingPage(
                image: AppAssets.geminiIcon,
                title: AppStrings.gemini,
                description: AppStrings.onboardingGemini,
                size: size,
              ),
              _buildOnboardingPage(
                image: AppAssets.splashVirus,
                title: AppStrings.getStarted,
                description: AppStrings.onboardingStart,
                size: size,
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) => _buildDot(index)),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: widget.onSkip,
              child: FuturisticText(
                AppStrings.skip,
                size: 14,
                color: AppColors.textColorSecondary,
              ),
            ),
            NeonButton(
              text: _currentPage == 2 ? AppStrings.getStarted : AppStrings.next,
              onPressed: () {
                if (_currentPage == 2) {
                  widget.onStart();
                } else {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              width: 120,
              height: 36,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOnboardingPage({
    required String image,
    required String title,
    required String description,
    required Size size,
  }) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: size.width * 0.2,
            height: size.width * 0.2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.textColorPrimary.withOpacity(0.5), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.textColorSecondary.withOpacity(0.3),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(


              child: Image.asset(
                image,
                width: size.width * 0.1,
                height: size.width * 0.1,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.auto_awesome_outlined,
                  size: size.width * 0.1,
                  color: AppColors.textColorPrimary,
                ),
              ),

            ),

          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FuturisticText(
              description,
              size: 14,
              color: AppColors.textColorSecondary,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 12 : 8,
      height: _currentPage == index ? 12 : 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index
            ? AppColors.secondaryColor
            : AppColors.textColorSecondary.withOpacity(0.4),
      ),
    );
  }
}

/// Fond avec grille hexagonale animée
class HexGridBackground extends StatelessWidget {
  final Size size;

  const HexGridBackground({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size,
      painter: HexGridPainter(),
    );
  }
}

class HexGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryColor.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final hexRadius = 20.0;
    final hexHeight = hexRadius * sqrt(3);
    final hexWidth = hexRadius * 2;

    for (double y = -hexHeight; y < size.height + hexHeight; y += hexHeight) {
      for (double x = -hexWidth; x < size.width + hexWidth; x += hexWidth * 1.5) {
        final offset = Offset(
          x + (y / hexHeight % 2) * (hexWidth * 0.75),
          y,
        );
        _drawHexagon(canvas, offset, hexRadius, paint);
      }
    }
  }

  void _drawHexagon(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (pi / 3) * i;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Extension de ParticlePainter pour interactions tactiles
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;
  final Size size;
  final Offset? touchPosition;

  ParticlePainter({
    required this.particles,
    required this.animationValue,
    required this.size,
    this.touchPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random();
    final touch = touchPosition != null
        ? Offset(
      touchPosition!.dx / size.width,
      touchPosition!.dy / size.height,
    )
        : null;

    for (var particle in particles) {
      if (touch != null) {
        final dx = touch.dx - particle.x;
        final dy = touch.dy - particle.y;
        final distance = sqrt(dx * dx + dy * dy);
        if (distance < 0.2) {
          particle.x += dx * 0.02;
          particle.y += dy * 0.02;
        }
      }

      particle.y += particle.speed * 0.01;
      if (particle.y > 1) {
        particle.y = 0;
        particle.x = random.nextDouble();
      }

      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.size,
        paint,
      );

      // Traînée
      final trailPaint = Paint()
        ..color = particle.color.withOpacity(0.05)
        ..style = PaintingStyle.stroke
        ..strokeWidth = particle.size;
      canvas.drawLine(
        Offset(particle.x * size.width, particle.y * size.height),
        Offset(particle.x * size.width, (particle.y + 0.02) * size.height),
        trailPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => true;
}

/// Widget pour l'effet de saisie animé
class TypingText extends StatefulWidget {
  final String text;
  final FuturisticTextStyle style;
  final Duration speed;

  const TypingText({
    super.key,
    required this.text,
    required this.style,
    this.speed = const Duration(milliseconds: 80),
  });

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  String _displayedText = '';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    Future.doWhile(() async {
      if (_currentIndex < widget.text.length) {
        setState(() {
          _displayedText = widget.text.substring(0, _currentIndex + 1);
          _currentIndex++;
        });
        await Future.delayed(widget.speed);
        return true;
      }
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FuturisticText(
      _displayedText,
      size: widget.style.size,
      fontWeight: widget.style.fontWeight,
      color: widget.style.color,
      withGlow: widget.style.withGlow,
      textAlign: TextAlign.center,
    );
  }
}

class FuturisticTextStyle {
  final double size;
  final FontWeight fontWeight;
  final Color color;
  final bool withGlow;
  final TextAlign? textAlign;

  const FuturisticTextStyle({
    required this.size,
    this.fontWeight = FontWeight.normal,
    required this.color,
    this.withGlow = false,
    this.textAlign,
  });
}