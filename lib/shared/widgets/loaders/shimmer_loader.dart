import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/core/constants/app_animations.dart'; // Import AppAnimations pour la durée

/// Un widget de chargement Shimmer pour un effet visuel de "squelette" en attente de contenu.
/// Permet de personnaliser les couleurs et la durée de l'animation.
class ShimmerLoader extends StatelessWidget {
  final Widget child; // Le widget à afficher avec l'effet shimmer.
  final Color? baseColor; // Couleur de base du shimmer.
  final Color? highlightColor; // Couleur de l'effet de lumière du shimmer.
  final Duration? duration; // Durée de l'animation shimmer.

  const ShimmerLoader({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration, // Ajout de la propriété duration
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? AppColors.shimmerBaseColor, // Utilise la couleur de base définie dans AppColors
      highlightColor: highlightColor ?? AppColors.shimmerHighlightColor, // Utilise la couleur de highlight définie dans AppColors
      period: duration ?? AppAnimations.shimmerDuration, // Utilise la durée fournie ou la constante par défaut
      child: child,
    );
  }
}
