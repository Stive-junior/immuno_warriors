import 'package:flutter/material.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/shared/widgets/feedback/snackbar_manager.dart';


class ToastManager {
  static void showToast(
      BuildContext context,
      String message, {
        Color? backgroundColor,
        Color? textColor,
        String? animationAsset,
      }) {
    SnackbarManager.showSnackbar(
      context,
      message,
      backgroundColor: backgroundColor ?? AppColors.secondaryColor,
      textColor: textColor,
      duration: const Duration(seconds: 1), // Durée plus courte pour les Toasts
      animationAsset: animationAsset,
    );
  }
}