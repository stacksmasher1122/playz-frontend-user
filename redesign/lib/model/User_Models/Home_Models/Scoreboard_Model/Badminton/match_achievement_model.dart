import 'package:flutter/material.dart';

class MatchAchievementModel {
  final String title;
  final String subtitle;
  final IconData icon;
  final String achievementType;
  final Color badgeColor;
  final String description;

  const MatchAchievementModel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.achievementType,
    required this.badgeColor,
    required this.description,
  });
}
