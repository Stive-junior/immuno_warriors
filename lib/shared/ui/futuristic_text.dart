import 'package:flutter/material.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';



/// Un widget de texte stylisé avec une police futuriste et un effet de lueur optionnel.
class FuturisticText extends StatelessWidget {
  final String text; // Le texte à afficher.
  final double? size; // Taille de la police.
  final FontWeight? fontWeight; // Poids de la police.
  final Color? color; // Couleur du texte.
  final TextAlign? textAlign; // Alignement du texte.
  final int? maxLines; // Nombre maximal de lignes.
  final TextOverflow? overflow; // Comportement en cas de débordement.
  final bool withGlow; // Active ou désactive l'effet de lueur.
  final List<Shadow>? shadows; // Ombres personnalisées (remplace withGlow si fourni).

  const FuturisticText(
      this.text, {
        super.key,
        this.size,
        this.fontWeight,
        this.color,
        this.textAlign,
        this.maxLines,
        this.overflow,
        this.withGlow = true, // Par défaut, la lueur est activée
        this.shadows, // Permet de fournir des ombres personnalisées
      });

  @override
  Widget build(BuildContext context) {
    // Détermine la couleur de base pour la lueur si des ombres ne sont pas fournies
    final Color glowBaseColor = color ?? AppColors.primaryColor; // Utilise la couleur du texte ou primaryColor pour la lueur

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontFamily: 'Rajdhani', // Utilisation de la police Rajdhani
        fontSize: size,
        fontWeight: fontWeight ?? FontWeight.w600, // Poids par défaut
        color: color ?? AppColors.textColorPrimary, // Couleur par défaut
        shadows: shadows ?? (withGlow
            ? [
          Shadow(
            color: glowBaseColor.withOpacity(0.7), // Lueur principale
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
          Shadow(
            color: glowBaseColor.withOpacity(0.3), // Lueur secondaire plus diffuse
            blurRadius: 20,
            offset: const Offset(0, 0),
          ),
        ]
            : null),
      ),
    );
  }
}
