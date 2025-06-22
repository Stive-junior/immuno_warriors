import 'package:flutter/material.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/shared/ui/app_styles.dart';
import 'package:immuno_warriors/shared/ui/screen_utils.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool enabled;
  final double? widthFactor; // Facteur de largeur relative (0.0 - 1.0)
  final double? height;
  final TextStyle? textStyle;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.enabled = true,
    this.widthFactor,
    this.height,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthFactor != null ? ScreenUtils.getRelativeWidth(context, widthFactor! * 100) : null,
      height: height,
      decoration: BoxDecoration(
        gradient: enabled ? AppColors.primaryGradient : AppColors.secondaryGradient,
        borderRadius: BorderRadius.circular(ScreenUtils.getRelativeWidth(context, 2)), // Taille relative du rayon
        boxShadow: enabled
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(2, 4),
          ),
        ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(
              horizontal: ScreenUtils.getRelativeWidth(context, 6),
              vertical: ScreenUtils.getRelativeHeight(context, 2)),
          textStyle: textStyle ?? AppStyles.buttonText.copyWith(fontSize: ScreenUtils.isSmallScreen(context) ? 14 : 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ScreenUtils.getRelativeWidth(context, 2)),
          ),
        ),
        child: Text(
          text,
          style: (textStyle ?? AppStyles.buttonText.copyWith(fontSize: ScreenUtils.isSmallScreen(context) ? 14 : 16)).copyWith(
            color: enabled ? AppColors.textColorPrimary : AppColors.textColorSecondary,
          ),
        ),
      ),
    );
  }
}