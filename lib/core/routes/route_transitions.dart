/// Custom route transitions for Immuno Warriors.
///
/// Provides consistent and polished navigation animations aligned with app theming.
import 'package:flutter/material.dart';
import '../constants/app_animations.dart';

/// --- Fade Transitions ---

/// A fade transition for subtle screen changes.
class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) =>
                FadeTransition(opacity: animation, child: child),
        transitionDuration: AppAnimations.durationNormal,
      );
}

/// --- Slide Transitions ---

/// A slide transition from the right.
class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  SlideRightRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: AppAnimations.curveEaseInOut,
                ),
              ),
              child: child,
            ),
        transitionDuration: AppAnimations.durationNormal,
      );
}

/// A slide transition from the left.
class SlideLeftRoute extends PageRouteBuilder {
  final Widget page;
  SlideLeftRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1.0, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: AppAnimations.curveEaseInOut,
                ),
              ),
              child: child,
            ),
        transitionDuration: AppAnimations.durationNormal,
      );
}

/// A slide transition from the bottom.
class SlideUpRoute extends PageRouteBuilder {
  final Widget page;
  SlideUpRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: AppAnimations.curveEaseInOut,
                ),
              ),
              child: child,
            ),
        transitionDuration: AppAnimations.durationNormal,
      );
}

/// A slide transition from the top.
class SlideDownRoute extends PageRouteBuilder {
  final Widget page;
  SlideDownRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, -1.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: AppAnimations.curveEaseInOut,
                ),
              ),
              child: child,
            ),
        transitionDuration: AppAnimations.durationNormal,
      );
}

/// --- Scale Transitions ---

/// A scale transition for pop-up effects.
class ScaleRoute extends PageRouteBuilder {
  final Widget page;
  ScaleRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) => ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: AppAnimations.curveElasticOut,
                ),
              ),
              child: child,
            ),
        transitionDuration: AppAnimations.durationSlow,
      );
}

/// --- Combined Transitions ---

/// A fade and slide transition from the right.
class FadeSlideRightRoute extends PageRouteBuilder {
  final Widget page;
  FadeSlideRightRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.5, 0.0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: AppAnimations.curveEaseInOut,
                  ),
                ),
                child: child,
              ),
            ),
        transitionDuration: AppAnimations.durationNormal,
      );
}

/// A fade and scale transition for dialogs or modals.
class FadeScaleRoute extends PageRouteBuilder {
  final Widget page;
  FadeScaleRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) => FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.7, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: AppAnimations.curveElasticOut,
                  ),
                ),
                child: child,
              ),
            ),
        transitionDuration: AppAnimations.durationSlow,
      );
}
