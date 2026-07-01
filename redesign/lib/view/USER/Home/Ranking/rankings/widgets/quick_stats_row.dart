import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

Color kGreen = AppColors.accent;
Color kSurface = Color(0xFF0E0E0E);
Color kMuted = Color(0xFFA7A7A7);

class QuickStatsRow extends StatelessWidget {
  QuickStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 10),
      child: Row(
        children: [
          _StatTile('24', 'Matches', Icons.sports),
          SizedBox(width: 10),
          _StatTile('68%', 'Win Rate', Icons.percent),
          SizedBox(width: 10),
          _StatTile('3', 'Streak', Icons.local_fire_department),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _StatTile(this.value, this.label, this.icon);

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(14)),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        ),
        child: Column(
          children: [
            Icon(icon, color: kGreen, size: 20),
            SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800)),
            Text(label,
                style: TextStyle(color: kMuted, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
