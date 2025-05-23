import 'package:flutter/material.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';

class NeonCard extends StatelessWidget {
  final Widget child;
  final Color glowColor;
  final double intensity;
  final double borderRadius;

  const NeonCard({
    super.key,
    required this.child,
    this.glowColor = AppColors.primaryColor,
    this.intensity = 0.6,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(intensity),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: glowColor.withOpacity(0.3),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            color: AppColors.secondaryColor.withOpacity(0.7),
          ),
          child: child,
        ),
      ),
    );
  }
}