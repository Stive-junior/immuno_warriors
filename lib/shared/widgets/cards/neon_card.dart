import 'package:flutter/material.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';


/// Une carte avec un effet de lueur néon autour de ses bords.
///
/// Idéale pour les éléments d'interface futuristes.
class NeonCard extends StatelessWidget {
  final Widget child; // Le contenu de la carte.
  final Color glowColor; // Couleur de la lueur néon.
  final double intensity; // Intensité de la lueur (0.0 à 1.0).
  final double borderRadius; // Rayon des bords de la carte.
  final double borderWidth; // Largeur de la bordure interne.
  final bool enableGlow; // Contrôle si la lueur est activée.

  const NeonCard({
    super.key,
    required this.child,
    this.glowColor = AppColors.primaryColor,
    this.intensity = 0.6, // Intensité par défaut
    this.borderRadius = 16, // Rayon par défaut
    this.borderWidth = 2.0, // Largeur de bordure par défaut
    this.enableGlow = true, // Par défaut, la lueur est activée
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: enableGlow ? [
          // Ombre principale pour la lueur
          BoxShadow(
            color: glowColor.withOpacity(intensity),
            blurRadius: 25, // Flou plus important pour une lueur diffuse
            spreadRadius: 5, // Étendue de la lueur
            offset: const Offset(0, 0), // Lueur centrée
          ),
          // Une ombre plus subtile pour donner de la profondeur (effet de surélévation)
          BoxShadow(
            color: AppColors.backgroundColor.withOpacity(0.3), // Utilisez backgroundColor
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
        ] : null, // Pas d'ombre si la lueur est désactivée
      ),
      child: ClipRRect( // ClipRRect pour s'assurer que le contenu respecte les bords arrondis
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: glowColor.withOpacity(0.5), // Bordure interne semi-transparente
              width: borderWidth,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            color: AppColors.backgroundColor.withOpacity(0.7), // Fond légèrement transparent
          ),
          child: child,
        ),
      ),
    );
  }
}
