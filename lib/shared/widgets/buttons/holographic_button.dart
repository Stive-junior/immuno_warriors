// shared/widgets/buttons/virus_button.dart
import 'package:flutter/material.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart'; // Assurez-vous que ce chemin est correct

/// Un bouton de style futuriste avec un dégradé et une bordure lumineuse.
///
/// Ce bouton réagit visuellement à la pression de l'utilisateur.
/// Pour une pulsation, enveloppez-le dans un `PulseWidget`.
class VirusButton extends StatefulWidget {
  final Widget child; // Le contenu du bouton (texte, icône, Lottie, etc.).
  final VoidCallback? onPressed; // Callback appelé lors du clic sur le bouton.
  final double borderRadius; // Rayon des bords du bouton.
  final Color borderColor; // Couleur de la bordure lumineuse.
  final double elevation; // Intensité de l'ombre portée.
  final double? width; // Largeur optionnelle du bouton.
  final double? height; // Hauteur optionnelle du bouton.
  final double? size; // Taille fixe (largeur et hauteur) pour un bouton carré.

  const VirusButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.borderRadius = 12,
    this.borderColor = AppColors.virusGreen, // Couleur de bordure par défaut
    this.elevation = 8,
    this.width,
    this.height,
    this.size, // Ajout de l'argument size
  }) : assert(
  size == null || (width == null && height == null),
  'Cannot specify both size and width/height. Use size for square buttons.',
  );

  @override
  State<VirusButton> createState() => _VirusButtonState();
}

class _VirusButtonState extends State<VirusButton> {
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
    // Détermine la taille du bouton
    final double? currentWidth = widget.size ?? widget.width;
    final double? currentHeight = widget.size ?? widget.height;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150), // Durée de l'animation pour un effet de pression fluide
        width: currentWidth, // Utilise la largeur ou la taille
        height: currentHeight, // Utilise la hauteur ou la taille
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.secondaryColor.withOpacity(_isPressed ? 0.7 : 0.8), // Plus transparent si pressé
              AppColors.backgroundColor.withOpacity(_isPressed ? 0.6 : 0.7), // Plus transparent si pressé
            ],
          ),
          border: Border.all(
            color: widget.borderColor.withOpacity(_isPressed ? 0.7 : 1.0), // Bordure moins opaque si pressé
            width: _isPressed ? 1.5 : 2.0, // Bordure plus fine si pressé
          ),
          boxShadow: [
            BoxShadow(
              color: widget.borderColor.withOpacity(_isPressed ? 0.2 : 0.4), // Ombre moins intense si pressé
              blurRadius: _isPressed ? widget.elevation * 0.7 : widget.elevation, // Moins de flou si pressé
              spreadRadius: _isPressed ? 0.5 : 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: widget.child,
        ),
      ),
    );
  }
}
