import 'package:flutter/material.dart';
import 'package:immuno_warriors/shared/ui/app_styles.dart';
import 'package:immuno_warriors/core/constants/app_strings.dart';
import 'package:lottie/lottie.dart';

class EmptyState extends StatelessWidget {
  final String? message;
  final String? animationAsset; // Chemin vers l'asset Lottie
  final double? animationWidth; // Largeur de l'animation
  final double? animationHeight; // Hauteur de l'animation

  const EmptyState({
    super.key,
    this.message,
    this.animationAsset, // Utilise l'asset Lottie
    this.animationWidth,
    this.animationHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (animationAsset != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Lottie.asset( // Utilise Lottie.asset
                animationAsset!,
                width: animationWidth ?? 100,
                height: animationHeight ?? 100,
                fit: BoxFit.contain, // Assure que l'animation s'adapte à la taille
              ),
            ),
          Text(
            message ?? AppStrings.emptyState,
            style: AppStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}