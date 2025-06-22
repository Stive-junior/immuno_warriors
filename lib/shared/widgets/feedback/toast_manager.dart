import 'package:flutter/material.dart';
import 'package:immuno_warriors/shared/widgets/feedback/snackbar_manager.dart';

class ToastManager {
  static void showToast(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    Color? textColor,
    String? animationAsset,
  }) {
    SnackbarManager.showInfo(context, message);
  }
}
