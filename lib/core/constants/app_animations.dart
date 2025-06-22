// Animation durations and curves for Immuno Warriors.
//
// This file defines constants for smooth and consistent animations across the app.
// Includes durations and curves for UI transitions, combat effects, and feature-specific animations.
import 'package:flutter/material.dart';

class AppAnimations {
  /// --- Durations ---
  /// Fast animation duration (150ms) for quick transitions.
  static const Duration durationFast = Duration(milliseconds: 150);

  /// Normal animation duration (300ms) for standard animations.
  static const Duration durationNormal = Duration(milliseconds: 300);

  /// Slow animation duration (500ms) for deliberate transitions.
  static const Duration durationSlow = Duration(milliseconds: 500);

  /// Extra slow animation duration (800ms) for dramatic effects.
  static const Duration durationExtraSlow = Duration(milliseconds: 800);

  /// Long animation duration (1s) for extended transitions.
  static const Duration durationLong = Duration(seconds: 1);

  /// Extra long animation duration (2s) for major UI changes.
  static const Duration durationExtraLong = Duration(seconds: 2);

  /// Splash screen animation duration (3s) for initial loading.
  static const Duration splashAnimationDuration = Duration(seconds: 3);

  /// Card entry animation duration (400ms) for card reveals.
  static const Duration cardAnimationDuration = Duration(milliseconds: 400);

  /// Dialog animation duration (250ms) for dialog pop-ups.
  static const Duration dialogAnimationDuration = Duration(milliseconds: 250);

  /// Scan effect animation duration (4s) for threat scanner effects.
  static const Duration scanEffectDuration = Duration(seconds: 4);

  /// Pulse animation duration (1200ms) for pulsing UI elements.
  static const Duration pulseAnimationDuration = Duration(milliseconds: 1200);

  /// Fade-in animation duration (800ms) for smooth element appearances.
  static const Duration fadeInDuration = Duration(milliseconds: 800);

  /// Icon animation duration (2000ms) for animated icons.
  static const Duration iconAnimationDuration = Duration(milliseconds: 2000);

  /// Background animation duration (10s) for looping backgrounds.
  static const Duration backgroundAnimationDuration = Duration(seconds: 10);

  /// Logo pulse animation duration (4s) for logo effects.
  static const Duration logoPulseDuration = Duration(seconds: 4);

  /// Shimmer animation duration (1500ms) for loading shimmers.
  static const Duration shimmerDuration = Duration(milliseconds: 1500);

  /// Combat hit animation duration (600ms) for attack effects.
  static const Duration combatHitDuration = Duration(milliseconds: 600);

  /// Combat victory animation duration (2.5s) for victory sequence.
  static const Duration combatVictoryDuration = Duration(
    seconds: 2,
    milliseconds: 500,
  );

  /// Research node unlock animation duration (1.2s) for research tree.
  static const Duration researchUnlockDuration = Duration(milliseconds: 1200);

  /// BioForge crafting animation duration (3s) for crafting effects.
  static const Duration bioForgeCraftDuration = Duration(seconds: 3);

  /// Threat scanner pulse animation duration (2s) for scanning pulse.
  static const Duration threatScannerPulseDuration = Duration(seconds: 2);

  /// Leaderboard rank change animation duration (700ms) for rank updates.
  static const Duration leaderboardRankChangeDuration = Duration(
    milliseconds: 700,
  );

  /// --- Curves ---
  /// Ease-in curve for smooth starts.
  static const Curve curveEaseIn = Curves.easeIn;

  /// Ease-out curve for smooth endings.
  static const Curve curveEaseOut = Curves.easeOut;

  /// Ease-in-out curve for balanced transitions.
  static const Curve curveEaseInOut = Curves.easeInOut;

  /// Fast-out, slow-in curve for dynamic effects.
  static const Curve curveFastOutSlowIn = Curves.fastOutSlowIn;

  /// Decelerate curve for natural slowdowns.
  static const Curve curveDecelerate = Curves.decelerate;

  /// Elastic-out curve for bouncy effects.
  static const Curve curveElasticOut = Curves.elasticOut;

  /// Linear curve for consistent motion.
  static const Curve curveLinear = Curves.linear;

  /// Bounce-in curve for playful entrances.
  static const Curve curveBounceIn = Curves.bounceIn;

  /// Bounce-out curve for playful exits.
  static const Curve curveBounceOut = Curves.bounceOut;
}
