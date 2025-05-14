import 'package:flutter/material.dart';
import 'package:immuno_warriors/shared/ui/app_styles.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:lottie/lottie.dart';

class InfoDialog extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText;
  final VoidCallback? onButtonPressed;
  final String? animationAsset;

  const InfoDialog({
    super.key,
    required this.title,
    required this.content,
    this.buttonText = "OK",
    this.onButtonPressed,
    this.animationAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.secondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 8.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (animationAsset != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Lottie.asset(
                  animationAsset!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
            Text(title, style: AppStyles.titleMedium),
            const SizedBox(height: 8.0),
            Text(content, style: AppStyles.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: onButtonPressed ?? () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                textStyle: AppStyles.buttonText,
              ),
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}