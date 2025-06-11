// shared/widgets/animations/advanced_scan_effect.dart
import 'package:flutter/material.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart'; // Assurez-vous que ce chemin est correct

/// Un effet de scan futuriste qui traverse l'écran, avec des particules subtiles.
///
/// L'effet est contrôlé par une [AnimationController] externe.
class AdvancedScanEffect extends StatefulWidget {
  final AnimationController controller; // Contrôleur d'animation pour le mouvement du scan.
  final Color scanColor; // Couleur principale de la ligne de scan et des particules.
  final double lineWidth; // Épaisseur de la ligne de scan.
  final double spread; // Étendue verticale de l'effet de lueur autour de la ligne.
  final BlendMode blendMode; // Mode de fusion pour l'effet de scan.

  const AdvancedScanEffect({
    super.key,
    required this.controller,
    this.scanColor = AppColors.primaryAccentColor, // Couleur par défaut: vert virus
    this.lineWidth = 2.5, // Épaisseur légèrement augmentée
    this.spread = 30.0, // Étendue augmentée pour un effet plus dramatique
    this.blendMode = BlendMode.screen, // BlendMode.screen est souvent bon pour les lueurs
  });

  @override
  State<AdvancedScanEffect> createState() => _AdvancedScanEffectState();
}

class _AdvancedScanEffectState extends State<AdvancedScanEffect> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite, // Prend toute la taille disponible
          painter: _VirusScanPainter(
            progress: widget.controller.value,
            color: widget.scanColor,
            lineWidth: widget.lineWidth,
            spread: widget.spread,
            blendMode: widget.blendMode,
          ),
        );
      },
    );
  }
}

/// Peintre personnalisé pour dessiner l'effet de scan.
class _VirusScanPainter extends CustomPainter {
  final double progress; // Progression de l'animation (0.0 à 1.0).
  final Color color; // Couleur de l'effet.
  final double lineWidth; // Épaisseur de la ligne.
  final double spread; // Étendue de la lueur.
  final BlendMode blendMode; // Mode de fusion.

  _VirusScanPainter({
    required this.progress,
    required this.color,
    required this.lineWidth,
    required this.spread,
    required this.blendMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Calcul de la position Y de la ligne de scan.
    final lineY = size.height * progress;

    // Dégradé pour la ligne de scan principale.
    final gradient = LinearGradient(
      colors: [
        color.withOpacity(0), // Transparent au début
        color.withOpacity(0.8), // Couleur pleine au centre
        color.withOpacity(0), // Transparent à la fin
      ],
      stops: const [0.0, 0.5, 1.0], // Étendue du dégradé
    );

    // Peinture pour la ligne de scan.
    final linePaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromPoints(
          Offset(0, lineY - spread), // Début du dégradé au-dessus de la ligne
          Offset(size.width, lineY + spread), // Fin du dégradé en dessous de la ligne
        ),
      )
      ..strokeWidth = lineWidth // Épaisseur de la ligne
      ..style = PaintingStyle.stroke // Style de trait
      ..strokeCap = StrokeCap.round // Extrémités arrondies
      ..blendMode = blendMode; // Mode de fusion

    // Dessine la ligne de scan.
    canvas.drawLine(
      Offset(0, lineY),
      Offset(size.width, lineY),
      linePaint,
    );

    // Peinture pour les particules (style virus).
    final particlePaint = Paint()
      ..color = color.withOpacity(0.6) // Couleur des particules, légèrement transparente
      ..style = PaintingStyle.fill
      ..blendMode = blendMode; // Mode de fusion pour les particules

    // Générateur de nombres pseudo-aléatoires pour les particules.
    // Utilise le même seed pour une apparence déterministe à chaque frame.
    final rng = _ParticleRNG(progress);
    for (int i = 0; i < 40; i++) { // Augmentation du nombre de particules
      final x = size.width * rng.nextDouble(); // Position X aléatoire
      final yOffset = (rng.nextDouble() * 2 - 1) * spread * 0.8; // Décalage Y autour de la ligne
      final distanceFactor = 1 - (yOffset.abs() / (spread * 0.8)).clamp(0, 1); // Plus près de la ligne, plus grand
      final radius = 1.0 + (distanceFactor * 2.0); // Rayon des particules (plus grand près de la ligne)

      if (radius > 0) {
        canvas.drawCircle(
          Offset(x, lineY + yOffset),
          radius,
          particlePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _VirusScanPainter oldDelegate) {
    // Redessine seulement si les propriétés qui affectent le rendu changent.
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.lineWidth != lineWidth ||
        oldDelegate.spread != spread ||
        oldDelegate.blendMode != blendMode;
  }
}

/// Simple générateur de nombres pseudo-aléatoires déterministe.
class _ParticleRNG {
  final double seed;
  int _state;

  _ParticleRNG(this.seed) : _state = (seed * 10000).toInt(); // Multiplicateur plus grand pour plus de variation

  double nextDouble() {
    _state = (_state * 1103515245 + 12345) & 0x7fffffff;
    return (_state % 10000) / 10000; // Diviseur plus grand pour plus de précision
  }
}
