// shared/widgets/loaders/circular_indicator.dart
import 'package:flutter/material.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart'; // Assurez-vous que ce chemin est correct

/// Un indicateur circulaire stylisé, souvent utilisé pour les avatars ou les chargements.
///
/// Il peut afficher une progression ou simplement servir de cadre décoratif
/// autour d'un enfant (par exemple, un avatar).
class CircularIndicator extends StatelessWidget {
  final Widget? child; // Le widget enfant à entourer par l'indicateur (ex: Lottie avatar).
  final double strokeWidth; // Épaisseur de la ligne de l'indicateur.
  final Animation<Color?>? valueColor; // Couleur animée de la progression.
  final Color? backgroundColor; // Couleur de fond de l'indicateur.
  final double size; // Taille totale de l'indicateur (largeur et hauteur).
  final double value; // Valeur de progression (0.0 à 1.0) si l'indicateur est un progress bar.
  final bool showProgress; // Indique si l'indicateur doit montrer une progression.

  const CircularIndicator({
    super.key,
    this.child,
    this.strokeWidth = 3.0, // Épaisseur par défaut
    this.valueColor,
    this.backgroundColor,
    this.size = 60.0, // Taille par défaut
    this.value = 0.0, // Valeur par défaut (pour progress bar)
    this.showProgress = false, // Par défaut, ne montre pas de progression
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle, // Forme circulaire
        boxShadow: [
          // Ombre interne pour un effet de profondeur
          BoxShadow(
            color: AppColors.backgroundColor.withOpacity(0.4),
            blurRadius: 10,
            spreadRadius: -2,
            offset: const Offset(0, 2),
          ),
          // Ombre externe pour la lueur
          BoxShadow(
            color: (valueColor?.value ?? AppColors.virusGreen).withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 3,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Fond de l'indicateur (le cercle complet)
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: showProgress ? value : null, // Affiche la progression si showProgress est vrai
              strokeWidth: strokeWidth,
              valueColor: valueColor ?? AlwaysStoppedAnimation<Color>(AppColors.virusGreen), // Couleur de la progression
              backgroundColor: backgroundColor ?? AppColors.secondaryColor.withOpacity(0.3), // Couleur du fond de l'indicateur
            ),
          ),
          // L'enfant, centré à l'intérieur de l'indicateur
          if (child != null)
            SizedBox(
              width: size - (strokeWidth * 2), // Taille de l'enfant ajustée pour la bordure
              height: size - (strokeWidth * 2),
              child: ClipOval( // Assure que l'enfant est également coupé en cercle
                child: child,
              ),
            ),
        ],
      ),
    );
  }
}
