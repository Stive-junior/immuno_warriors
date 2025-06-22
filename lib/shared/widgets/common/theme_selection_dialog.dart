
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart'; // Pour les animations d'entrée comme FadeIn
import 'package:immuno_warriors/core/constants/app_sizes.dart'; // Import des tailles constantes
import 'package:immuno_warriors/core/constants/app_animations.dart'; // Import des durées d'animation
import 'package:immuno_warriors/core/constants/app_strings.dart'; // Import des chaînes de texte
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/shared/ui/futuristic_text.dart'; // Pour le texte stylisé
import 'package:immuno_warriors/shared/widgets/animations/pulse_widget.dart'; // Pour l'effet de pulsation
import 'package:immuno_warriors/shared/widgets/cards/neon_card.dart'; // Pour le conteneur du dialogue
import 'package:immuno_warriors/core/utils/app_logger.dart';

/// Un dialogue de sélection de thème stylisé et responsif avec des animations futuristes.
///
/// Permet à l'utilisateur de choisir entre les thèmes clair, sombre ou système.
class ThemeSelectionDialog extends StatelessWidget {
  final AnimationController themeIconController; // Contrôleur pour les animations Lottie des icônes de thème
  final Function(ThemeMode) onThemeSelected; // Callback déclenché lorsque l'utilisateur sélectionne un thème

  const ThemeSelectionDialog({
    super.key,
    required this.themeIconController,
    required this.onThemeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FadeIn( // Anime l'entrée du dialogue
      duration: AppAnimations.dialogAnimationDuration, // Durée de l'animation d'entrée
      child: Dialog(
        backgroundColor: Colors.transparent, // Rendre l'arrière-plan du dialogue transparent
        insetPadding: const EdgeInsets.all(AppSizes.paddingLarge), // Marge interne autour du dialogue
        child: NeonCard( // Utilise NeonCard pour le conteneur principal du dialogue
          glowColor: AppColors.virusGreen, // Couleur de lueur du dialogue
          intensity: 0.6,
          borderRadius: AppSizes.defaultCardRadius, // Rayon de bordure du dialogue
          borderWidth: AppSizes.defaultBorderWidth, // Largeur de bordure du dialogue
          enableGlow: true, // Active l'effet de lueur
          child: Container(
            padding: const EdgeInsets.all(AppSizes.paddingMedium), // Padding interne du contenu du dialogue
            constraints: const BoxConstraints(
              maxWidth: AppSizes.tabletBreakpoint, // Largeur maximale pour les tablettes
              minWidth: 280, // Largeur minimale pour éviter un dialogue trop petit
            ),
            child: Stack( // Utilise Stack pour positionner le titre et le bouton de fermeture
              children: [
                // Titre du dialogue
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppSizes.paddingSmall),
                    child: FuturisticText(
                      AppStrings.theme, // Texte: "Select Theme"
                      size: AppSizes.fontSizeLarge,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColorPrimary,
                      shadows: [
                        Shadow(
                          color: AppColors.virusGreen.withOpacity(0.5), // Lueur du titre
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                // Bouton de fermeture (icône X en haut à droite)
                Positioned(
                  top: AppSizes.paddingSmall,
                  right: AppSizes.paddingSmall,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context), // Ferme le dialogue au clic
                    child: Container(
                      padding: const EdgeInsets.all(AppSizes.paddingSmall / 2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.secondaryColor.withOpacity(0.3),
                        border: Border.all(
                          color: AppColors.virusGreen.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.close, // Icône de fermeture
                        color: AppColors.virusGreen,
                        size: AppSizes.iconSizeMedium,
                      ),
                    ),
                  ),
                ),

                // Options de thème (centrées et responsives)
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppSizes.paddingLarge * 2, // Espace pour le titre
                    bottom: AppSizes.paddingMedium,
                  ),
                  child: Center( // Centre les options horizontalement
                    child: Wrap( // Permet aux éléments de s'enrouler sur plusieurs lignes
                      alignment: WrapAlignment.center, // Centre les éléments dans le Wrap
                      spacing: AppSizes.paddingLarge, // Espacement horizontal entre les éléments
                      runSpacing: AppSizes.paddingLarge, // Espacement vertical entre les lignes
                      children: [
                        _buildThemeOption(
                          context,
                          'assets/animations/light_theme.json',
                          Icons.light_mode,
                          ThemeMode.light,
                          AppStrings.lightTheme, // Libellé "Light"
                          themeIconController,
                          onThemeSelected,
                        ),
                        _buildThemeOption(
                          context,
                          'assets/animations/dark_theme.json',
                          Icons.dark_mode,
                          ThemeMode.dark,
                          AppStrings.darkTheme, // Libellé "Dark"
                          themeIconController,
                          onThemeSelected,
                        ),
                        _buildThemeOption(
                          context,
                          'assets/animations/system_theme.json',
                          Icons.settings_suggest,
                          ThemeMode.system,
                          AppStrings.systemTheme, // Libellé "System"
                          themeIconController,
                          onThemeSelected,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Construit une option de thème individuelle (icône Lottie + texte).
  Widget _buildThemeOption(
      BuildContext context,
      String lottieAsset,
      IconData fallbackIcon,
      ThemeMode themeMode,
      String label, // Texte à afficher sous l'icône
      AnimationController controller, // Contrôleur d'animation pour l'icône
      Function(ThemeMode) onSelect, // Callback de sélection
      ) {
    return GestureDetector(
      onTap: () {
        AppLogger.info('Theme selected: $themeMode');
        onSelect(themeMode); // Appelle le callback de sélection
        Navigator.pop(context); // Ferme le dialogue
      },
      child: Column( // Empile l'icône et le texte verticalement
        mainAxisSize: MainAxisSize.min, // Occupe le minimum d'espace vertical
        children: [
          PulseWidget( // Ajoute un effet de pulsation à l'icône
            controller: controller, // Utilise le contrôleur passé
            minScale: 0.95,
            maxScale: 1.05,
            child: Container(
              padding: const EdgeInsets.all(AppSizes.paddingMedium),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryColor.withOpacity(0.3), // Fond de l'icône
                border: Border.all(
                  color: AppColors.virusGreen.withOpacity(0.5), // Bordure de l'icône
                  width: AppSizes.defaultBorderWidth / 2, // Bordure plus fine
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.virusGreen.withOpacity(0.2), // Lueur de l'icône
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Lottie.asset(
                lottieAsset, // Chemin de l'animation Lottie
                width: AppSizes.iconSizeLarge * 1.5, // Taille des icônes Lottie
                height: AppSizes.iconSizeLarge * 1.5,
                controller: controller, // Contrôleur pour l'animation Lottie
                repeat: true,
                errorBuilder: (context, error, stackTrace) {
                  AppLogger.error('Error loading Lottie: $lottieAsset',
                      error: error, stackTrace: stackTrace);
                  return Icon(
                    fallbackIcon, // Icône de secours si Lottie ne charge pas
                    color: AppColors.virusGreen,
                    size: AppSizes.iconSizeLarge * 1.5,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: AppSizes.spaceSmall), // Espacement entre l'icône et le texte
          FuturisticText(
            label, // Texte de l'option de thème
            size: AppSizes.fontSizeMedium, // Taille de texte cohérente
            color: AppColors.textColorSecondary,
            textAlign: TextAlign.center,
            shadows: [
              Shadow(
                color: AppColors.primaryColor.withOpacity(0.1), // Lueur subtile pour le texte
                blurRadius: 5,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
