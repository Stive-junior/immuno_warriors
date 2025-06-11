import 'package:flutter/material.dart';
import 'package:immuno_warriors/core/constants/app_sizes.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/shared/widgets/cards/neon_card.dart';
import 'package:immuno_warriors/shared/widgets/loaders/shimmer_loader.dart';
import 'package:immuno_warriors/core/constants/app_animations.dart'; // Import AppAnimations

/// Un effet de scintillement (shimmer) pour les cartes de profil utilisateur
/// pendant le chargement des données.
/// Utilise NeonCard pour maintenir la cohérence stylistique.
class ProfileCardShimmer extends StatelessWidget {
  const ProfileCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      glowColor: AppColors.virusGreen, // Couleur de lueur cohérente
      intensity: 0.5,
      borderRadius: AppSizes.defaultCardRadius, // Utilise la taille constante
      borderWidth: AppSizes.defaultBorderWidth, // Utilise la taille constante
      child: SizedBox(
        height: AppSizes.userCardHeight, // Hauteur cohérente avec UserProfileCard
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding cohérent
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Shimmer pour l'avatar circulaire
              ShimmerLoader(
                baseColor: AppColors.shimmerBaseColor,
                highlightColor: AppColors.shimmerHighlightColor,
                duration: AppAnimations.shimmerDuration, // Utilise la durée constante
                child: CircleAvatar(
                  radius: AppSizes.avatarSize / 2, // Rayon cohérent avec avatar réel
                  backgroundColor: AppColors.secondaryColor.withOpacity(0.5), // Couleur de fond pour le shimmer
                ),
              ),
              const Spacer(), // Prend l'espace disponible
              // Shimmer pour le nom d'utilisateur
              ShimmerLoader(
                baseColor: AppColors.shimmerBaseColor,
                highlightColor: AppColors.shimmerHighlightColor,
                duration: AppAnimations.shimmerDuration,
                child: SizedBox(
                  width: 120, // Largeur indicative pour le nom
                  height: 18, // Hauteur indicative pour le nom
                  child: ColoredBox(color: AppColors.secondaryColor.withOpacity(0.5)),
                ),
              ),
              const SizedBox(height: 8), // Espacement cohérent
              // Shimmer pour l'email
              ShimmerLoader(
                baseColor: AppColors.shimmerBaseColor,
                highlightColor: AppColors.shimmerHighlightColor,
                duration: AppAnimations.shimmerDuration,
                child: SizedBox(
                  width: 160, // Largeur indicative pour l'email
                  height: 14, // Hauteur indicative pour l'email
                  child: ColoredBox(color: AppColors.secondaryColor.withOpacity(0.5)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
