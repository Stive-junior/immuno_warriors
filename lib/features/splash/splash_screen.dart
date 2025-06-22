
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:immuno_warriors/core/constants/app_assets.dart';
import 'package:immuno_warriors/core/constants/app_strings.dart';
import 'package:immuno_warriors/features/splash/network_modal.dart';
import 'package:immuno_warriors/features/splash/painters.dart';
import 'package:immuno_warriors/features/splash/splash_screen_state.dart';
import 'package:immuno_warriors/features/splash/splash_screen_widgets.dart' show MiniInputDialog;
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/shared/ui/futuristic_text.dart';
import 'package:immuno_warriors/shared/widgets/buttons/holo.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _orbitAnimation;
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
      duration: const Duration(seconds: 10),
    );

    _orbitAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );

    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

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
        radius: 80,
        speed: 1.2,
        size: 8,
        color: AppColors.primaryColor.withOpacity(0.4),
        startAngle: random.nextDouble() * 2 * pi,
      ),
      OrbitingElement(
        radius: 100,
        speed: 1.0,
        size: 10,
        color: AppColors.secondaryColor.withOpacity(0.4),
        startAngle: random.nextDouble() * 2 * pi,
      ),
    ]);
  }

  void _initializeParticles() {
    final random = Random();
    for (int i = 0; i < 100; i++) {
      _particles.add(
        Particle(
          x: random.nextDouble(),
          y: random.nextDouble(),
          speed: random.nextDouble() * 0.2 + 0.1,
          size: random.nextDouble() * 2 + 1,
          color: AppColors.primaryColor.withOpacity(random.nextDouble() * 0.2 + 0.1),
        ),
      );
    }
  }

  String _getProgressMessage(double progress) {
    switch (progress) {
      case 0.2:
        return AppStrings.initializing;
      case 0.4:
        return AppStrings.networkChecked;
      case 0.6:
        return AppStrings.sessionChecked;
      case 0.8:
        return AppStrings.profileLoaded;
      case 1.0:
        return AppStrings.successMessage;
      default:
        return AppStrings.initializing;
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
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.8,
              colors: [
                AppColors.primaryColor.withOpacity(0.08),
                AppColors.backgroundColor.withOpacity(0.95),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: ParticlePainter(
                    particles: _particles,
                    animationValue: _particleAnimation.value,
                    size: size,
                  ),
                ),
              ),
              Positioned.fill(
                child: CustomPaint(
                  painter: OrbitingElementsPainter(
                    elements: _orbitingElements,
                    animationValue: _orbitAnimation.value,
                    size: size,
                  ),
                ),
              ),
              Positioned(
                top: size.height / 2 - 100,
                left: size.width / 2 - 100,
                child: CustomPaint(
                  painter: NeonRingPainter(
                    progress: state.progress,
                    color: AppColors.primaryColor,
                  ),
                  size: const Size(200, 200),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.secondaryColor.withOpacity(0.3),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.secondaryAccentColor.withOpacity(0.15),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Image.asset(
                          AppAssets.splashVirus,
                          width: 70,
                          height: 70,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(color: AppColors.primaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: size.width * 0.5,
                      height: 20,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.primaryAccentColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.secondaryColor.withOpacity(0.2),
                                width: 0.5,
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CustomPaint(
                              painter: BubbleProgressPainter(
                                value: state.progress,
                                color: AppColors.virusGreen,
                              ),
                              size: Size(size.width * 0.5, 20),
                            ),
                          ),
                          Center(
                            child: FuturisticText(
                              '${(state.progress * 100).toStringAsFixed(0)}%',
                              size: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColorPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    FuturisticText(
                      _getProgressMessage(state.progress),
                      size: 11,
                      color: AppColors.virusGreen,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _showMiniInput(context, ref),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.primaryColor.withOpacity(0.4)),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColor.withOpacity(0.08),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              state.networkStatus == AppStrings.networkSuccess
                                  ? Icons.wifi
                                  : Icons.wifi_off,
                              size: 12,
                              color: state.isInitialized ? AppColors.primaryColor : AppColors.errorColor,
                            ),
                            const SizedBox(width: 5),
                            FuturisticText(
                              state.currentUrl.isEmpty ? AppStrings.errorMessage : state.currentUrl,
                              size: 9,
                              color: AppColors.textColorPrimary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: state.isInitialized && state.progress == 1.0,
                child: Positioned(
                  bottom: 30,
                  left: 30,
                  right: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      HolographicButton(
                        onPressed: () => Navigator.pop(context),
                        width: 100,
                        height: 36,
                        child: FuturisticText(
                          AppStrings.close,
                          size: 12,
                          color: AppColors.textColorPrimary,
                        ),
                      ),
                      HolographicButton(
                        onPressed: () => ref.read(splashScreenProvider.notifier).continueNavigation(context),
                        width: 100,
                        height: 36,
                        child: FuturisticText(
                          AppStrings.continueButtonText,
                          size: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColorPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (state.hasCriticalError &&
                  (state.errorMessage == AppStrings.noInternetConnection ||
                      state.errorMessage == 'Serveur injoignable. Vérifiez l\'URL.'))
                Center(
                  child: NetworkErrorModal(
                    errorMessage: state.errorMessage!,
                    onRetry: () => ref.read(splashScreenProvider.notifier).retry(context),
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
      builder: (context) => MiniInputDialog(
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

class NetworkErrorModal extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const NetworkErrorModal({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        width: size.width * 0.7,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.errorColor.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: AppColors.errorColor.withOpacity(0.15),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppAssets.splashVirus,
              width: 50,
              height: 50,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.signal_wifi_off,
                size: 50,
                color: AppColors.errorColor,
              ),
            ),
            const SizedBox(height: 8),
            FuturisticText(
              AppStrings.errorTitle,
              size: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.errorColor,
            ),
            const SizedBox(height: 8),
            FuturisticText(
              errorMessage,
              size: 11,
              color: AppColors.textColorPrimary,
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            HolographicButton(
              onPressed: onRetry,
              width: 100,
              height: 36,
              child: FuturisticText(
                AppStrings.retry,
                size: 12,
                color: AppColors.textColorPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
