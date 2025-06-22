import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:immuno_warriors/core/constants/app_assets.dart';
import 'package:immuno_warriors/core/constants/app_strings.dart';
import 'package:immuno_warriors/core/constants/app_sizes.dart';
import 'package:immuno_warriors/core/constants/app_animations.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/shared/ui/futuristic_text.dart';
import 'package:immuno_warriors/shared/widgets/animations/pulse_widget.dart';
import 'package:immuno_warriors/shared/widgets/cards/neon_card.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import '../buttons/holographic_button.dart';

/// Une carte dédiée pour ajouter un nouveau profil utilisateur.
///
/// Présente une animation Lottie et un texte invitant à créer un compte,
/// avec un style cohérent avec le thème Immuno Warriors.
class AddProfileCard extends StatelessWidget {
  final VoidCallback onPressed; // Callback appelé lors du clic sur la carte.
  final AnimationController
  addUserIconController; // Contrôleur pour l'animation de l'icône "ajouter utilisateur".
  final bool
  isCentered; // Indique si la carte est centrée (pour ajuster la taille de l'icône).

  const AddProfileCard({
    super.key,
    required this.onPressed,
    required this.addUserIconController,
    this.isCentered = false,
  });

  @override
  Widget build(BuildContext context) {
    // Ajuste la taille de l'animation Lottie en fonction de si la carte est centrée.
    final double lottieSize =
        isCentered
            ? AppSizes.addUserLottieSize * 1.5
            : AppSizes.addUserLottieSize;

    return FadeIn(
      duration:
          AppAnimations.cardAnimationDuration, // Durée d'animation d'entrée
      child: NeonCard(
        glowColor: AppColors.secondaryAccentColor, // Couleur de lueur néon
        intensity: 0.5,
        borderRadius: AppSizes.defaultCardRadius, // Rayon de bordure par défaut
        borderWidth:
            AppSizes.defaultBorderWidth, // Largeur de bordure par défaut
        enableGlow: true, // Active la lueur
        child: VirusButton(
          borderRadius:
              AppSizes.defaultCardRadius, // Rayon de bordure du bouton
          borderColor:
              AppColors.secondaryAccentColor, // Couleur de bordure du bouton
          elevation: AppSizes.defaultElevation, // Élévation du bouton
          onPressed: onPressed,
          child: SizedBox(
            height: AppSizes.userCardHeight, // Hauteur fixe pour la carte
            child: Padding(
              padding: const EdgeInsets.all(10), // Padding interne
              child: Column(
                // Changé en Column pour un meilleur agencement vertical
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Semantics(
                    label: AppStrings.addNewAccount,
                    child: PulseWidget(
                      controller:
                          addUserIconController, // Contrôleur de pulsation
                      minScale: 0.95,
                      maxScale: 1.05,
                      child: Image.asset(
                        AppAssets.splashVirus,
                        width: lottieSize,
                        height: lottieSize,
                        errorBuilder: (context, error, stackTrace) {
                          AppLogger.error(
                            'Error loading add user Lottie',
                            error: error,
                            stackTrace: stackTrace,
                          );
                          return Icon(
                            Icons
                                .person_add_alt_1_outlined, // Icône de fallback stylisée
                            color: AppColors.primaryColor,
                            size: lottieSize * 0.8,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 2), // Espacement
                  FuturisticText(
                    AppStrings.signInHere,
                    size:
                        18 *
                        MediaQuery.of(
                          context,
                        ).textScaleFactor, // Taille de texte augmentée
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColorSecondary, // Texte en vert virus
                    textAlign: TextAlign.center,
                    shadows: [
                      Shadow(
                        color: AppColors.primaryColor.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
