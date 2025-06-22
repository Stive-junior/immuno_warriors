import 'package:flutter/material.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';

class IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? iconColor;
  final double iconSize;
  final double buttonSize;
  final Color? backgroundColor;
  final Color? borderColor;
  final EdgeInsets padding;

  const IconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.iconColor = AppColors.textColorPrimary,
    this.iconSize = 26.0, // Smaller icon size
    this.buttonSize = 40.0, // Compact button size
    this.backgroundColor = AppColors.primaryColor,
    this.borderColor = AppColors.secondaryColor,
    this.padding = const EdgeInsets.all(4.0),
  });

  factory IconButton.filled({
    required IconData icon,
    required VoidCallback? onPressed,
    Color? iconColor,
    double? iconSize,
    double? buttonSize,
    Color? backgroundColor,
    Color? borderColor,
    EdgeInsets? padding,
  }) {
    return IconButton(
      icon: icon,
      onPressed: onPressed,
      iconColor: iconColor,
      iconSize: iconSize ?? 16.0,
      buttonSize: buttonSize ?? 32.0,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      padding: padding ?? const EdgeInsets.all(4.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6.0),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor?.withOpacity(onPressed != null ? 1.0 : 0.5),
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(
              color: borderColor ?? AppColors.secondaryColor,
              width: 1.0,
            ),
            boxShadow:
                onPressed != null
                    ? [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.3),
                        blurRadius: 4.0,
                        spreadRadius: 1.0,
                      ),
                    ]
                    : null,
          ),
          padding: padding,
          child: Center(child: Icon(icon, color: iconColor, size: iconSize)),
        ),
      ),
    );
  }
}
