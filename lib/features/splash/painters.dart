import 'dart:math';
import 'package:flutter/material.dart';

class OrbitingElement {
  final double radius;
  final double speed;
  final double size;
  final Color color;
  final double startAngle;

  OrbitingElement({
    required this.radius,
    required this.speed,
    required this.size,
    required this.color,
    required this.startAngle,
  });
}

class Particle {
  double x;
  double y;
  final double speed;
  final double size;
  final Color color;

  Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.color,
  });
}

class BubbleProgressPainter extends CustomPainter {
  final double value;
  final Color color;

  BubbleProgressPainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final progressWidth = size.width * value;
    final gradient = LinearGradient(
      colors: [color.withOpacity(0.5), color.withOpacity(0.2)],
    );
    final paint =
        Paint()
          ..shader = gradient.createShader(
            Rect.fromLTWH(0, 0, progressWidth, size.height),
          )
          ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, progressWidth, size.height),
        Radius.circular(size.height / 2),
      ),
      paint,
    );

    final bubblePaint =
        Paint()
          ..color = Colors.white.withOpacity(0.3)
          ..style = PaintingStyle.fill;

    final rng = Random((value * 1000).toInt());
    for (int i = 0; i < 5; i++) {
      final bubbleSize = rng.nextDouble() * 4 + 1;
      final bubbleX = rng.nextDouble() * progressWidth;
      final bubbleY = rng.nextDouble() * size.height;

      if (bubbleX + bubbleSize < progressWidth) {
        canvas.drawCircle(Offset(bubbleX, bubbleY), bubbleSize, bubblePaint);
      }
    }

    final borderPaint =
        Paint()
          ..color = color.withOpacity(0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, progressWidth, size.height),
        Radius.circular(size.height / 2),
      ),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant BubbleProgressPainter oldDelegate) =>
      oldDelegate.value != value || oldDelegate.color != color;
}

class NeonRingPainter extends CustomPainter {
  final double progress;
  final Color color;

  NeonRingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const radius = 100.0;
    const strokeWidth = 4.0;

    final backgroundPaint =
        Paint()
          ..color = color.withOpacity(0.05)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, backgroundPaint);

    final progressPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );

    if (progress > 0) {
      final progressAngle = 2 * pi * progress - pi / 2;
      final progressPosition =
          center + Offset(cos(progressAngle), sin(progressAngle)) * radius;
      canvas.drawCircle(
        progressPosition,
        6,
        Paint()
          ..color = color.withOpacity(0.6)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
    }
  }

  @override
  bool shouldRepaint(covariant NeonRingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;
  final Size size;
  final Offset? touchPosition;

  ParticlePainter({
    required this.particles,
    required this.animationValue,
    required this.size,
    this.touchPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (var particle in particles) {
      particle.y += particle.speed * animationValue / 100;
      if (particle.y > 1) particle.y -= 1;
      final x = particle.x * size.width;
      final y = particle.y * size.height;
      paint.color = particle.color;
      canvas.drawCircle(Offset(x, y), particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}

class OrbitingElementsPainter extends CustomPainter {
  final List<OrbitingElement> elements;
  final double animationValue;
  final Size size;

  OrbitingElementsPainter({
    required this.elements,
    required this.animationValue,
    required this.size,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var element in elements) {
      final angle = element.startAngle + (animationValue * element.speed);
      final x = cos(angle) * element.radius + size.width / 2 - element.size / 2;
      final y = sin(angle) * element.radius + size.height / 2 - 60;
      canvas.drawCircle(
        Offset(x, y),
        element.size / 2,
        Paint()
          ..color = element.color
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
    }
  }

  @override
  bool shouldRepaint(covariant OrbitingElementsPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
