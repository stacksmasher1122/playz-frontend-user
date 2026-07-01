/// Spacing and sizing constants for PlayZ Match Center.
/// All values are `const double` so they can be used directly in `const` widgets.
class AppDimensions {
  AppDimensions._();

  // ─── Base Spacing Grid ────────────────────────────────────────────────────────
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // ─── Gutter / Generic Gap ────────────────────────────────────────────────────
  static const double gutter = 12.0;

  // ─── Named Padding ───────────────────────────────────────────────────────────
  static const double paddingXs = xs;
  static const double paddingSm = sm;
  static const double paddingMd = md;
  static const double paddingLg = lg;
  static const double paddingXl = xl;
  static const double paddingXxl = xxl;

  // ─── Border Radii ────────────────────────────────────────────────────────────
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radiusXxl = 24.0;
  static const double radiusFull = 999.0;

  /// Aliases used in existing widgets
  static const double borderRadiusSm = radiusSm;
  static const double borderRadiusMd = radiusMd;
  static const double borderRadiusLg = radiusLg;
  static const double borderRadiusXl = radiusXl;
  static const double borderRadiusXxl = radiusXxl;

  // ─── Icon Sizes ──────────────────────────────────────────────────────────────
  static const double iconXs = 12.0;
  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;

  // ─── Avatar / Image ──────────────────────────────────────────────────────────
  static const double avatarSm = 32.0;
  static const double avatarMd = 48.0;
  static const double avatarLg = 72.0;
  static const double avatarXl = 96.0;
  static const double avatarXxl = 120.0;

  // ─── Button Heights ──────────────────────────────────────────────────────────
  static const double buttonHeightSm = 36.0;
  static const double buttonHeightMd = 48.0;
  static const double buttonHeightLg = 56.0;

  // ─── App Bar ─────────────────────────────────────────────────────────────────
  static const double appBarHeight = 64.0;

  // ─── Bottom Nav ──────────────────────────────────────────────────────────────
  static const double bottomNavHeight = 72.0;

  // ─── Card ────────────────────────────────────────────────────────────────────
  static const double cardElevation = 0.0;
  static const double cardPadding = md;
}
