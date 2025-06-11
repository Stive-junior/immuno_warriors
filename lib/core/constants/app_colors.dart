/// Color palette for Immuno Warriors.
///
/// This file defines the colors used throughout the application.
import 'package:flutter/material.dart';

class AppColors {
  /// --- Primary Colors ---
  /// Main blue color (0xFF007AFF).
  static const Color primary = Color(0xFF007AFF);

  /// Secondary red color (0xFFFF3D00).
  static const Color secondary = Color(0xFFFF3D00);

  /// Accent orange color (0xFFFFAB40).
  static const Color accent = Color(0xFFFFAB40);

  /// --- Base Colors ---
  /// Dark background color (0xFF121212).
  static const Color background = Color(0xFF121212);

  /// Card background color (0xFF1E1E1E).
  static const Color cardBackground = Color(0xFF1E1E1E);

  /// Primary text color (white).
  static const Color text = Colors.white;

  /// Secondary text color (grey).
  static const Color textSecondary = Colors.grey;

  /// --- Status Colors ---
  /// Success color (green).
  static const Color success = Colors.green;

  /// Error color (redAccent).
  static const Color error = Colors.redAccent;

  /// Warning color (amber).
  static const Color warning = Colors.amber;

  /// Info color (lightBlueAccent).
  static const Color info = Colors.lightBlueAccent;

  /// --- Gauge and Progress Bar Colors ---
  /// Energy gauge color (blueAccent).
  static const Color energyColor = Colors.blueAccent;

  /// Bio-material gauge color (greenAccent).
  static const Color bioMaterialColor = Colors.greenAccent;

  /// Health bar color (red).
  static const Color healthBarColor = Colors.red;

  /// Shield color (cyan).
  static const Color shieldColor = Colors.cyan;

  /// --- Attack Type Colors ---
  /// Physical attack color (brown).
  static const Color physicalAttack = Colors.brown;

  /// Chemical attack color (limeAccent).
  static const Color chemicalAttack = Colors.limeAccent;

  /// Energy attack color (purpleAccent).
  static const Color energyAttack = Colors.purpleAccent;

  /// --- Interface Colors ---
  /// Button background color (primary).
  static const Color buttonColor = primary;

  /// Button text color (white).
  static const Color buttonTextColor = Colors.white;

  /// Text field background color (0xFF272727).
  static const Color textFieldBackground = Color(0xFF272727);

  /// Text field hint color (grey).
  static const Color textFieldHintColor = Colors.grey;

  /// --- Gradients ---
  /// Primary gradient from primary to accent.
  static const Gradient primaryGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Background gradient from black to dark grey.
  static const Gradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF000000), Color(0xFF222222)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
