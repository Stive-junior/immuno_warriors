import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';



class AnimatedIconButton extends StatefulWidget {
  final String animationAsset; // Chemin de l'asset Lottie.
  final String? tooltip; // Texte d'info-bulle affiché au survol.
  final VoidCallback? onPressed; // Callback appelé lors du clic sur le bouton.
  final double size; // Taille totale du bouton (largeur et hauteur).
  final Color? backgroundColor; // Couleur de fond du bouton.
  final Duration animationDuration; // Durée de l'animation de mise à l'échelle.
  final Curve animationCurve; // Courbe de l'animation de mise à l'échelle.
  final bool repeat; // Indique si l'animation Lottie doit se répéter.
  final double iconSizeFactor; // Facteur de taille de l'icône Lottie par rapport à la taille du bouton.
  // Builder pour gérer les erreurs de chargement de l'asset Lottie.
  final Widget Function(BuildContext context, Object error, StackTrace? stackTrace) errorBuilder;


  const AnimatedIconButton({
    super.key,
    required this.animationAsset,
    this.tooltip,
    this.onPressed,
    this.size = 40.0,
    this.backgroundColor,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
    this.repeat = true,
    this.iconSizeFactor = 0.6,
    this.errorBuilder = _defaultErrorBuilder, // Correction ici : fournir une fonction par défaut
  });

  // Fonction de construction d'erreur par défaut
  static Widget _defaultErrorBuilder(BuildContext context, Object error, StackTrace? stackTrace) {
    return Icon(
      Icons.error,
      color: Colors.red,
      size: 24.0, // Taille par défaut pour l'icône d'erreur
    );
  }

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController; // Contrôleur pour l'animation de mise à l'échelle.
  late Animation<double> _scaleAnimation; // Animation de mise à l'échelle.
  late AnimationController _lottieController; // Contrôleur pour l'animation Lottie.

  @override
  void initState() {
    super.initState();

    // Initialisation du contrôleur et de l'animation de mise à l'échelle.
    _scaleController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _scaleController, curve: widget.animationCurve),
    );

    // Initialisation du contrôleur Lottie.
    _lottieController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Durée par défaut pour Lottie, peut être ajustée.
    );

    // Si l'animation Lottie doit se répéter, la démarrer en boucle.
    if (widget.repeat) {
      _lottieController.repeat();
    }
  }

  @override
  void dispose() {
    // Libération des ressources des contrôleurs d'animation.
    _scaleController.dispose();
    _lottieController.dispose();
    super.dispose();
  }

  /// Gère l'événement de "tap down" (pression initiale).
  void _handleTapDown(TapDownDetails _) {
    _scaleController.forward(); // Démarre l'animation de mise à l'échelle vers l'avant.
    if (!widget.repeat) {
      // Si l'animation ne se répète pas, la démarrer depuis le début.
      _lottieController.forward(from: 0);
    }
  }


  void _handleTapUp(TapUpDetails _) { // Correction du type de paramètre
    _scaleController.reverse(); // Inverse l'animation de mise à l'échelle.
  }

  /// Gère l'événement d'annulation du "tap".
  void _handleTapCancel() {
    _scaleController.reverse(); // Inverse l'animation de mise à l'échelle.
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip ?? '', // Affiche le texte d'info-bulle.
      child: GestureDetector(
        onTapDown: widget.onPressed != null ? _handleTapDown : null, // Active le tap down si onPressed est défini.
        onTapUp: widget.onPressed != null ? _handleTapUp : null,     // Active le tap up si onPressed est défini.
        onTapCancel: widget.onPressed != null ? _handleTapCancel : null, // Active le tap cancel si onPressed est défini.
        onTap: widget.onPressed, // Déclenche le onPressed du widget.
        child: ScaleTransition(
          scale: _scaleAnimation, // Applique l'animation de mise à l'échelle.
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? Colors.transparent, // Utilise la couleur de fond ou transparent.
              shape: BoxShape.circle, // Forme circulaire du bouton.
            ),
            child: Center(
              child: Lottie.asset(
                widget.animationAsset, // Chemin de l'asset Lottie.
                controller: _lottieController, // Contrôleur Lottie.
                width: widget.size * widget.iconSizeFactor, // Largeur de l'icône.
                height: widget.size * widget.iconSizeFactor, // Hauteur de l'icône.
                fit: BoxFit.contain, // Ajuste l'icône pour qu'elle contienne dans l'espace.
                frameRate: FrameRate.max, // Utilise le taux de rafraîchissement maximal.
                animate: widget.repeat, // Contrôle si l'animation Lottie doit s'animer en continu.
                errorBuilder: widget.errorBuilder, // Passe le errorBuilder fourni.
              ),
            ),
          ),
        ),
      ),
    );
  }
}

