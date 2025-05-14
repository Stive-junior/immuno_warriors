import 'package:flutter/material.dart';
import 'package:immuno_warriors/core/constants/app_assets.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';

class AppStyles {

  static const TextStyle titleLarge = TextStyle(
    fontFamily: AppAssets.titleFont,
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: AppAssets.titleFont,
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: AppAssets.titleFont,
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
  );

  // Corps de texte principal
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: AppAssets.mainFont,
    fontSize: 16.0,
    color: AppColors.textColorPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: AppAssets.mainFont,
    fontSize: 14.0,
    color: AppColors.textColorPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: AppAssets.mainFont,
    fontSize: 12.0,
    color: AppColors.textColorSecondary,
  );

  // Texte d'accentuation
  static const TextStyle accentLarge = TextStyle(
    fontFamily: AppAssets.mainFont,
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryAccentColor,
  );

  static const TextStyle accentMedium = TextStyle(
    fontFamily: AppAssets.mainFont,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryAccentColor,
  );

  static const TextStyle accentSmall = TextStyle(
    fontFamily: AppAssets.mainFont,
    fontSize: 14.0,
    color: AppColors.primaryAccentColor,
  );

  // Texte pour les boutons
  static const TextStyle buttonText = TextStyle(
    fontFamily: AppAssets.mainFont,
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textColorPrimary,
  );


}