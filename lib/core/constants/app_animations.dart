/// Animation durations and curves for Immuno Warriors.
///
/// This file defines constants for smooth and consistent animations.
import 'package:flutter/material.dart';

class AppAnimations {
  /// --- Durations ---
  /// Fast animation duration (150ms).
  static const Duration durationFast = Duration(milliseconds: 150);

  /// Normal animation duration (300ms).
  static const Duration durationNormal = Duration(milliseconds: 300);

  /// Slow animation duration (500ms).
  static const Duration durationSlow = Duration(milliseconds: 500);

  /// Extra slow animation duration (800ms).
  static const Duration durationExtraSlow = Duration(milliseconds: 800);

  /// Long animation duration (1s).
  static const Duration durationLong = Duration(seconds: 1);

  /// Extra long animation duration (2s).
  static const Duration durationExtraLong = Duration(seconds: 2);

  /// Splash screen animation duration (3s).
  static const Duration splashAnimationDuration = Duration(seconds: 3);

  /// Card entry animation duration (400ms).
  static const Duration cardAnimationDuration = Duration(milliseconds: 400);

  /// Dialog animation duration (250ms).
  static const Duration dialogAnimationDuration = Duration(milliseconds: 250);

  /// Scan effect animation duration (4s).
  static const Duration scanEffectDuration = Duration(seconds: 4);

  /// Pulse animation duration (1200ms).
  static const Duration pulseAnimationDuration = Duration(milliseconds: 1200);

  /// Fade-in animation duration (800ms).
  static const Duration fadeInDuration = Duration(milliseconds: 800);

  /// Icon animation duration (2000ms).
  static const Duration iconAnimationDuration = Duration(milliseconds: 2000);

  /// Background animation duration (10s).
  static const Duration backgroundAnimationDuration = Duration(seconds: 10);

  /// Logo pulse animation duration (4s).
  static const Duration logoPulseDuration = Duration(seconds: 4);

  /// Shimmer animation duration (1500ms).
  static const Duration shimmerDuration = Duration(milliseconds: 1500);

  /// --- Curves ---
  /// Ease-in curve.
  static const Curve curveEaseIn = Curves.easeIn;

  /// Ease-out curve.
  static const Curve curveEaseOut = Curves.easeOut;

  /// Ease-in-out curve.
  static const Curve curveEaseInOut = Curves.easeInOut;

  /// Fast-out, slow-in curve.
  static const Curve curveFastOutSlowIn = Curves.fastOutSlowIn;

  /// Decelerate curve.
  static const Curve curveDecelerate = Curves.decelerate;

  /// Elastic-out curve.
  static const Curve curveElasticOut = Curves.elasticOut;

  /// Linear curve.
  static const Curve curveLinear = Curves.linear;
}
