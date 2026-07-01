import 'package:flutter/material.dart';

/// Typography system for PlayZ Match Center.
/// All text styles follow the Neon Glassmorphism design language.
/// Font: Inter / Sora / JetBrains Mono (loaded via pubspec.yaml)
class AppTypography {
  AppTypography._();

  // ─── Label Caps ──────────────────────────────────────────────────────────────
  /// Small all-caps label, used for section headers, tags, nav labels.
  static const TextStyle labelCaps = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    height: 1.4,
  );

  // ─── Body ────────────────────────────────────────────────────────────────────
  /// Standard body text — readable size for paragraphs and list items.
  static const TextStyle bodyMd = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.5,
  );

  static const TextStyle bodySm = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.4,
  );

  static const TextStyle bodyLg = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
  );

  // ─── Headline ────────────────────────────────────────────────────────────────
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

  static const TextStyle headlineSm = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.4,
  );

  static const TextStyle headlineXl = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    height: 1.2,
  );

  // ─── Display ─────────────────────────────────────────────────────────────────
  /// Hero scoreboard numbers.
  static const TextStyle displayLg = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.0,
    height: 1.1,
  );

  static const TextStyle displayMd = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    height: 1.1,
  );

  static const TextStyle displaySm = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    height: 1.2,
  );

  // ─── Mono ─────────────────────────────────────────────────────────────────────
  /// Monospace style for scores and stats.
  static const TextStyle monoLg = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: 2.0,
    height: 1.2,
  );

  static const TextStyle monoMd = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5,
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

  // ─── Inter Font Variants ─────────────────────────────────────────────────────
  /// Body text using the Inter font explicitly.
  static const TextStyle bodyInter = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.5,
  );

  // ─── Label Caps Variants ─────────────────────────────────────────────────────
  /// Extra-small all-caps label at 10sp — used for tags, micro-labels.
  static const TextStyle labelCaps10 = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.0,
    height: 1.4,
  );
}
