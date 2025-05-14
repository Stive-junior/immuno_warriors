import 'package:flutter/material.dart';

class AppColors {
  // **Gradients**

  // Gradient Primaire (Cyan -> Teal)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF64FFDA), Color(0xFF00BFA5)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Gradient Secondaire (Gris Foncé -> Gris Clair)
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF212121), Color(0xFF424242)],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  // Gradient d'Interface (Cyan Clair -> Cyan Soutenu)
  static const LinearGradient interfaceGradient = LinearGradient(
    colors: [Color(0xFFB2EBF2), Color(0xFF00BCD4)],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  // Gradient Santé (Vert Clair -> Vert Foncé)
  static const LinearGradient healthGradient = LinearGradient(
    colors: [Color(0xFF8BC34A), Color(0xFF4CAF50)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Gradient Dégâts (Rouge Clair -> Rouge Foncé)
  static const LinearGradient damageGradient = LinearGradient(
    colors: [Color(0xFFF44336), Color(0xFFD32F2F)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Gradient Défense (Bleu Clair -> Bleu Foncé)
  static const LinearGradient defenseGradient = LinearGradient(
    colors: [Color(0xFF29B6F6), Color(0xFF2196F3)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );



  static const Color primaryColor = Color(0xFF64FFDA); // Cyan vif (cyber)
  static const Color primaryAccentColor = Color(0xFF00BFA5); // Teal plus foncé
  static const Color secondaryColor = Color(0xFF212121); // Gris foncé (cyber)
  static const Color secondaryAccentColor = Color(0xFF424242); // Gris plus clair
  static const Color backgroundColor = Color(0xFF121212); // Noir profond (cyber)
  static const Color textColorPrimary = Colors.white;
  static const Color textColorSecondary = Colors.grey;
  static const Color healthColor = Color(0xFF4CAF50); // Vert sain
  static const Color damageColor = Color(0xFFF44336); // Rouge danger
  static const Color defenseColor = Color(0xFF2196F3); // Bleu protection
  static const Color successColor = Color(0xFF8BC34A);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color interfaceColorLight = Color(0xFFB2EBF2); // Cyan clair
  static const Color interfaceColorDark = Color(0xFF00BCD4); // Cyan plus soutenu
  static const Color borderColor = Color(0xFF37474F); // Gris bleuté pour les bordures

}