import 'package:flutter/material.dart';

class MyStatsOverviewItem {
  final String sportName;
  final String subtitle;
  final int matchesCount;
  final IconData icon;

  const MyStatsOverviewItem({
    required this.sportName,
    required this.subtitle,
    required this.matchesCount,
    required this.icon,
  });

  static List<MyStatsOverviewItem> getSampleItems() {
    return const [
      MyStatsOverviewItem(
        sportName: 'Cricket',
        subtitle: '1,240 Runs',
        matchesCount: 142,
        icon: Icons.sports_cricket,
      ),
      MyStatsOverviewItem(
        sportName: 'Football',
        subtitle: '24 Goals',
        matchesCount: 86,
        icon: Icons.sports_soccer,
      ),
      MyStatsOverviewItem(
        sportName: 'Badminton',
        subtitle: '72% Win Rate',
        matchesCount: 210,
        icon: Icons.sports,
      ),
    ];
  }
}
