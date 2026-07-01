import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/live_football_dashboard_controller.dart';

import '../../match_statistics/football_match_statistics_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';
import '../../team_management/football_team_management_screen.dart';

class BottomNavigationWidget extends StatelessWidget {
  final String currentScreen;
  BottomNavigationWidget({super.key, this.currentScreen = 'dashboard'});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<LiveFootballDashboardController>();

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
            _buildNavItem(context, controller, 0, 'Matches', Icons.sports_soccer),
            _buildNavItem(context, controller, 1, 'Teams', Icons.group),
            _buildNavItem(context, controller, 2, 'Pitch', Icons.grass),
            _buildNavItem(context, controller, 3, 'Stats', Icons.bar_chart),
            _buildNavItem(context, controller, 4, 'Settings', Icons.settings),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, LiveFootballDashboardController controller, int index, String label, IconData icon) {
    return GestureDetector(
      onTap: () {
        if (controller.selectedBottomIndex.value == index) return;
        controller.changeBottomNav(index);

        if (index == 1) { // Teams
          if (currentScreen == 'stats') {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => FootballTeamManagementScreen()));
          } else if (currentScreen == 'dashboard') {
            Navigator.push(context, MaterialPageRoute(builder: (_) => FootballTeamManagementScreen()));
          }
        } else if (index == 3) { // Stats
          if (currentScreen == 'teams') {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => FootballMatchStatisticsScreen()));
          } else if (currentScreen == 'dashboard') {
            Navigator.push(context, MaterialPageRoute(builder: (_) => FootballMatchStatisticsScreen()));
          }
        } else { // Dashboard tabs
          if (currentScreen != 'dashboard') {
            Navigator.pop(context);
          }
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Obx(() {
        final isSelected = controller.selectedBottomIndex.value == index;
        return AnimatedContainer(
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
        );
      }),
    );
  }
}
