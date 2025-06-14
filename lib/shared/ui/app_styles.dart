import 'package:flutter/material.dart';
import 'package:immuno_warriors/core/constants/app_assets.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';

class AppStyles {
  static const TextStyle titleLarge = TextStyle(
    fontFamily: AppAssets.titleFont, // Ensure this font is futuristic
    fontSize: 36.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
    letterSpacing: 1.2,
    shadows: [
      Shadow(
        blurRadius: 5.0,
        color: AppColors.glowEffect,
        offset: Offset(2.0, 2.0),
      ),
    ],
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: AppAssets.titleFont,
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
    letterSpacing: 1.1,
    shadows: [
      Shadow(
        blurRadius: 3.0,
        color: AppColors.glowEffect,
        offset: Offset(1.5, 1.5),
      ),
    ],
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: AppAssets.titleFont,
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryAccentColor,
    letterSpacing: 1.0,
  );

  // Main body text
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: AppAssets.mainFont, // Ensure this font is readable
    fontSize: 18.0,
    color: AppColors.textColorPrimary,
    height: 1.4,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: AppAssets.mainFont,
    fontSize: 16.0,
    color: AppColors.textColorPrimary,
    height: 1.3,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: AppAssets.mainFont,
    fontSize: 14.0,
    color: AppColors.textColorSecondary,
    height: 1.2,
  );

  // Accent text
  static const TextStyle accentLarge = TextStyle(
    fontFamily: AppAssets.mainFont,
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryAccentColor,
    letterSpacing: 0.8,
  );

  static const TextStyle accentMedium = TextStyle(
    fontFamily: AppAssets.mainFont,
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryAccentColor,
    letterSpacing: 0.7,
  );

  static const TextStyle accentSmall = TextStyle(
    fontFamily: AppAssets.mainFont,
    fontSize: 16.0,
    color: AppColors.primaryAccentColor,
    letterSpacing: 0.6,
  );

  // Button text
  static const TextStyle buttonText = TextStyle(
    fontFamily: AppAssets.mainFont,
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textColorPrimary,
    letterSpacing: 0.9,
  );
}
