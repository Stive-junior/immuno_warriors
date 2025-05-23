import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:immuno_warriors/core/constants/app_assets.dart';
import 'package:immuno_warriors/core/constants/app_strings.dart';
import 'package:immuno_warriors/core/routes/route_names.dart';
import '../../shared/ui/app_colors.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _MegaSplashScreenState();
}

class _MegaSplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  late Animation<double> _buttonAnimation;
  late Animation<double> _orbitAnimation;
  late Animation<double> _pulseAnimation;
  double _progressValue = 0;
  String _loadingText = "Initialisation du système immunitaire...";
  bool _showContinueButton = false;
  final List<OrbitingElement> _orbitingElements = [];

  @override
  void initState() {
    super.initState();

    // Création des éléments orbitaux
    _initializeOrbitingElements();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    _progressAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOutQuart),
      ),
    )..addListener(() {
      setState(() {
        _progressValue = _progressAnimation.value;
        _updateLoadingText();
      });
    });

    _buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.elasticOut),
      ),
    );

    _orbitAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 1.0, curve: Curves.linear),
        )
    );
        _pulseAnimation = TweenSequence<double>([
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 50),
    TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 50),
    ]).animate(
    CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
    ));

    _controller.forward().then((_) {
    if (mounted) {
    setState(() {
    _showContinueButton = true;
    });
    }
    });

    _initializeApp();
  }

  void _initializeOrbitingElements() {
    final random = Random();
    _orbitingElements.addAll([
      OrbitingElement(
        radius: 120,
        speed: 1.5,
        size: 12,
        color: AppColors.primaryColor.withOpacity(0.8),
        startAngle: random.nextDouble() * 2 * pi,
      ),
      OrbitingElement(
        radius: 150,
        speed: 1.2,
        size: 16,
        color: AppColors.secondaryColor.withOpacity(0.8),
        startAngle: random.nextDouble() * 2 * pi,
      ),
      OrbitingElement(
        radius: 180,
        speed: 0.8,
        size: 8,
        color: AppColors.primaryAccentColor.withOpacity(0.8),
        startAngle: random.nextDouble() * 2 * pi,
      ),
    ]);
  }

  void _updateLoadingText() {
    if (_progressValue < 0.15) {
      _loadingText = "Analyse des menaces virales...";
    } else if (_progressValue < 0.3) {
      _loadingText = "Activation des défenses cellulaires...";
    } else if (_progressValue < 0.45) {
      _loadingText = "Optimisation du bouclier biologique...";
    } else if (_progressValue < 0.6) {
      _loadingText = "Synchronisation du réseau neuronal...";
    } else if (_progressValue < 0.85) {
      _loadingText = "Chargement des modules tactiques...";
    } else {
      _loadingText = "Système prêt à l'action.";
    }
  }

  Future<void> _initializeApp() async {
    try {
      await Future.delayed(const Duration(seconds: 6));
      if (!mounted) return;
    } catch (e) {
      // Gestion des erreurs
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildBubbleEffect(double value) {
    return CustomPaint(
      painter: MegaBubbleProgressPainter(
        value: value,
        color: AppColors.primaryColor,
      ),
    );
  }

  Widget _buildOrbitingElements() {
    return AnimatedBuilder(
      animation: _orbitAnimation,
      builder: (context, child) {
        return Stack(
          children: _orbitingElements.map((element) {
            final angle = element.startAngle + (_orbitAnimation.value * element.speed);
            return Positioned(
              left: cos(angle) * element.radius + MediaQuery.of(context).size.width / 2 - element.size / 2,
              top: sin(angle) * element.radius + MediaQuery.of(context).size.height / 2 - 100,
              child: Container(
                width: element.size,
                height: element.size,
                decoration: BoxDecoration(
                  color: element.color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: element.color.withOpacity(0.8),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildPulsingLogo() {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primaryColor.withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            AppAssets.splashVirus,
            width: 120,
            height: 120,

          ),
        ),
      ),
    );
  }

  Widget _buildNeonRing() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: NeonRingPainter(
            progress: _progressValue,
            color: AppColors.primaryColor,
          ),
          size: Size(MediaQuery.of(context).size.width, 200),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Fond animé avec particules
          Positioned.fill(
            child: Lottie.asset(
              AppAssets.backgroundAnimation,
              fit: BoxFit.cover,
              repeat: true,
              animate: true,
            ),
          ),

          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.5,
                  colors: [
                    AppColors.primaryColor.withOpacity(0.05),
                    AppColors.backgroundColor.withOpacity(0.9),
                  ],
                ),
              ),
            ),
          ),


          _buildOrbitingElements(),


          Positioned(
            top: size.height / 2 - 150,
            left: size.width / 2 - 150,
            child: _buildNeonRing(),
          ),

          // Contenu principal centré
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                _buildPulsingLogo(),

                const SizedBox(height: 30),

                // Barre de progression futuriste
                SizedBox(
                  width: size.width * 0.7,
                  height: 30,
                  child: Stack(
                    children: [
                      // Fond de la barre
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryAccentColor,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: AppColors.secondaryColor,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColor.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),

                      // Barre de progression avec effet
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: _buildBubbleEffect(_progressValue),
                      ),


                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Positioned(
                            left: _progressValue * (size.width * 0.7 - 30),
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.secondaryColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.secondaryAccentColor,
                                    blurRadius: 5,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),


                      Center(
                        child: Text(
                          '${(_progressValue * 100).toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: AppColors.secondaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Texte de chargement avec effet de typewriter
                SizedBox(
                  width: size.width * 0.8,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.2),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      _loadingText,
                      key: ValueKey<String>(_loadingText),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textColorPrimary.withOpacity(0.9),
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            blurRadius: 15,
                            color: AppColors.primaryColor.withOpacity(0.7),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),


                if (_showContinueButton)
                  ScaleTransition(
                    scale: _buttonAnimation,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 1000),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryColor,
                            AppColors.primaryAccentColor,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.6),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          context.goNamed(RouteNames.home);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          AppStrings.continueButtonText,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColorPrimary,
                            letterSpacing: 1.5,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: AppColors.primaryColor.withOpacity(0.8),
                              ),
                            ],
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

class MegaBubbleProgressPainter extends CustomPainter {
  final double value;
  final Color color;

  MegaBubbleProgressPainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final progressWidth = size.width * value;

    // Fond avec gradient
    final gradient = LinearGradient(
      colors: [
        color.withOpacity(0.8),
        color.withOpacity(0.4),
      ],
    );
    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, progressWidth, size.height))
      ..style = PaintingStyle.fill;

    // Barre de progression principale
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, progressWidth, size.height),
        Radius.circular(size.height / 2),
      ),
      paint,
    );

    // Effet de bulles
    final bubblePaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final rng = Random((value * 1000).toInt());

    // Plus de bulles avec différentes tailles
    for (int i = 0; i < 15; i++) {
      final bubbleSize = rng.nextDouble() * 10 + 2;
      final bubbleX = rng.nextDouble() * progressWidth;
      final bubbleY = rng.nextDouble() * size.height;

      if (bubbleX + bubbleSize < progressWidth) {
        canvas.drawCircle(
          Offset(bubbleX, bubbleY),
          bubbleSize,
          bubblePaint,
        );

        // Reflet sur les bulles
        if (bubbleSize > 5) {
          canvas.drawCircle(
            Offset(bubbleX - bubbleSize * 0.3, bubbleY - bubbleSize * 0.3),
            bubbleSize * 0.3,
            Paint()..color = Colors.white.withOpacity(0.8),
          );
        }
      }
    }

    // Bordure lumineuse
    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, progressWidth, size.height),
        Radius.circular(size.height / 2),
      ),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant MegaBubbleProgressPainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.color != color;
  }
}

class NeonRingPainter extends CustomPainter {
  final double progress;
  final Color color;

  NeonRingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const radius = 150.0;
    const strokeWidth = 8.0;

    // Anneau de fond
    final backgroundPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Anneau de progression
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );

    // Effet de points autour de l'anneau
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const dotCount = 24;
    for (var i = 0; i < dotCount; i++) {
      final angle = 2 * pi * i / dotCount - pi / 2;
      final dotPosition = center + Offset(cos(angle), sin(angle)) * radius;

      if (angle + pi / 2 <= sweepAngle) {
        canvas.drawCircle(dotPosition, 4, dotPaint);
        canvas.drawCircle(
          dotPosition,
          6,
          Paint()
            ..color = color.withOpacity(0.3)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
        );
      }
    }

    // Effet de lumière au point de progression
    if (progress > 0) {
      final progressAngle = 2 * pi * progress - pi / 2;
      final progressPosition =
          center + Offset(cos(progressAngle), sin(progressAngle)) * radius;

      canvas.drawCircle(
        progressPosition,
        12,
        Paint()
          ..color = color.withOpacity(0.8)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
      );
    }
  }

  @override
  bool shouldRepaint(covariant NeonRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
