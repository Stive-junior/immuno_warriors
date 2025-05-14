import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/shared/ui/app_styles.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    // Utiliser un thème sombre comme base pour le style futuriste
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryColor,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
      background: AppColors.backgroundColor,
      brightness: Brightness.dark, // Important pour les composants Material
    ),
    scaffoldBackgroundColor: AppColors.backgroundColor,
    textTheme: TextTheme(
      displayLarge: AppStyles.titleLarge,
      displayMedium: AppStyles.titleMedium,
      displaySmall: AppStyles.titleSmall,
      bodyLarge: AppStyles.bodyLarge,
      bodyMedium: AppStyles.bodyMedium,
      bodySmall: AppStyles.bodySmall,
      titleLarge: AppStyles.accentLarge,
      titleMedium: AppStyles.accentMedium,
      titleSmall: AppStyles.accentSmall,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: AppStyles.buttonText,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
    // Définir la couleur des icônes par défaut
    iconTheme: const IconThemeData(
      color: AppColors.textColorPrimary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.secondaryColor,
      elevation: 2.0,
      titleTextStyle: AppStyles.titleMedium,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Couleur de la barre d'état
        statusBarIconBrightness: Brightness.light, // Icônes de la barre d'état (light ou dark)
        statusBarBrightness: Brightness.dark, // Couleur de fond de la barre d'état (light ou dark)
      ),
    ),
    // Définir le style des cartes (Card widget)
    cardTheme: CardTheme(
      color: AppColors.secondaryColor,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    // Définir le style des boîtes de dialogue (Dialog widget)
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.secondaryColor,
      titleTextStyle: AppStyles.titleMedium,
      contentTextStyle: AppStyles.bodyMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),
    // Définir le style des champs de texte (TextField widget)
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: AppStyles.bodyMedium.copyWith(color: AppColors.textColorSecondary),
      hintStyle: AppStyles.bodyMedium.copyWith(color: AppColors.textColorSecondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: AppColors.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: AppColors.primaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: AppColors.borderColor),
      ),
    ),
    // Ajoute d'autres thèmes pour les différents widgets au besoin
  );
}