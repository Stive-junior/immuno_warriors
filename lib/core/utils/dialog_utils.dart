import 'package:flutter/material.dart';
import '../constants/app_strings.dart';
import '../extensions/context_extension.dart';

/// Provides utility functions for displaying dialogs.
class DialogUtils {
  /// Shows a simple alert dialog.
  static Future<T?> showAlertDialog<T>(
      BuildContext context, {
        String? title,
        required String content,
        String? confirmText,
        VoidCallback? onConfirm,
        String? cancelText,
        VoidCallback? onCancel,
        bool barrierDismissible = true,
      }) async {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title != null ? Text(title, style: context.textTheme.titleMedium) : null,
          content: Text(content, style: context.textTheme.bodyMedium),
          actions: <Widget>[
            if (cancelText != null)
              TextButton(
                onPressed: onCancel ?? () => Navigator.of(context).pop(),
                child: Text(cancelText, style: const TextStyle(color: Colors.grey)),
              ),
            TextButton(
              onPressed: onConfirm ?? () => Navigator.of(context).pop(true),
              child: Text(confirmText ?? AppStrings.ok, style: TextStyle(color: context.theme.primaryColor)),
            ),
          ],
        );
      },
    );
  }

  /// Shows a confirmation dialog.
  static Future<bool?> showConfirmationDialog(
      BuildContext context, {
        String? title,
        required String content,
        String confirmText = AppStrings.confirm,
        String cancelText = AppStrings.cancel,
      }) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // User must interact
      builder: (BuildContext context) {
        return AlertDialog(
          title: title != null ? Text(title, style: context.textTheme.titleMedium) : null,
          content: Text(content, style: context.textTheme.bodyMedium),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelText, style: const TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(confirmText, style: TextStyle(color: context.theme.primaryColor)),
            ),
          ],
        );
      },
    );
  }

  /// Shows a custom dialog using the context extension.
  static Future<T?> showCustomDialog<T>(
      BuildContext context, {
        required WidgetBuilder builder,
        bool barrierDismissible = true,
      }) {
    return context.showCustomDialog<T>(builder: builder, barrierDismissible: barrierDismissible);
  }


}