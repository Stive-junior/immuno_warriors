import 'package:flutter/material.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';

class IconButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback onPressed;
  final Color? iconColor;
  final double? iconSize;
  final double? size;
  final Color? backgroundColor;
  final BoxBorder? border;
  final EdgeInsets padding;

  const IconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.iconColor = AppColors.textColorPrimary,
    this.iconSize = 24.0,
    this.size,
    this.backgroundColor,
    this.border,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: size == null ? BoxShape.rectangle : BoxShape.circle,
        borderRadius: size == null ? BorderRadius.circular(8.0) : null,
        border: border,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon.icon,
          color: iconColor,
          size: iconSize,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }
}