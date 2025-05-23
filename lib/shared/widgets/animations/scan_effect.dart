import 'package:flutter/material.dart';

class AdvancedScanEffect extends StatefulWidget {
  final AnimationController controller;
  final Color scanColor;
  final double lineWidth;
  final BlendMode blendMode;

  const AdvancedScanEffect({
    super.key,
    required this.controller,
    this.scanColor = Colors.white30,
    this.lineWidth = 2.0,
    this.blendMode = BlendMode.screen,
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
          painter: _ScanLinePainter(
            progress: widget.controller.value,
            color: widget.scanColor,
            lineWidth: widget.lineWidth,
          ),
        );
      },
    );
  }
}

class _ScanLinePainter extends CustomPainter {
  final double progress;
  final Color color;
  final double lineWidth;

  _ScanLinePainter({
    required this.progress,
    required this.color,
    required this.lineWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;

    final lineY = size.height * progress;
    canvas.drawLine(
      Offset(0, lineY),
      Offset(size.width, lineY),
      paint,
    );

    // Effet de gradient pour le scan
    final gradient = LinearGradient(
      colors: [color.withOpacity(0), color, color.withOpacity(0)],
      stops: const [0.25, 0.5, 0.75],
    );
    final gradientPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromPoints(
          Offset(0, lineY - 20),
          Offset(0, lineY + 20),
        ),
      )
      ..strokeWidth = lineWidth * 3
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, lineY),
      Offset(size.width, lineY),
      gradientPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ScanLinePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.lineWidth != lineWidth;
  }
}