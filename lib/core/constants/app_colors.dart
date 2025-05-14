import 'package:flutter/material.dart';

/// Définit la palette de couleurs de l'application.
class AppColors {
  // Couleurs principales
  static const Color primary = Color(0xFF007AFF); // Bleu principal (iOS)
  static const Color secondary = Color(0xFFFF3D00); // Rouge secondaire (accent)
  static const Color accent = Color(0xFFFFAB40); // Orange (accent supplémentaire)

  // Couleurs de base
  static const Color background = Color(0xFF121212); // Gris foncé (background)
  static const Color cardBackground = Color(0xFF1E1E1E); // Gris plus clair pour les cartes
  static const Color text = Colors.white; // Texte blanc
  static const Color textSecondary = Colors.grey; // Texte gris (secondaire)

  // Couleurs d'état
  static const Color success = Colors.green;
  static const Color error = Colors.redAccent;
  static const Color warning = Colors.amber;
  static const Color info = Colors.lightBlueAccent;

  // Couleurs pour les jauges et barres de progression
  static const Color energyColor = Colors.blueAccent;
  static const Color bioMaterialColor = Colors.greenAccent;
  static const Color healthBarColor = Colors.red;
  static const Color shieldColor = Colors.cyan;

  // Couleurs pour les types d'attaque
  static const Color physicalAttack = Colors.brown;
  static const Color chemicalAttack = Colors.limeAccent;
  static const Color energyAttack = Colors.purpleAccent;

  // Couleurs pour les interfaces
  static const Color buttonColor = primary;
  static const Color buttonTextColor = Colors.white;
  static const Color textFieldBackground = Color(0xFF272727);
  static const Color textFieldHintColor = Colors.grey;

  static const Gradient primaryGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const Gradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF000000), Color(0xFF222222)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}