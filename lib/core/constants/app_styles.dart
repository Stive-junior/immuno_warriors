/// Styles and theme for Immuno Warriors.
///
/// This file defines text styles and the application theme.
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_assets.dart';

class AppStyles {
  /// --- Text Styles ---
  /// Large title style (28pt, bold).
  static const TextStyle titleLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
    fontFamily: AppAssets.titleFont,
  );

  /// Medium title style (22pt, w600).
  static const TextStyle titleMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
    fontFamily: AppAssets.titleFont,
  );

  /// Small title style (18pt, w500).
  static const TextStyle titleSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.text,
    fontFamily: AppAssets.titleFont,
  );

  /// Large body style (16pt).
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: AppColors.text,
    fontFamily: AppAssets.mainFont,
  );

  /// Medium body style (14pt, secondary text).
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
    fontFamily: AppAssets.mainFont,
  );

  /// Small body style (12pt, secondary text).
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
    fontFamily: AppAssets.mainFont,
  );

  /// Button text style (16pt, bold).
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.buttonTextColor,
    fontFamily: AppAssets.mainFont,
  );

  /// --- Theme ---
  /// Application theme.
  static final ThemeData appTheme = ThemeData(
    primaryColor: AppColors.primary,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
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
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.cardBackground,
      titleTextStyle: titleLarge,
      iconTheme: IconThemeData(color: AppColors.text),
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonColor,
        foregroundColor: AppColors.buttonTextColor,
        textStyle: buttonText,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.textFieldBackground,
      hintStyle: TextStyle(color: AppColors.textFieldHintColor),
      labelStyle: TextStyle(color: AppColors.text),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primary),
      ),
    ),
    cardTheme: CardTheme(
      color: AppColors.cardBackground,
      elevation: 4,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.cardBackground,
      titleTextStyle: titleLarge,
      contentTextStyle: bodyMedium,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.cardBackground,
      contentTextStyle: bodyMedium,
      actionTextColor: AppColors.accent,
      behavior: SnackBarBehavior.floating,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.cardBackground,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      selectedLabelStyle: bodySmall,
      unselectedLabelStyle: bodySmall,
    ),
  );
}
