import 'package:flutter/material.dart';
import 'package:immuno_warriors/shared/ui/app_styles.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:lottie/lottie.dart';

class ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String? animationAsset;

  const ErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.animationAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (animationAsset != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Lottie.asset(
                  animationAsset!,
                  width: 120, // Ajuste la taille selon tes besoins
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
            Text(
              message,
              style: AppStyles.bodyMedium.copyWith(color: AppColors.errorColor),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.errorColor,
                    textStyle: AppStyles.buttonText,
                  ),
                  child: const Text("Réessayer"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}