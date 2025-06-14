import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:immuno_warriors/core/constants/app_assets.dart';
import 'package:immuno_warriors/core/constants/app_strings.dart';
import 'package:immuno_warriors/features/splash/network_modal.dart';
import 'package:immuno_warriors/features/splash/painters.dart';
import 'package:immuno_warriors/features/splash/splash_screen_state.dart';
import 'package:immuno_warriors/features/splash/splash_screen_widgets.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/shared/ui/futuristic_text.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _buttonAnimation;
  late Animation<double> _orbitAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _particleAnimation;
  final List<OrbitingElement> _orbitingElements = [];
  final List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _initializeOrbitingElements();
    _initializeParticles();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );

    _buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.8, 1.0, curve: Curves.elasticOut),
      ),
    );

    _orbitAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );

    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.2), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.2, end: 1.0), weight: 50),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(splashScreenProvider.notifier).initialize(context);
        _controller.repeat();
      }
    });
  }

  void _initializeOrbitingElements() {
    final random = Random();
    _orbitingElements.addAll([
      OrbitingElement(
        radius: 100,
        speed: 1.5,
        size: 10,
        color: AppColors.primaryColor.withOpacity(0.7),
        startAngle: random.nextDouble() * 2 * pi,
      ),
      OrbitingElement(
        radius: 130,
        speed: 1.2,
        size: 12,
        color: AppColors.secondaryColor.withOpacity(0.7),
        startAngle: random.nextDouble() * 2 * pi,
      ),
      OrbitingElement(
        radius: 160,
        speed: 0.8,
        size: 8,
        color: AppColors.primaryAccentColor.withOpacity(0.7),
        startAngle: random.nextDouble() * 2 * pi,
      ),
    ]);
  }

  void _initializeParticles() {
    final random = Random();
    for (int i = 0; i < 30; i++) {
      _particles.add(
        Particle(
          x: random.nextDouble(),
          y: random.nextDouble(),
          speed: random.nextDouble() * 0.3 + 0.1,
          size: random.nextDouble() * 3 + 1,
          color: AppColors.primaryColor.withOpacity(
            random.nextDouble() * 0.4 + 0.2,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(splashScreenProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              // Fond avec gradient
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.5,
                      colors: [
                        AppColors.primaryColor.withOpacity(0.03),
                        AppColors.backgroundColor,
                      ],
                    ),
                  ),
                ),
              ),
              // Particules
              Positioned.fill(
                child: CustomPaint(
                  painter: ParticlePainter(
                    particles: _particles,
                    animationValue: _particleAnimation.value,
                    size: size,
                  ),
                ),
              ),
              // Éléments orbitaux
              CustomPaint(
                painter: OrbitingElementsPainter(
                  elements: _orbitingElements,
                  animationValue: _orbitAnimation.value,
                  size: size,
                ),
              ),
              // Anneau néon
              Positioned(
                top: size.height / 2 - 120,
                left: size.width / 2 - 120,
                child: CustomPaint(
                  painter: NeonRingPainter(
                    progress: state.progress,
                    color: AppColors.primaryColor,
                  ),
                  size: const Size(240, 240),
                ),
              ),
              // Contenu principal
              SizedBox(
                height: size.height,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo pulsant
                      ScaleTransition(
                        scale: _pulseAnimation,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.secondaryColor.withOpacity(0.4),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.secondaryAccentColor
                                    .withOpacity(0.2),
                                blurRadius: 15,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Image.asset(
                              AppAssets.splashVirus,
                              width: 90,
                              height: 90,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      Container(color: AppColors.primaryColor),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Titre
                      FuturisticText(
                        'Immuno Warriors',
                        size: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColorPrimary,
                      ),
                      const SizedBox(height: 20),
                      // Barre de progression
                      SizedBox(
                        width: size.width * 0.6,
                        height: 25,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.primaryAccentColor.withOpacity(
                                  0.2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.secondaryColor.withOpacity(
                                    0.3,
                                  ),
                                  width: 1,
                                ),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CustomPaint(
                                painter: BubbleProgressPainter(
                                  value: state.progress,
                                  color: AppColors.virusGreen,
                                ),
                                size: Size(size.width * 0.6, 25),
                              ),
                            ),
                            Center(
                              child: FuturisticText(
                                '${(state.progress * 100).toStringAsFixed(0)}%',
                                size: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textColorPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Statut
                      FuturisticText(
                        state.statusMessage,
                        size: 12,
                        color: AppColors.textColorSecondary,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 10),
                      // Mini bouton URL
                      GestureDetector(
                        onTap: () => _showMiniInput(context, ref),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundColor.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primaryColor.withOpacity(0.5),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryColor.withOpacity(0.1),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                state.networkStatus == AppStrings.networkChecked
                                    ? Icons.wifi
                                    : Icons.wifi_off,
                                size: 14,
                                color:
                                    state.networkStatus ==
                                            AppStrings.networkChecked
                                        ? AppColors.successColor
                                        : AppColors.errorColor,
                              ),
                              const SizedBox(width: 6),
                              FuturisticText(
                                state.currentUrl.isEmpty
                                    ? 'Configurer l\'URL'
                                    : state.currentUrl,
                                size: 10,
                                color: AppColors.textColorPrimary,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Bouton Continuer
                      if (state.showContinueButton)
                        ScaleTransition(
                          scale: _buttonAnimation,
                          child: HolographicButton(
                            onPressed:
                                () => ref
                                    .read(splashScreenProvider.notifier)
                                    .continueNavigation(context),
                            width: 160,
                            height: 40,
                            child: FuturisticText(
                              AppStrings.continueButtonText,
                              size: 14,
                              color: AppColors.textColorPrimary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // Dialogue d'erreur
              if (state.hasCriticalError)
                Center(
                  child: _ErrorDialog(
                    errorMessage: state.errorMessage ?? AppStrings.errorMessage,
                    onRetry:
                        () => ref
                            .read(splashScreenProvider.notifier)
                            .retry(context),
                    onCancel:
                        () =>
                            ref
                                .read(splashScreenProvider.notifier)
                                .clearError(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMiniInput(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder:
          (context) => MiniInputDialog(
            initialUrl: ref.read(splashScreenProvider).currentUrl,
            onSubmit: (url) {
              Navigator.pop(context);
              ref.read(splashScreenProvider.notifier).updateUrl(url);
              showNetworkModal(context, ref);
            },
          ),
    );
  }
}

class _ErrorDialog extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;
  final VoidCallback onCancel;

  const _ErrorDialog({
    required this.errorMessage,
    required this.onRetry,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.errorColor.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.errorColor.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FuturisticText(
            'Erreur',
            size: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.errorColor,
          ),
          const SizedBox(height: 10),
          FuturisticText(
            errorMessage,
            size: 12,
            color: AppColors.textColorPrimary,
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          HolographicButton(
            onPressed: onRetry,
            width: 120,
            height: 36,
            child: FuturisticText(
              'Réessayer',
              size: 12,
              color: AppColors.textColorPrimary,
            ),
          ),
          const SizedBox(height: 8),
          HolographicButton(
            onPressed: onCancel,
            width: 120,
            height: 36,
            child: FuturisticText(
              'Annuler',
              size: 12,
              color: AppColors.textColorPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
