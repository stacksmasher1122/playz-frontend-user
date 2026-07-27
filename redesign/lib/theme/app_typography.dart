import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/responsive_helper.dart';

/// Typography system for PlayZ Match Center & PlayZ Redesign.
/// All text styles follow modern neon & dark glassmorphism design aesthetics.
/// Supported Fonts: Inter (Default Body/UI), Sora (Headlines/Display), JetBrains Mono (Scores/Stats)
class AppTypography {
  AppTypography._();

  // ─── Font Families ────────────────────────────────────────────────────────────
  static String get interFamily => GoogleFonts.inter().fontFamily ?? 'Inter';
  static String get soraFamily => GoogleFonts.sora().fontFamily ?? 'Sora';
  static String get monoFamily => GoogleFonts.jetBrainsMono().fontFamily ?? 'JetBrains Mono';

  // ─── Label Caps ──────────────────────────────────────────────────────────────
  /// Small all-caps label, used for section headers, tags, nav labels.
  static const TextStyle labelCaps = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    height: 1.4,
  );

  /// Extra-small all-caps label at 10sp — used for tags, micro-labels.
  static const TextStyle labelCaps10 = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.0,
    height: 1.4,
  );

  // ─── Body ────────────────────────────────────────────────────────────────────
  /// Micro body text (10px).
  static const TextStyle bodyXs = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.4,
  );

  /// Small body text (12px).
  static const TextStyle bodySm = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.4,
  );

  /// Standard body text (14px) — readable size for paragraphs and list items.
  static const TextStyle bodyMd = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.5,
  );

  /// Large body text (16px).
  static const TextStyle bodyLg = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
  );

  /// Body text using Inter font explicitly.
  static const TextStyle bodyInter = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.5,
  );

  // ─── Headline & Titles ────────────────────────────────────────────────────────
  static const TextStyle headlineSm = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.4,
  );

  /// Medium headline — card titles, panel headers.
  static const TextStyle headlineMd = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.4,
  );

  /// Large headline — screen titles, hero stats.
  static const TextStyle headlineLg = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.0,
    height: 1.3,
  );

  /// Large headline — mobile-specific slightly smaller variant.
  static const TextStyle headlineLgMobile = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.0,
    height: 1.3,
  );

  static const TextStyle headlineXl = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    height: 1.2,
  );

  // ─── Sora Font Variants ──────────────────────────────────────────────────────
  /// Medium headline using the Sora display font.
  static const TextStyle headlineMdSora = TextStyle(
    fontFamily: 'Sora',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.1,
    height: 1.4,
  );

  /// Large headline using the Sora display font.
  static const TextStyle headlineSora = TextStyle(
    fontFamily: 'Sora',
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    height: 1.3,
  );

  /// Massive scoreboard display number — Sora font, bold.
  static const TextStyle displayScoreSora = TextStyle(
    fontFamily: 'Sora',
    fontSize: 56,
    fontWeight: FontWeight.w800,
    letterSpacing: -2.0,
    height: 1.0,
  );

  // ─── Display & Scoreboards ───────────────────────────────────────────────────
  static const TextStyle displaySm = TextStyle(
    fontFamily: 'JetBrains Mono',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    height: 1.2,
  );

  static const TextStyle displayMd = TextStyle(
    fontFamily: 'JetBrains Mono',
    fontSize: 36,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    height: 1.1,
  );

  /// Hero scoreboard numbers.
  static const TextStyle displayLg = TextStyle(
    fontFamily: 'JetBrains Mono',
    fontSize: 48,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.0,
    height: 1.1,
  );

  // ─── Mono (JetBrains Mono) ───────────────────────────────────────────────────
  /// Monospace style for scores and stats.
  static const TextStyle monoMd = TextStyle(
    fontFamily: 'JetBrains Mono',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5,
    height: 1.2,
  );

  static const TextStyle monoLg = TextStyle(
    fontFamily: 'JetBrains Mono',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: 2.0,
    height: 1.2,
  );

  // ─── Responsive Context Utility Methods ──────────────────────────────────────
  /// Returns a copy of [style] with font size dynamically scaled using [BuildContext].
  static TextStyle responsiveOf(BuildContext context, TextStyle style) {
    if (style.fontSize == null) return style;
    return style.copyWith(
      fontSize: context.responsiveFont(style.fontSize!),
    );
  }
}

/// Extension on [TextStyle] allowing inline dynamic responsive font scaling.
extension AppTextStyleResponsiveX on TextStyle {
  /// Returns a copy of this [TextStyle] with its [fontSize] scaled dynamically based on [context] viewport.
  TextStyle responsive(BuildContext context) {
    if (fontSize == null) return this;
    return copyWith(fontSize: context.responsiveFont(fontSize!));
  }
}
