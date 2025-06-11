import 'package:flutter/material.dart';

class AppColors {
  // **Primary Cyberpunk Colors**
  static const Color primaryColor = Color(0xFF00FFC6); // Electric Cyan
  static const Color primaryAccentColor = Color(0xFF64B5F6); // Bright Blue

  // **Secondary Dark Cyberpunk Colors**
  static const Color secondaryColor = Color(0xFF212121); // Dark Grey
  static const Color secondaryAccentColor = Color(0xFF424242); // Medium Grey
  static const Color backgroundColor = Color(0xFF0A0A0A); // Deep Black
  static const Color surfaceColor = Color(0xFF1E1E1E); // Dark Surface

  // **Text Colors**
  static const Color textColorPrimary = Colors.white;
  static const Color textColorSecondary = Color(0xFFBDBDBD); // Light Grey

  // **Functional Colors**
  static const Color healthColor = Color(0xFF4CAF50); // Green
  static const Color damageColor = Color(0xFFF44336); // Red
  static const Color defenseColor = Color(0xFF1976D2); // Dark Blue
  static const Color successColor = Color(0xFF8BC34A);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color borderColor = Color(0xFF37474F); // Dark Blue-Grey

  // **Special Cyberpunk Colors/Effects**
  static const Color glowEffect = Color(0x6600FFC6); // Glowing Cyan
  static const Color pathogenColor = Color(0xFFE64A19); // Deep Orange
  static const Color antibodyColor = Color(0xFF9C27B0); // Purple
  static const Color biohazardColor = Color(0xFFFFEB3B); // Yellow
  static const Color dnaColor = Color(0xFF00BCD4); // Cyan


  static const Color interfaceColorLight = Color(0xFFB2EBF2); // Cyan clair

  static const Color interfaceColorDark = Color(0xFF00BCD4); // Cyan plus soutenu


  static const Color shimmerBaseColor = Color(0xFF3A3A5D); // Gris foncé pour la base du shimmer
  static const Color shimmerHighlightColor = Color(0xFF5A5A8E); // Gris clair pour l'effet de lumière du shimmer

  static const Color buttonColor = Color(0xFF4A148C); // Couleur de bouton générique (un violet foncé)
  static const Color buttonAccentColor = Color(0xFFBBDEFB); // Accent lumineux pour les boutons


  // **Gradients (You might use these in backgrounds or specific UI elements)**
  static const LinearGradient primaryGradient = LinearGradient(
  colors: [primaryColor, primaryAccentColor],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
  colors: [secondaryColor, secondaryAccentColor],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
  );

  static const LinearGradient healthGradient = LinearGradient(
  colors: [Color(0xFF8BC34A), healthColor],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  );

  static const LinearGradient damageGradient = LinearGradient(
  colors: [Color(0xFFE57373), damageColor],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  );

  static const LinearGradient defenseGradient = LinearGradient(
  colors: [Color(0xFF64B5F6), defenseColor],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  );

  static const Color virusGreen = Color(0xFF00FFC6);
}