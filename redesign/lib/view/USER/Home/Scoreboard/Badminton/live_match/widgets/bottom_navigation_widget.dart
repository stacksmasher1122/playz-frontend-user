import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Badminton/live_match_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BottomNavigationWidget extends StatelessWidget {
  BottomNavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<LiveMatchController>();

    return Container(
      color: Colors.black, // fallback
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(8)),
      child: SafeArea(
        child: Obx(() {
          final selectedIndex = controller.selectedTabIndex.value;
          
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BottomNavItem(
                icon: Icons.sports_score,
                label: 'Scoring',
                isSelected: selectedIndex == 0,
                onTap: () => controller.selectTab(0),
              ),
              _BottomNavItem(
                icon: Icons.bar_chart,
                label: 'Stats',
                isSelected: selectedIndex == 1,
                onTap: () => controller.selectTab(1),
              ),
              _BottomNavItem(
                icon: Icons.history,
                label: 'Timeline',
                isSelected: selectedIndex == 2,
                onTap: () => controller.selectTab(2),
              ),
              _BottomNavItem(
                icon: Icons.more_horiz,
                label: 'More',
                isSelected: selectedIndex == 3,
                onTap: () => controller.selectTab(3),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  _BottomNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20), vertical: ResponsiveHelper.h(12)),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFC6FF00) : Colors.transparent,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.black : Colors.white,
              size: 24,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontSize: ResponsiveHelper.sp(12),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
