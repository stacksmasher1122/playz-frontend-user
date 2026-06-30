import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Badminton/live_match_controller.dart';

class BottomNavigationWidget extends StatelessWidget {
  const BottomNavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LiveMatchController>();

    return Container(
      color: Colors.black, // fallback
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFC6FF00) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.black : Colors.white,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
