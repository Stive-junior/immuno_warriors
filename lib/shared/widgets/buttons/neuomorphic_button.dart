import 'package:flutter/material.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart'; // Assurez-vous que ce chemin est correct

/// Un bouton de style Neumorphic avec des effets d'ombre et de lumière.
///
/// Ce widget crée un bouton avec un aspect "doux" ou "futuriste"
/// qui réagit visuellement à la pression de l'utilisateur.
class NeuomorphicButton extends StatefulWidget {
  final VoidCallback? onPressed; // Callback appelé lors du clic sur le bouton.
  final Widget child; // Le contenu du bouton (texte, icône, etc.).
  final BorderRadius borderRadius; // Rayon des bords du bouton.
  final double depth; // Intensité de la profondeur de l'effet neumorphic.
  final double intensity; // Intensité de la lumière du haut-gauche.
  final double blur; // Flou des ombres.
  final Color color; // Couleur de base du bouton.
  final double size; // Taille fixe (largeur et hauteur) du bouton, le rendant carré.
  final EdgeInsetsGeometry? padding; // Padding interne du contenu.

  const NeuomorphicButton({
    super.key,
    required this.onPressed, // Le callback onPressed est requis.
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(16.0)), // Bords arrondis par défaut
    this.depth = 8.0, // Profondeur par défaut
    this.intensity = 0.6, // Intensité de la lumière par défaut
    this.blur = 15.0, // Flou par défaut
    this.color = AppColors.secondaryColor, // Couleur par défaut issue de AppColors
    this.size = 200, // La taille est maintenant requise pour un bouton carré
    this.padding, // Padding optionnel
  });

  @override
  State<NeuomorphicButton> createState() => _NeuomorphicButtonState();
}

class _NeuomorphicButtonState extends State<NeuomorphicButton> {
  bool _isPressed = false; // État pour suivre si le bouton est pressé ou non.

  /// Gère l'événement de "tap down" (pression initiale).
  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null) {
      setState(() {
        _isPressed = true;
      });
    }
  }

  /// Gère l'événement de "tap up" (relâchement).
  void _handleTapUp(TapUpDetails details) {
    if (widget.onPressed != null) {
      setState(() {
        _isPressed = false;
      });
      widget.onPressed?.call(); // Déclenche le callback onPressed.
    }
  }

  /// Gère l'événement d'annulation du "tap" (ex: glissement du doigt hors du bouton).
  void _handleTapCancel() {
    if (widget.onPressed != null) {
      setState(() {
        _isPressed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Couleurs d'ombre et de lumière pour l'effet neumorphic, basées sur AppColors
    final Color shadowColor = widget.color.withOpacity(0.6); // Ombre plus foncée
    final Color highlightColor = AppColors.primaryAccentColor.withOpacity(0.8); // Lumière vive

    // Ajustement dynamique de la profondeur et du flou lors de la pression
    final currentDepth = _isPressed ? widget.depth * 0.5 : widget.depth;
    final currentBlur = _isPressed ? widget.blur * 0.7 : widget.blur;

    return GestureDetector(
      onTapDown: _handleTapDown, // Détecte la pression initiale
      onTapUp: _handleTapUp,     // Détecte le relâchement
      onTapCancel: _handleTapCancel, // Détecte l'annulation de la pression
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150), // Durée de l'animation pour un effet de pression fluide
        width: widget.size, // Largeur fixe définie par la propriété size
        height: widget.size, // Hauteur fixe définie par la propriété size (rend le bouton carré)
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius, // Applique le rayon de bordure
          color: widget.color, // Couleur de base du bouton
          boxShadow: [
            // Ombre sombre (en bas à droite)
            BoxShadow(
              offset: Offset(currentDepth, currentDepth),
              blurRadius: currentBlur,
              color: shadowColor,
            ),
            // Lumière claire (en haut à gauche)
            BoxShadow(
              offset: Offset(-currentDepth * widget.intensity, -currentDepth * widget.intensity),
              blurRadius: currentBlur,
              color: highlightColor,
            ),
          ],
        ),
        child: Padding(
          // Padding interne : utilise le padding fourni ou un padding par défaut basé sur la profondeur actuelle
          padding: widget.padding ?? EdgeInsets.all(currentDepth / 2),
          child: Center(child: widget.child), // Centre le contenu du bouton
        ),
      ),
    );
  }
}