import 'package:flutter/material.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';

class CustomDialog extends StatelessWidget {
  final String? title;
  final Widget content;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final ShapeBorder? shape;
  final double? elevation;

  const CustomDialog({
    super.key,
    this.title,
    required this.content,
    this.actions,
    this.backgroundColor,
    this.shape,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backgroundColor ?? AppColors.secondaryColor,
      shape: shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: elevation ?? 8.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(title!, style: Theme.of(context).textTheme.titleLarge),
              ),
            content,
            if (actions != null && actions!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
