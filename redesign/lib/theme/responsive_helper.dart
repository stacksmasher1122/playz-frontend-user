import 'dart:math' as math;
import 'package:flutter/material.dart';

// Baseline reference width (390.0 logical px) representing a standard modern mobile viewport (e.g., iPhone 12/13/14 & common Android devices).
const double kBaselineReferenceWidth = 390.0;

// Minimum (0.85) and maximum (1.30) font scale ratio bounds to prevent text from becoming illegibly small or clipping.
const double kMinFontScaleRatio = 0.85;
const double kMaxFontScaleRatio = 1.30;

/// Pure [MediaQuery] responsive sizing extensions on [BuildContext] tailored strictly for phone portrait orientation.
extension ResponsiveContextX on BuildContext {
  /// Returns actual pixel value for [percent] (0.0 to 100.0) of current screen width.
  double widthPct(double percent) {
    return MediaQuery.sizeOf(this).width * (percent / 100.0);
  }

  /// Returns actual pixel value for [percent] (0.0 to 100.0) of current screen height.
  double heightPct(double percent) {
    return MediaQuery.sizeOf(this).height * (percent / 100.0);
  }

  /// Returns actual pixel value for [percent] (0.0 to 100.0) relative to the smaller screen dimension (width vs height).
  /// Ideal for square elements like icons, avatars, and consistent padding across tall/short phone aspect ratios.
  double minDimensionPct(double percent) {
    final size = MediaQuery.sizeOf(this);
    return math.min(size.width, size.height) * (percent / 100.0);
  }

  /// Computes a dynamically scaled font size for [baseFontSize].
  ///
  /// **Text Scaler Approach Choice: Approach (a)**
  /// Math applies screen-width ratio scaling relative to [kBaselineReferenceWidth],
  /// clamped between [kMinFontScaleRatio] and [kMaxFontScaleRatio].
  ///
  /// Accessibility scaling via system text scaler is intentionally **excluded** from this calculation.
  /// Passing the returned size into standard [Text] or [TextStyle] widgets allows Flutter's native
  /// [MediaQuery.textScalerOf] rendering pipeline to apply system font preferences automatically
  /// without risking double-scaling.
  double responsiveFont(double baseFontSize) {
    final width = MediaQuery.sizeOf(this).width;
    final widthRatio = (width / kBaselineReferenceWidth).clamp(
      kMinFontScaleRatio,
      kMaxFontScaleRatio,
    );
    return baseFontSize * widthRatio;
  }

  /// Direct access to safe area top inset (status bar / notch height).
  double get topInset => MediaQuery.paddingOf(this).top;

  /// Direct access to safe area bottom inset (home indicator / gesture bar height).
  double get bottomInset => MediaQuery.paddingOf(this).bottom;
}

/// Static helper maintained strictly for backward compatibility with legacy screen calls.
class ResponsiveHelper {
  ResponsiveHelper._();

  static double _screenWidth = 390.0;
  static double _screenHeight = 844.0;

  /// Legacy initializer.
  static void init(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    _screenWidth = size.width;
    _screenHeight = size.height;
  }

  /// Legacy width ratio scaler.
  static double w(double size) => size * (_screenWidth / kBaselineReferenceWidth);

  /// Legacy height ratio scaler.
  static double h(double size) => size * (_screenHeight / 844.0);

  /// Legacy font size scaler.
  static double sp(double size) {
    final ratio = (_screenWidth / kBaselineReferenceWidth).clamp(kMinFontScaleRatio, kMaxFontScaleRatio);
    return size * ratio;
  }

  /// Current screen width.
  static double get screenWidth => _screenWidth;

  /// Current screen height.
  static double get screenHeight => _screenHeight;
}
