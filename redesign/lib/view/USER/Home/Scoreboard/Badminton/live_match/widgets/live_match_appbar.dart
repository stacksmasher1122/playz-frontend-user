import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Badminton/live_match_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LiveMatchAppbar extends StatelessWidget implements PreferredSizeWidget {
  LiveMatchAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<LiveMatchController>();

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'MATCH CENTER',
        style: TextStyle(
          color: Colors.white,
          fontSize: ResponsiveHelper.sp(14),
          letterSpacing: 1.5,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        Container(
          margin: EdgeInsets.only(right: ResponsiveHelper.w(16.0), top: ResponsiveHelper.h(12), bottom: 12),
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12), vertical: ResponsiveHelper.h(4)),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
            border: Border.all(color: Colors.grey.shade800),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.timer_outlined,
                color: Color(0xFFC6FF00), // Neon Yellow-Green
                size: 14,
              ),
              SizedBox(width: 6),
              Obx(() => Text(
                    controller.matchDuration.value,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.sp(12),
                      fontWeight: FontWeight.bold,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
