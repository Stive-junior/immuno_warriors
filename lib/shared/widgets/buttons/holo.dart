import 'package:flutter/material.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';

class HolographicButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final double? width;
  final double height;
  final EdgeInsets padding;

  const HolographicButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.width,
    this.height = 36.0, // Hauteur compacte
    this.padding = const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor.withOpacity(0.6),
              AppColors.secondaryColor.withOpacity(0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: AppColors.primaryColor.withOpacity(0.8),
            width: 1.0,
          ),
          boxShadow:
              onPressed != null
                  ? [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.3),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ]
                  : null,
        ),
        child: Center(child: child),
      ),
    );
  }
}
