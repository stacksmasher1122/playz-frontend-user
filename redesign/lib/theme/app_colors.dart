import 'package:flutter/material.dart';

/// Centralized Color Palette for PlayZ Application.
/// Standardized for dark theme, neon glassmorphism aesthetics, tier gradients, and status accents.
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // ─── Brand & Primary Accents ───────────────────────────────────────────────
  /// Core Spotify Green (0xFF1DB954) - The primary & core brand color.
  /// Core Spotify Green / Primary Green (0xFF56F174 / 0xFF1DB954).
  static const Color spotifyGreen = Color(0xFF1DB954);
  static const Color primaryGreen = Color(0xFF56F174);
  static const Color primary = Color(0xFF1DB954);
  static const Color accent = Color(0xFF1DB954);
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// Secondary Neon Green Variant Accent (0xFF00E676).
  static const Color neonGreen = Color(0xFF00E676);

  // ─── Backgrounds & Surfaces ────────────────────────────────────────────────
  /// Pitch Black Screen Background (0xFF000000).
  static const Color background = Color(0xFF000000);

  /// Primary Dark Surface (0xFF121212).
  static const Color surface = Color(0xFF121212);

  /// Standard Elevated Dark Card Container (0xFF1E1E1E) - used across modal sheets, dialogs, and feature cards.
  static const Color card = Color(0xFF1E1E1E);
  static const Color cardSurface = Color(0xFF1E1E1E);
  static const Color cardDark = Color(0xFF1A1A1A);
  static const Color surfaceElevated = Color(0xFF181818);

  /// Emerald-tinted Dark Container (0xFF12261B / 0xFF16251C) - used for success banners and Z-Coins cards.
  static const Color surfaceEmerald = Color(0xFF12261B);
  static const Color surfaceEmeraldDark = Color(0xFF16251C);

  // ─── Text & Content ────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color muted = Color(0xFFB3B3B3);
  static const Color mutedText = Color(0xFFA0A0A0);


  // ─── Borders, Dividers & Outlines ──────────────────────────────────────────
  static const Color divider = Color(0xFF2C2C2C);
  static const Color borderDark = Color(0xFF333333);
  static const Color outlineVariant = Color(0xFFE0E0E0);

  // ─── Status & Feedback ─────────────────────────────────────────────────────
  static const Color success = Color(0xFF1DB954);
  static const Color warning = Color(0xFFFFB300);
  static const Color error = Color(0xFFE53935);
  static const Color liveRed = Color(0xFFFF5252);
  static const Color infoBlue = Color(0xFF2563EB);

  // ─── Premium & Z-Coins ─────────────────────────────────────────────────────
  /// Premium Gold Accent (0xFFC9A876) - used for Z Premium badges and VIP membership cards.
  static const Color premiumGold = Color(0xFFC9A876);

  /// Coins Amber Accent (0xFFFFD700) - used for Z-Coins icons and reward points.
  static const Color coinsGold = Color(0xFFFFD700);

  // ─── Tier Colors & Gradients ───────────────────────────────────────────────
  static const Color rookieSlate = Color(0xFF5B6472);
  static const Color risingBlue = Color(0xFF2563EB);
  static const Color primeTeal = Color(0xFF0891B2);
  static const Color elitePurple = Color(0xFF6D28D9);
  static const Color legendGold = Color(0xFFB8860B);

  // Tier Gradients
  static const LinearGradient tierRookie = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF5B6472), Color(0xFF7A8494)],
  );

  static const LinearGradient tierRising = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2563EB), Color(0xFF38BDF8)],
  );

  static const LinearGradient tierPrime = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0891B2), Color(0xFF22D3EE)],
  );

  static const LinearGradient tierElite = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6D28D9), Color(0xFFC084FC)],
  );

  static const LinearGradient tierLegend = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFB8860B), Color(0xFFFFD700)],
  );

  static const LinearGradient tierZPremium = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8E8E93), Color(0xFFE5E4E2), Color(0xFFC9A876)],
  );

  // ─── Common UI Gradients ──────────────────────────────────────────────────
  /// Green-to-Black Background Gradient (used in Trainer discovery, coming soon hero, auth screens).
  static const LinearGradient greenBlackBg = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF003819), Color(0xFF001F0E), Color(0xFF000000)],
    stops: [0.0, 0.45, 1.0],
  );

  /// Deep Dark Green-to-Black Background Gradient (used specifically for onboarding screens).
  static const LinearGradient greenBlackBgDark = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF001C0D), Color(0xFF000C05), Color(0xFF000000)],
    stops: [0.0, 0.45, 1.0],
  );

  /// Emerald-to-Dark Card Gradient (used in Z-Coins card, referral card, success banners).
  static const LinearGradient emeraldDarkCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E1E1E), Color(0xFF12261B)],
  );

  /// Neon Green CTA Glow Gradient (used in primary action buttons, active toggles).
  static const LinearGradient neonGreenGlow = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF00E676), Color(0xFF1DB954)],
  );

  /// Black-to-Grey Glass Container Gradient (used in dark cards, modal bottom sheets).
  static const LinearGradient blackGreyCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E1E1E), Color(0xFF121212)],
  );

  /// Dark Surface Overlay Gradient (used in elevated cards & dialog headers).
  static const LinearGradient darkSurfaceOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A1A1A), Color(0xFF0A0A0A)],
  );

  /// Grey-Green Gradient (used exclusively for Home Quick Action buttons / tiles).
  /// Predominantly grey with a very subtle green tint.
  static const LinearGradient quickActionGreyGreen = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1F211F), Color(0xFF171917)],
  );

  /// Black Bottom Scrim Gradient (used for hero image text readability).
  static const LinearGradient blackScrim = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [Color(0xCC000000), Color(0x00000000)],
  );
}

class TierHelper {
  static LinearGradient getTierGradient(String tier) {
    switch (tier.trim().toUpperCase()) {
      case 'RISING':
        return AppColors.tierRising;
      case 'PRIME':
        return AppColors.tierPrime;
      case 'ELITE':
        return AppColors.tierElite;
      case 'LEGEND':
        return AppColors.tierLegend;
      case 'Z PREMIUM':
      case 'PREMIUM':
        return AppColors.tierZPremium;
      case 'ROOKIE':
      default:
        return AppColors.tierRookie;
    }
  }

  static String getTierFromXp(int xp) {
    if (xp >= 7500) return 'LEGEND';
    if (xp >= 3500) return 'ELITE';
    if (xp >= 1500) return 'PRIME';
    if (xp >= 500) return 'RISING';
    return 'ROOKIE';
  }
}

// TODO: The following UI files currently contain hardcoded Color(0x...) and LinearGradient(...) instances which can be refactored to use AppColors gradient tokens:
// - lib/view/USER/Trainer/trainer/trainer_screen.dart (greenBlackBg)
// - lib/view/USER/More/z_coins/z_coins_screen.dart (emeraldDarkCard)
// - lib/view/USER/More/menu/widgets/z_coins_card.dart (blackGreyCard)
// - lib/view/USER/More/reward_center/reward_center_screen.dart (greenBlackBg, blackGreyCard)
// - lib/view/USER/More/profile/profile_screen.dart (blackGreyCard, tierGradients)
// - lib/view/USER/SignIn-SignUp/login/widgets/login_background.dart (greenBlackBg)
// - lib/view/USER/Play/play/widgets/game_diary_section.dart (blackGreyCard)
// - lib/view/USER/Home/home/widgets/home_hero_cta.dart (neonGreenGlow)
