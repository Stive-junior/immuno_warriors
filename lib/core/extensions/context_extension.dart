import 'package:flutter/material.dart';

/// Extensions on BuildContext to provide common utility functions.
extension ContextExtension on BuildContext {
  /// Returns the current MediaQueryData.
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Returns the screen width.
  double get width => mediaQuery.size.width;

  /// Returns the screen height.
  double get height => mediaQuery.size.height;

  /// Returns whether the orientation is portrait.
  bool get isPortrait => mediaQuery.orientation == Orientation.portrait;

  /// Returns whether the orientation is landscape.
  bool get isLandscape => mediaQuery.orientation == Orientation.landscape;

  /// Returns the current theme.
  ThemeData get theme => Theme.of(this);

  /// Returns the current text theme.
  TextTheme get textTheme => theme.textTheme;

  /// Returns the current platform.
  TargetPlatform get platform => theme.platform;

  /// Returns the current NavigatorState.
  NavigatorState get navigator => Navigator.of(this);

  /// Pushes a new route onto the navigator.
  Future<T?> push<T extends Object?>(Route<T> route) => navigator.push(route);

  /// Replaces the current route with a new route.
  Future<T?> pushReplacement<T extends Object?, RT extends Object?>(Route<T> newRoute) =>
      navigator.pushReplacement(newRoute);

  /// Pops the current route off the navigator.
  void pop<T extends Object?>([T? result]) => navigator.pop(result);

  /// Removes all routes below the current one and pushes a new route.
  Future<T?> pushAndRemoveUntil<T extends Object?>(Route<T> newRoute, RoutePredicate predicate) =>
      navigator.pushAndRemoveUntil(newRoute, predicate);

  /// Shows a snackbar.
  void showSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }

  /// Shows a dialog.
  Future<T?> showCustomDialog<T>(
      {required WidgetBuilder builder, bool barrierDismissible = true}) {
    return showDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: builder,
    );
  }

  /// Provides padding values based on screen size.
  EdgeInsets get paddingLow => EdgeInsets.all(height * 0.01);
  EdgeInsets get paddingMedium => EdgeInsets.all(height * 0.02);
  EdgeInsets get paddingHigh => EdgeInsets.all(height * 0.03);

  /// Provides margin values based on screen size.
  EdgeInsets get marginLow => EdgeInsets.all(height * 0.01);
  EdgeInsets get marginMedium => EdgeInsets.all(height * 0.02);
  EdgeInsets get marginHigh => EdgeInsets.all(height * 0.03);

  /// Provides SizedBox widgets for spacing.
  SizedBox get emptySizedWidthLow => SizedBox(width: width * 0.01);
  SizedBox get emptySizedWidthMedium => SizedBox(width: width * 0.02);
  SizedBox get emptySizedWidthHigh => SizedBox(width: width * 0.03);
  SizedBox get emptySizedHeightLow => SizedBox(height: height * 0.01);
  SizedBox get emptySizedHeightMedium => SizedBox(height: height * 0.02);
  SizedBox get emptySizedHeightHigh => SizedBox(height: height * 0.03);

  /// Checks if the current platform is Android.
  bool get isAndroid => platform == TargetPlatform.android;

  /// Checks if the current platform is iOS.
  bool get isIOS => platform == TargetPlatform.iOS;

  /// Checks if the current platform is Web.
  bool get isWeb => platform == TargetPlatform.windows || platform == TargetPlatform.macOS || platform == TargetPlatform.linux; // Could be improved

  /// Returns the device pixel ratio.
  double get devicePixelRatio => mediaQuery.devicePixelRatio;
}