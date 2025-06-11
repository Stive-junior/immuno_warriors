import 'dart:ui'; // Pour ImageFilter
import 'package:flutter/material.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart'; // Import de vos couleurs
import 'package:immuno_warriors/core/constants/app_sizes.dart'; // Import des tailles

/// Une carte avec un effet de verre dépoli (glassmorphism).
///
/// Applique un flou d'arrière-plan et une transparence pour créer un effet
/// de verre futuriste.
class GlassmorphismCard extends StatelessWidget {
  final Widget child; // Le contenu de la carte.
  final double blur; // Intensité du flou d'arrière-plan.
  final double opacity; // Opacité de la couleur de fond de la carte.
  final BorderRadius borderRadius; // Rayon des bords de la carte.
  final EdgeInsetsGeometry padding; // Padding interne du contenu.
  final EdgeInsetsGeometry margin; // Marge externe de la carte.
  final Color? borderColor; // Couleur de la bordure optionnelle.
  final double borderWidth; // Largeur de la bordure.

  const GlassmorphismCard({
    super.key,
    required this.child,
    this.blur = 15, // Flou par défaut augmenté pour un effet plus prononcé
    this.opacity = 0.2, // Opacité par défaut augmentée
    this.borderRadius = const BorderRadius.all(Radius.circular(AppSizes.defaultCardRadius)), // Utilisation de constante
    this.padding = const EdgeInsets.all(AppSizes.paddingMedium), // Utilisation de constante
    this.margin = const EdgeInsets.all(AppSizes.marginSmall), // Utilisation de constante
    this.borderColor,
    this.borderWidth = 1.5, // Largeur de bordure légèrement augmentée
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: borderColor != null
            ? Border.all(color: borderColor!, width: borderWidth)
            : Border.all(color: AppColors.borderColor.withOpacity(0.5), width: borderWidth), // Bordure par défaut stylisée
        boxShadow: [ // Ajout d'une ombre subtile pour la profondeur
          BoxShadow(
            color: AppColors.backgroundColor.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: AppColors.backgroundColor.withOpacity(opacity), // Couleur de fond avec opacité
              borderRadius: borderRadius,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
