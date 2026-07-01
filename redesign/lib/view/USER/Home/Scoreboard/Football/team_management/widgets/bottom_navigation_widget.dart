import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BottomNavigationWidget extends StatelessWidget {
  BottomNavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.only(top: ResponsiveHelper.h(8), bottom: 16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.95),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(ResponsiveHelper.w(24)),
          topRight: Radius.circular(ResponsiveHelper.w(24)),
        ),
        border: Border(
          top: BorderSide(color: Colors.grey.shade900),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(context, 0, 'Matches', Icons.sports_soccer),
            _buildNavItem(context, 1, 'Teams', Icons.group),
            _buildNavItem(context, 2, 'Pitch', Icons.grass),
            _buildNavItem(context, 3, 'Stats', Icons.bar_chart),
            _buildNavItem(context, 4, 'Settings', Icons.settings),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, String label, IconData icon) {
    final isSelected = index == 1; // Teams is always selected on this screen
    
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          // Navigate back to Matches
          Navigator.pop(context);
        } else {
          // Placeholders for other tabs
        }
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12), vertical: ResponsiveHelper.h(8)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Color(0xFFC6FF00) : Colors.grey,
              size: 24,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Color(0xFFC6FF00) : Colors.grey,
                fontSize: ResponsiveHelper.sp(10),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
