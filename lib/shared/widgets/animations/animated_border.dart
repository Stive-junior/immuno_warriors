import 'package:flutter/material.dart';

class AnimatedBorder extends StatelessWidget {
  final AnimationController animationController;
  final Widget child;
  final double width;
  final double height;
  final double borderWidth;
  final Color borderColor;
  final BorderRadius borderRadius;

  const AnimatedBorder({
    super.key,
    required this.animationController,
    required this.child,
    this.width = 100,
    this.height = 40,
    this.borderWidth = 2,
    this.borderColor = Colors.blueAccent,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        final pulseValue = 1 + (animationController.value * 0.1);
        return Transform.scale(
          scale: pulseValue,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              border: Border.all(
                color: borderColor.withOpacity(0.8 + 0.2 * animationController.value),
                width: borderWidth,
              ),
            ),
            child: Center(child: this.child),
          ),
        );
      },
      child: child,
    );
  }
}