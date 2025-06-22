import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart'; // Pour les animations d'entrée
import 'package:immuno_warriors/core/constants/app_assets.dart';
import 'package:immuno_warriors/core/constants/app_strings.dart';
import 'package:immuno_warriors/core/constants/app_sizes.dart'; // Import des tailles constantes
import 'package:immuno_warriors/core/constants/app_animations.dart'; // Import des durées d'animation
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/shared/ui/futuristic_text.dart';
import 'package:immuno_warriors/shared/widgets/animations/pulse_widget.dart';
import 'package:immuno_warriors/shared/widgets/cards/neon_card.dart';
import 'package:immuno_warriors/shared/widgets/loaders/circular_indicator.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

import '../../../domain/entities/user_entity.dart';
import '../buttons/holographic_button.dart';

/// Une carte de profil utilisateur stylisée avec des effets futuristes.
///
/// Affiche l'avatar, le nom d'utilisateur et l'e-mail, avec des animations
/// et un style cohérent avec le thème Immuno Warriors.
class UserProfileCard extends StatelessWidget {
  final UserEntity user; // L'entité utilisateur à afficher.
  final AnimationController
  avatarController; // Contrôleur pour l'animation de pulsation de l'avatar.
  final VoidCallback onPressed; // Callback appelé lors du clic sur la carte.

  const UserProfileCard({
    super.key,
    required this.user,
    required this.avatarController,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: AppAnimations.cardAnimationDuration,
      child: NeonCard(
        glowColor: AppColors.virusGreen, // Couleur de lueur néon
        intensity: 0.5,
        borderRadius: AppSizes.defaultCardRadius, // Rayon de bordure par défaut
        borderWidth:
            AppSizes.defaultBorderWidth, // Largeur de bordure par défaut
        enableGlow: true, // Active la lueur
        child: VirusButton(
          borderRadius:
              AppSizes.defaultCardRadius, // Rayon de bordure du bouton
          borderColor: AppColors.virusGreen, // Couleur de bordure du bouton
          elevation: AppSizes.defaultElevation, // Élévation du bouton
          onPressed: onPressed,
          // Le VirusButton prendra la taille de son enfant si width/height/size ne sont pas spécifiés.
          // Ici, SizedBox donne une hauteur fixe à l'enfant du bouton.
          child: SizedBox(
            height:
                AppSizes.userCardHeight, // Hauteur fixe pour la carte de profil
            child: Padding(
              padding: const EdgeInsets.all(16.0), // Padding interne
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag:
                        'avatar-${user.id}', // Tag unique pour l'animation Hero
                    child: CircularIndicator(
                      size:
                          AppSizes.avatarSize *
                          1.3, // Taille de l'indicateur augmentée
                      strokeWidth: 4, // Épaisseur de trait augmentée
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.virusGreen.withOpacity(0.8),
                      ),
                      backgroundColor: AppColors.secondaryColor.withOpacity(
                        0.4,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppSizes.avatarSize * 0.65,
                        ), // Rayon adapté à la nouvelle taille
                        child: Semantics(
                          label:
                              '${AppStrings.appName} ${user.username ?? AppStrings.unknownUser}',
                          child: PulseWidget(
                            controller:
                                avatarController, // Contrôleur de pulsation de l'avatar
                            minScale: 0.95,
                            maxScale: 1.05,
                            child: Lottie.asset(
                              user.avatar ??
                                  AppAssets
                                      .userAvatarAnimation, // URL de l'avatar ou fallback
                              width:
                                  AppSizes.avatarSize *
                                  1.1, // Lottie légèrement plus petit que l'indicateur
                              height: AppSizes.avatarSize * 1.1,
                              fit: BoxFit.contain,
                              repeat: true,
                              controller: avatarController,
                              errorBuilder: (context, error, stackTrace) {
                                AppLogger.error(
                                  'Error loading avatar Lottie for ${user.username}',
                                  error: error,
                                  stackTrace: stackTrace,
                                );
                                return Icon(
                                  Icons
                                      .person_pin_circle_outlined, // Icône de fallback stylisée
                                  color: AppColors.textColorSecondary,
                                  size: AppSizes.avatarSize * 1.1,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(), // Prend l'espace disponible
                  FuturisticText(
                    user.username ?? AppStrings.unknownUser,
                    size:
                        18 *
                        MediaQuery.of(
                          context,
                        ).textScaleFactor, // Taille de texte augmentée
                    fontWeight: FontWeight.w700, // Texte plus gras
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    color: AppColors.textColorPrimary,
                    shadows: [
                      Shadow(
                        color: AppColors.virusGreen.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8), // Espacement
                  FuturisticText(
                    user.email,
                    size:
                        14 *
                        MediaQuery.of(
                          context,
                        ).textScaleFactor, // Taille de texte augmentée
                    color: AppColors.textColorSecondary.withOpacity(0.8),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    shadows: [
                      Shadow(
                        color: AppColors.primaryColor.withOpacity(0.2),
                        blurRadius: 5,
                        offset: const Offset(0, 1),
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
