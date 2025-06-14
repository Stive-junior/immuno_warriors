import 'package:flutter/material.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/shared/ui/futuristic_text.dart';

class SnackbarManager {
  static void showSuccess(BuildContext context, String message) {
    _showSnackbar(
      context,
      message,
      icon: Icons.check_circle,
      backgroundColor: AppColors.successColor,
      textColor: AppColors.textColorPrimary,
    );
  }

  static void showError(BuildContext context, String message) {
    _showSnackbar(
      context,
      message,
      icon: Icons.error,
      backgroundColor: AppColors.errorColor,
      textColor: AppColors.textColorPrimary,
    );
  }

  static void showWarning(BuildContext context, String message) {
    _showSnackbar(
      context,
      message,
      icon: Icons.warning,
      backgroundColor: AppColors.warningColor,
      textColor: AppColors.textColorPrimary,
    );
  }

  static void showInfo(BuildContext context, String message) {
    _showSnackbar(
      context,
      message,
      icon: Icons.info,
      backgroundColor: AppColors.primaryColor,
      textColor: AppColors.textColorPrimary,
    );
  }

  static void _showSnackbar(
    BuildContext context,
    String message, {
    required IconData icon,
    Color? backgroundColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: textColor, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: FuturisticText(
                message,
                size: 14,
                color: textColor ?? AppColors.textColorPrimary,
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color:
                backgroundColor?.withOpacity(0.5) ?? AppColors.secondaryColor,
            width: 1,
          ),
        ),
        elevation: 6,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
