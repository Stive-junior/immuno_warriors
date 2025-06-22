import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:immuno_warriors/core/extensions/context_extension.dart';
import 'package:lottie/lottie.dart';
import 'package:immuno_warriors/core/constants/app_assets.dart';
import 'package:immuno_warriors/core/constants/app_strings.dart';
import 'package:immuno_warriors/core/routes/route_names.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/shared/ui/futuristic_text.dart';
import 'package:immuno_warriors/shared/widgets/buttons/action_button.dart';
import 'package:immuno_warriors/shared/widgets/feedback/snackbar_manager.dart';

import '../../home/home_screen.dart';

/// Écran futuriste pour choisir entre connexion et inscription, avec fond animé.
/// - Affiche deux cartes statiques avec animations Lottie et effets néon.
/// - Navigation vers LoginScreen ou RegisterScreen.
/// - Thème cyberpunk avec grille hexagonale, particules interactives et orbits.
class ProfileAuthOptionsScreen extends ConsumerStatefulWidget {
  const ProfileAuthOptionsScreen({super.key});

  @override
  ConsumerState<ProfileAuthOptionsScreen> createState() => _ProfileAuthOptionsScreenState();
}

class _ProfileAuthOptionsScreenState extends ConsumerState<ProfileAuthOptionsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _particleAnimation;
  final List<Particle> _particles = [];
  final List<OrbitingElement> _orbitingElements = [];
  Offset? _touchPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
    // Debug animation values
    _particleAnimation.addListener(() {
      AppLogger.debug('Particle animation value: ${_particleAnimation.value}');
    });
    _initializeParticles();
    _initializeOrbitingElements();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.repeat();
        AppLogger.info('ProfileAuthOptionsScreen animation started');
      }
    });
    AppLogger.info('ProfileAuthOptionsScreen initialisé');
  }

  void _initializeParticles() {
    final random = Random();
    for (int i = 0; i < 60; i++) {
      _particles.add(
        Particle(
          x: random.nextDouble(),
          y: random.nextDouble(),
          speed: random.nextDouble() * 0.2 + 0.05,
          size: random.nextDouble() * 2 + 0.5,
          color: AppColors.primaryColor.withOpacity(random.nextDouble() * 0.3 + 0.1),
        ),
      );
    }
    AppLogger.info('Initialized ${_particles.length} particles');
  }

  void _initializeOrbitingElements() {
    final random = Random();
    _orbitingElements.addAll([
      OrbitingElement(
        radius: 70,
        speed: 1.3,
        size: 7,
        color: AppColors.primaryColor.withOpacity(0.4),
        startAngle: random.nextDouble() * 2 * pi,
      ),
      OrbitingElement(
        radius: 90,
        speed: 1.0,
        size: 9,
        color: AppColors.secondaryColor.withOpacity(0.4),
        startAngle: random.nextDouble() * 2 * pi,
      ),
    ]);
    AppLogger.info('Initialized ${_orbitingElements.length} orbiting elements');
  }

  void _handleTouch(Offset position) {
    setState(() {
      _touchPosition = position;
      AppLogger.debug('Touch position updated: $_touchPosition');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    AppLogger.info('ProfileAuthOptionsScreen disposé');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = context.isLandscape;
    AppLogger.debug('Building ProfileAuthOptionsScreen with size: $size');

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: GestureDetector(
        onPanUpdate: (details) => _handleTouch(details.globalPosition),
        onPanEnd: (_) => setState(() {
          _touchPosition = null;
          AppLogger.debug('Touch ended');
        }),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Grille hexagonale
            RepaintBoundary(
              child: HexGridBackground(size: size),
            ),
            // Particules interactives
            if (_controller.isAnimating)
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
            // Orbites animées
            if (_controller.isAnimating)
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
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isLandscape ? size.width * 0.05 : size.width * 0.08,
                  vertical: isLandscape ? size.height * 0.03 : size.height * 0.04,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    SizedBox(height: size.height * 0.03),
                    Expanded(
                      child: Center(
                        child: isLandscape
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildAuthOptionCard(
                              lottieAsset: AppAssets.userAvatarAnimation,
                              title: AppStrings.loginButton,
                              description: AppStrings.loginDescription,
                              icon: Icons.login,
                              glowColor: AppColors.textColorSecondary,
                              onPressed: () => context.goNamed(RouteNames.login),
                              size: size,
                            ),
                            SizedBox(width: size.width * 0.05),
                            _buildAuthOptionCard(
                              lottieAsset: AppAssets.addUserAnimation,
                              title: AppStrings.registerButton,
                              description: AppStrings.registerDescription,
                              icon: Icons.person_add,
                              glowColor: AppColors.textColorPrimary,
                              onPressed: () => context.goNamed(RouteNames.register),
                              size: size,
                            ),
                          ],
                        )
                            : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildAuthOptionCard(
                              lottieAsset: AppAssets.userAvatarAnimation,
                              title: AppStrings.loginButton,
                              description: AppStrings.loginDescription,
                              icon: Icons.login,
                              glowColor: AppColors.primaryColor,
                              onPressed: () => context.goNamed(RouteNames.login),
                              size: size,
                            ),
                            SizedBox(height: size.height * 0.03),
                            _buildAuthOptionCard(
                              lottieAsset: AppAssets.addUserAnimation,
                              title: AppStrings.registerButton,
                              description: AppStrings.registerDescription,
                              icon: Icons.person_add,
                              glowColor: AppColors.secondaryColor,
                              onPressed: () => context.goNamed(RouteNames.register),
                              size: size,
                            ),
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
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ActionButton(
          imageAsset: AppAssets.geminiIcon,
          fallbackIcon: Icons.arrow_back,
          tooltip: AppStrings.back,
          onPressed: () => context.goNamed(RouteNames.home),
        ),
        Row(
          children: [
            ActionButton(
              imageAsset: AppAssets.helpIcon,
              fallbackIcon: Icons.help,
              tooltip: AppStrings.help,
              onPressed: () => context.goNamed(RouteNames.help),
            ),
            const SizedBox(width: 8),
            ActionButton(
              imageAsset: AppAssets.themeIcon,
              fallbackIcon: Icons.brightness_6,
              tooltip: AppStrings.theme,
              onPressed: () => _showThemeDialog(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAuthOptionCard({
    required String lottieAsset,
    required String title,
    required String description,
    required IconData icon,
    required Color glowColor,
    required VoidCallback onPressed,
    required Size size,
  }) {
    return Container(
      width: context.isLandscape ? size.width * 0.25 : size.width * 0.35,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: glowColor.withOpacity(0.6), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RepaintBoundary(
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: glowColor.withOpacity(0.5), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: glowColor.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Center(
                child: Lottie.asset(
                  lottieAsset,
                  width: 50,
                  height: 50,
                  repeat: true,
                  errorBuilder: (context, error, stackTrace) {
                    AppLogger.error(
                      'Erreur chargement Lottie: $lottieAsset',
                      error: error,
                      stackTrace: stackTrace,
                    );
                    return Icon(
                      icon,
                      size: 30,
                      color: glowColor,
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          FuturisticText(
            title,
            size: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textColorPrimary,
            withGlow: true,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          FuturisticText(
            description,
            size: 12,
            color: AppColors.textColorSecondary,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          NeonButton(
            text: title,
            icon: icon,
            onPressed: onPressed,
            color: AppColors.backgroundColor,
            width: context.isLandscape ? size.width * 0.2 : size.width * 0.3,
            height: 36,
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
          side: BorderSide(color: AppColors.virusGreen.withOpacity(0.6)),
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
                SnackbarManager.showToast(context, 'Thème clair appliqué');
              },
              width: 120,
              height: 36,
            ),
            const SizedBox(height: 8),
            NeonButton(
              text: AppStrings.darkTheme,
              onPressed: () {
                Navigator.pop(context);
                AppLogger.info('Thème sombre sélectionné');
                SnackbarManager.showToast(context, 'Thème sombre appliqué');
              },
              width: 120,
              height: 36,
            ),
          ],
        ),
      ),
    );
  }
}


/// Particule pour effets de fond et boutons
class Particle {
  double x;
  double y;
  final double speed;
  final double size;
  final Color color;

  Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.color,
  });
}

/// Peintre pour particules de fond
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
    if (particles.isEmpty) return;

    final random = Random();
    final touch = touchPosition != null
        ? Offset(touchPosition!.dx / size.width, touchPosition!.dy / size.height)
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

/// Élément orbitant pour fond
class OrbitingElement {
  final double radius;
  final double speed;
  final double size;
  final Color color;
  final double startAngle;

  OrbitingElement({
    required this.radius,
    required this.speed,
    required this.size,
    required this.color,
    required this.startAngle,
  });
}

/// Peintre pour éléments orbitants
class OrbitingElementsPainter extends CustomPainter {
  final List<OrbitingElement> elements;
  final double animationValue;
  final Size size;

  OrbitingElementsPainter({
    required this.elements,
    required this.animationValue,
    required this.size,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (elements.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    for (var element in elements) {
      final angle = element.startAngle + animationValue * element.speed;
      final x = center.dx + element.radius * cos(angle);
      final y = center.dy + element.radius * sin(angle);
      final paint = Paint()..color = element.color;
      canvas.drawCircle(Offset(x, y), element.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Fond avec grille hexagonale
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