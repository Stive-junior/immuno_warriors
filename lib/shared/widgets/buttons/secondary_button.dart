import 'package:flutter/material.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/shared/ui/app_styles.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool enabled;
  final double? width;
  final double? height;
  final TextStyle? textStyle;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.enabled = true,
    this.width,
    this.height,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: enabled ? AppColors.secondaryColor : AppColors.secondaryAccentColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: AppColors.borderColor, width: 1.0),
        boxShadow: enabled
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0.5,
            blurRadius: 4,
            offset: const Offset(1, 2),
          ),
        ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          textStyle: textStyle ?? AppStyles.buttonText.copyWith(fontSize: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          text,
          style: (textStyle ?? AppStyles.buttonText.copyWith(fontSize: 14)).copyWith(
            color: enabled ? AppColors.textColorPrimary : AppColors.textColorSecondary,
          ),
        ),
      ),
    );
  }
}