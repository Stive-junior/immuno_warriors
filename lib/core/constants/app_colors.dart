// Color palette for Immuno Warriors.
//
// This file defines the colors used throughout the application for UI consistency.
// Includes colors for UI elements, status indicators, and feature-specific components.
import 'package:flutter/material.dart';

class AppColors {
  /// --- Primary Colors ---
  /// Main blue color for primary UI elements (0xFF007AFF).
  static const Color primary = Color(0xFF007AFF);

  /// Secondary red color for highlights (0xFFFF3D00).
  static const Color secondary = Color(0xFFFF3D00);

  /// Accent orange color for emphasis (0xFFFFAB40).
  static const Color accent = Color(0xFFFFAB40);

  /// --- Base Colors ---
  /// Dark background color for app scaffold (0xFF121212).
  static const Color background = Color(0xFF121212);

  /// Card background color for cards and dialogs (0xFF1E1E1E).
  static const Color cardBackground = Color(0xFF1E1E1E);

  /// Primary text color for readability (white).
  static const Color text = Colors.white;

  /// Secondary text color for subtitles (grey).
  static const Color textSecondary = Colors.grey;

  /// --- Status Colors ---
  /// Success color for positive feedback (green).
  static const Color success = Colors.green;

  /// Error color for error states (redAccent).
  static const Color error = Colors.redAccent;

  /// Warning color for alerts (amber).
  static const Color warning = Colors.amber;

  /// Info color for informational messages (lightBlueAccent).
  static const Color info = Colors.lightBlueAccent;

  /// --- Gauge and Progress Bar Colors ---
  /// Energy gauge color for resource indicators (blueAccent).
  static const Color energyColor = Colors.blueAccent;

  /// Bio-material gauge color for resources (greenAccent).
  static const Color bioMaterialColor = Colors.greenAccent;

  /// Health bar color for combat units (red).
  static const Color healthBarColor = Colors.red;

  /// Shield color for defensive units (cyan).
  static const Color shieldColor = Colors.cyan;

  /// Research progress color for research tree (teal).
  static const Color researchProgressColor = Colors.teal;

  /// --- Attack Type Colors ---
  /// Physical attack color for combat (brown).
  static const Color physicalAttack = Colors.brown;

  /// Chemical attack color for combat (limeAccent).
  static const Color chemicalAttack = Colors.limeAccent;

  /// Energy attack color for combat (purpleAccent).
  static const Color energyAttack = Colors.purpleAccent;

  /// --- Interface Colors ---
  /// Button background color (uses primary).
  static const Color buttonColor = primary;

  /// Button text color for contrast (white).
  static const Color buttonTextColor = Colors.white;

  /// Text field background color for forms (0xFF272727).
  static const Color textFieldBackground = Color(0xFF272727);

  /// Text field hint color for placeholders (grey).
  static const Color textFieldHintColor = Colors.grey;

  /// Disabled button color for inactive states (grey).
  static const Color disabledButtonColor = Colors.grey;

  /// Combat victory highlight color (gold).
  static const Color combatVictoryColor = Color(0xFFFFD700);

  /// Threat level critical color (deepOrange).
  static const Color threatCriticalColor = Colors.deepOrange;

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
  static const Color successColor = Color(0xFF8BC34A); // A vibrant success green
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


  static const Color buttonAccentColor = Color(0xFFBBDEFB); // Accent lumineux pour les boutons

  static const Color virusGreen = Color(0xFF00FFC6); // Consistent with primaryColor for a "virus" theme.


  /// --- Gradients ---
  /// Primary gradient from primary to accent for buttons and cards.
  static const Gradient primaryGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Background gradient from black to dark grey for scaffold.
  static const Gradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF000000), Color(0xFF222222)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Combat effect gradient for attack animations.
  static const Gradient combatGradient = LinearGradient(
    colors: [secondary, Colors.yellow],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Research gradient for progress bars.
  static const Gradient researchGradient = LinearGradient(
    colors: [Colors.teal, Colors.cyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
