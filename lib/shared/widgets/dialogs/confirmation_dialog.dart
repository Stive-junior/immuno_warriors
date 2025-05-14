import 'package:flutter/material.dart';
import 'package:immuno_warriors/shared/ui/app_styles.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/shared/ui/screen_utils.dart';
import 'package:lottie/lottie.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final String? animationAsset;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    this.onCancel,
    this.animationAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.secondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ScreenUtils.getRelativeWidth(context, 3)),
      ),
      elevation: 8.0,
      child: Padding(
        padding: EdgeInsets.all(ScreenUtils.getRelativeWidth(context, 4)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (animationAsset != null)
              Padding(
                padding: EdgeInsets.only(bottom: ScreenUtils.getRelativeHeight(context, 2)),
                child: Lottie.asset(
                  animationAsset!,
                  width: ScreenUtils.getRelativeWidth(context, 25),
                  height: ScreenUtils.getRelativeHeight(context, 12),
                  fit: BoxFit.contain,
                ),
              ),
            Text(title, style: AppStyles.titleMedium.copyWith(fontSize: ScreenUtils.isSmallScreen(context) ? 20 : 24)),
            SizedBox(height: ScreenUtils.getRelativeHeight(context, 1)),
            Text(content, style: AppStyles.bodyMedium.copyWith(fontSize: ScreenUtils.isSmallScreen(context) ? 12 : 14), textAlign: TextAlign.center),
            SizedBox(height: ScreenUtils.getRelativeHeight(context, 2)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onCancel ?? () => Navigator.of(context).pop(),
                  child: Text(cancelText, style: AppStyles.buttonText.copyWith(color: AppColors.textColorSecondary, fontSize: ScreenUtils.isSmallScreen(context) ? 14 : 16)),
                ),
                SizedBox(width: ScreenUtils.getRelativeWidth(context, 4)),
                ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    textStyle: AppStyles.buttonText.copyWith(fontSize: ScreenUtils.isSmallScreen(context) ? 14 : 16),
                  ),
                  child: Text(confirmText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}