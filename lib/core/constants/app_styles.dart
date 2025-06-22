// Styles and theme for Immuno Warriors.
//
// This file defines text styles and the application theme for UI consistency.
// Includes styles for text, buttons, cards, and feature-specific components.
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_sizes.dart';

class AppStyles {
  /// --- Text Styles ---
  /// Large title style for main headings (28pt, bold).
  static const TextStyle titleLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );

  /// Medium title style for subtitles (22pt, w600).
  static const TextStyle titleMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

  /// Small title style for minor headings (18pt, w500).
  static const TextStyle titleSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.text,
  );

  /// Large body style for primary content (16pt).
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: AppColors.text,
  );

  /// Medium body style for secondary content (14pt).
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: AppColors.text,
  );

  /// Small body style for captions (12pt, secondary text).
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  /// Button text style for action buttons (16pt, bold).
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.buttonTextColor,
  );

  /// Combat log text style for combat screen (14pt).
  static const TextStyle combatLogText = TextStyle(
    fontSize: AppSizes.combatLogTextSize,
    color: AppColors.textSecondary,
  );

  /// Research node title style for research tree (16pt, w600).
  static const TextStyle researchNodeTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

  /// --- Theme ---
  /// Application theme for consistent UI styling.
  static final ThemeData appTheme = ThemeData(
    primaryColor: AppColors.primary,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
    ),
    scaffoldBackgroundColor: AppColors.background,
    textTheme: TextTheme(
      displayLarge: titleLarge,
      displayMedium: titleMedium,
      displaySmall: titleSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.cardBackground,
      titleTextStyle: titleLarge,
      iconTheme: const IconThemeData(color: AppColors.text),
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonColor,
        foregroundColor: AppColors.buttonTextColor,
        textStyle: buttonText,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.buttonPaddingHorizontal,
          vertical: AppSizes.buttonPaddingVertical,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.textFieldBackground,
      hintStyle: TextStyle(color: AppColors.textFieldHintColor),
      labelStyle: TextStyle(color: AppColors.text),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.formFieldRadius),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.formFieldRadius),
        borderSide: BorderSide(color: AppColors.primary),
      ),
    ),
    cardTheme: CardTheme(
      color: AppColors.cardBackground,
      elevation: AppSizes.defaultElevation,
      margin: const EdgeInsets.all(AppSizes.marginMedium),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.defaultCardRadius),
      ),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.cardBackground,
      titleTextStyle: titleLarge,
      contentTextStyle: bodyMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.defaultCardRadius),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.cardBackground,
      contentTextStyle: bodyMedium,
      actionTextColor: AppColors.accent,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.defaultCardRadius),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.cardBackground,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      selectedLabelStyle: bodySmall,
      unselectedLabelStyle: bodySmall,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: AppColors.textFieldBackground,
    ),
  );
}
