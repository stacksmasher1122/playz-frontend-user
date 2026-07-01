import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/live_football_dashboard_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LiveDashboardAppbar extends StatelessWidget implements PreferredSizeWidget {
  LiveDashboardAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<LiveFootballDashboardController>();

    return AppBar(
      backgroundColor: Colors.black.withValues(alpha: 0.9),
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.menu, color: Colors.white), // hamburger
        onPressed: () {
          // Open drawer or handle menu
        },
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'PRO SCOUT LIVE',
            style: TextStyle(
              color: Color(0xFFC6FF00), // Lime Green
              fontSize: ResponsiveHelper.sp(18),
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(width: 16),
          Obx(() {
            if (!controller.isLive.value) return SizedBox.shrink();
            return Container(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(8), vertical: ResponsiveHelper.h(4)),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                border: Border.all(color: Colors.red),
              ),
              child: Row(
                children: [
                  Container(
                    width: ResponsiveHelper.w(6),
                    height: ResponsiveHelper.h(6),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'LIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.sp(10),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.account_circle_outlined, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
