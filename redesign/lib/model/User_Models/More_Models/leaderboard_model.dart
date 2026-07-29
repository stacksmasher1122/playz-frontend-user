import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

enum PlayerTier {
  rookie,
  rising,
  prime,
  elite,
  legend,
}

class LeaderboardPlayerModel {
  final String id;
  final int rank;
  final String name;
  final String rawName;
  final int points;
  final String avatarUrl;
  final bool isCurrentUser;
  final Map<String, int> sportXpMap;

  const LeaderboardPlayerModel({
    this.id = '',
    this.rank = 0,
    required this.name,
    this.rawName = '',
    this.points = 0,
    required this.avatarUrl,
    this.isCurrentUser = false,
    this.sportXpMap = const {},
  });

  /// Total XP sum across all sports
  int get totalXp {
    if (sportXpMap.isEmpty) return points;
    return sportXpMap.values.fold(0, (sum, val) => sum + val);
  }

  /// Calculates player tier based on current points/XP
  PlayerTier get tier {
    if (points >= 15000) return PlayerTier.legend;
    if (points >= 6000) return PlayerTier.elite;
    if (points >= 2000) return PlayerTier.prime;
    if (points >= 500) return PlayerTier.rising;
    return PlayerTier.rookie;
  }

  /// Tier label string
  String get tierName {
    switch (tier) {
      case PlayerTier.legend:
        return 'LEGEND';
      case PlayerTier.elite:
        return 'ELITE';
      case PlayerTier.prime:
        return 'PRIME';
      case PlayerTier.rising:
        return 'RISING';
      case PlayerTier.rookie:
        return 'ROOKIE';
    }
  }

  /// Target Tier name string
  String get targetTierName {
    switch (tier) {
      case PlayerTier.rookie:
        return 'Rising';
      case PlayerTier.rising:
        return 'Prime';
      case PlayerTier.prime:
        return 'Elite';
      case PlayerTier.elite:
        return 'Legend';
      case PlayerTier.legend:
        return 'Legend Max';
    }
  }

  /// Target points needed for next tier
  int get targetPoints {
    switch (tier) {
      case PlayerTier.rookie:
        return 500;
      case PlayerTier.rising:
        return 2000;
      case PlayerTier.prime:
        return 6000;
      case PlayerTier.elite:
        return 15000;
      case PlayerTier.legend:
        return points > 15000 ? points : 15000;
    }
  }

  /// Progress bar ratio (0.0 to 1.0)
  double get progressRatio {
    int startPts = 0;
    switch (tier) {
      case PlayerTier.rookie:
        startPts = 0;
        break;
      case PlayerTier.rising:
        startPts = 500;
        break;
      case PlayerTier.prime:
        startPts = 2000;
        break;
      case PlayerTier.elite:
        startPts = 6000;
        break;
      case PlayerTier.legend:
        return 1.0;
    }

    final target = targetPoints;
    final range = target - startPts;
    if (range <= 0) return 1.0;
    final currentProgress = points - startPts;
    return (currentProgress / range).clamp(0.0, 1.0);
  }

  /// Theme color corresponding to tier from AppColors
  Color get tierColor {
    switch (tier) {
      case PlayerTier.rookie:
        return AppColors.rookieSlate;
      case PlayerTier.rising:
        return AppColors.risingBlue;
      case PlayerTier.prime:
        return AppColors.primeTeal;
      case PlayerTier.elite:
        return AppColors.elitePurple;
      case PlayerTier.legend:
        return AppColors.legendGold;
    }
  }

  /// Formats numbers to compact 'k' / 'm' strings (e.g. 1.2k, 1m)
  static String formatNumber(num value) {
    if (value >= 1000000) {
      double v = value / 1000000.0;
      return '${v % 1 == 0 ? v.toInt() : v.toStringAsFixed(1)}m';
    } else if (value >= 1000) {
      double v = value / 1000.0;
      return '${v % 1 == 0 ? v.toInt() : v.toStringAsFixed(1)}k';
    }
    return value.toInt().toString();
  }

  String get formattedPoints => formatNumber(points);
  String get formattedTargetPoints => formatNumber(targetPoints);
  String get formattedRank => '#${formatNumber(rank)}';

  LeaderboardPlayerModel copyWith({
    String? id,
    int? rank,
    String? name,
    String? rawName,
    int? points,
    String? avatarUrl,
    bool? isCurrentUser,
    Map<String, int>? sportXpMap,
  }) {
    return LeaderboardPlayerModel(
      id: id ?? this.id,
      rank: rank ?? this.rank,
      name: name ?? this.name,
      rawName: rawName ?? this.rawName,
      points: points ?? this.points,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
      sportXpMap: sportXpMap ?? this.sportXpMap,
    );
  }
}
