import 'package:flutter/material.dart';

/// A lightweight responsive helper that scales sizes based on screen dimensions.
/// Call `ResponsiveHelper.init(context)` once at the top of your build method.
class ResponsiveHelper {
  ResponsiveHelper._();

  static double _screenWidth = 375.0;
  static double _screenHeight = 812.0;

  // Base design dimensions (iPhone 14 / standard mobile)
  static const double _baseWidth = 375.0;
  static const double _baseHeight = 812.0;

  /// Must be called once in [build] before using [w] or [h].
  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _screenWidth = size.width;
    _screenHeight = size.height;
  }

  /// Scale a width value proportionally to the current screen width.
  static double w(double size) => size * (_screenWidth / _baseWidth);

  /// Scale a height value proportionally to the current screen height.
  static double h(double size) => size * (_screenHeight / _baseHeight);

  /// Scale a font size proportionally (uses width as reference).
  static double sp(double size) => size * (_screenWidth / _baseWidth);

  /// Returns true if the screen is considered a tablet (width >= 768).
  static bool get isTablet => _screenWidth >= 768;

  /// Returns true if the screen is considered a phone.
  static bool get isPhone => _screenWidth < 768;

  /// Current screen width.
  static double get screenWidth => _screenWidth;

  /// Current screen height.
  static double get screenHeight => _screenHeight;
}
