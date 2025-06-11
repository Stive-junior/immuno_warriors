// shared/widgets/common/action_button.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:immuno_warriors/core/constants/app_sizes.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/shared/widgets/buttons/holographic_button.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

/// A reusable button with a Lottie animation, fallback icon, and holographic style.
class ActionButton extends StatelessWidget {
  final String lottieAsset;
  final String tooltip;
  final VoidCallback onPressed;
  final AnimationController controller;
  final IconData fallbackIcon;

  const ActionButton({
    super.key,
    required this.lottieAsset,
    required this.tooltip,
    required this.onPressed,
    required this.controller,
    required this.fallbackIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: tooltip,
      button: true,
      child: VirusButton(
        borderRadius: 12,
        borderColor: AppColors.primaryAccentColor,
        elevation: 6,
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Lottie.asset(
            lottieAsset,
            width: AppSizes.iconLottieSize,
            height: AppSizes.iconLottieSize,
            controller: controller,
            repeat: true,
            errorBuilder: (context, error, stackTrace) {
              AppLogger.error('Error loading Lottie: $lottieAsset', error: error, stackTrace: stackTrace);
              return Icon(
                fallbackIcon,
                color: AppColors.primaryColor,
                size: AppSizes.iconLottieSize,
              );
            },
          ),
        ),
      ),
    );
  }
}