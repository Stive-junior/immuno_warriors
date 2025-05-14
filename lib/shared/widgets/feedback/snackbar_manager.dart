import 'package:flutter/material.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/shared/ui/app_styles.dart';
import 'package:lottie/lottie.dart'; // Pour les animations Lottie

class SnackbarManager {
  static void showSnackbar(
      BuildContext context,
      String message, {
        Color? backgroundColor,
        Color? textColor,
        Duration? duration,
        String? animationAsset,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (animationAsset != null)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Lottie.asset(
                  animationAsset,
                  width: 48,
                  height: 48,
                  fit: BoxFit.contain,
                ),
              ),
            Expanded(
              child: Text(
                message,
                style: textColor != null ? AppStyles.bodyMedium.copyWith(color: textColor) : AppStyles.bodyMedium,
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor ?? AppColors.secondaryColor,
        duration: duration ?? const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}