import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Volleyball/stats/volleyball_stats_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;

  BottomNavigation({super.key, this.selectedIndex = 0});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(top: BorderSide(color: AppColors.surfaceContainerHighest)),
      ),
      padding: EdgeInsets.only(top: ResponsiveHelper.h(8), bottom: 24), // For iOS safe area
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, Icons.sports_score, 'Match', 0),
          _buildNavItem(context, Icons.people_alt_outlined, 'Teams', 1),
          _buildNavItem(context, Icons.bar_chart, 'Stats', 2),
          _buildNavItem(context, Icons.settings_outlined, 'Settings', 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index) {
    bool isSelected = index == selectedIndex;
    return GestureDetector(
      onTap: () {
        if (index == 2 && selectedIndex != 2) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => VolleyballStatsScreen()));
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(8)),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? AppColors.onPrimaryContainer : AppColors.muted),
            SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.labelCaps10.copyWith(
                color: isSelected ? AppColors.onPrimaryContainer : AppColors.muted,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
