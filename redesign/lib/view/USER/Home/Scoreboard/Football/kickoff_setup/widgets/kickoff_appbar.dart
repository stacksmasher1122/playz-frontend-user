import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/kickoff_setup_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class KickoffAppbar extends StatelessWidget implements PreferredSizeWidget {
  KickoffAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<KickoffSetupController>();

    return AppBar(
      backgroundColor: AppColors.background.withValues(alpha: 0.85),
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'KICKOFF SETUP',
        style: TextStyle(
          color: AppColors.accent, // Lime Green
          fontSize: ResponsiveHelper.sp(16),
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
        ),
      ),
      actions: [
        Center(
          child: Container(
            margin: EdgeInsets.only(right: 16),
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(10), vertical: ResponsiveHelper.h(4)),
            decoration: BoxDecoration(
              color: Color(0xFF121212),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
              border: Border.all(color: Color(0xFF1E1E1E)),
            ),
            child: Obx(() {
              return Text(
                'MATCH ID: ${controller.matchId.value}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(10),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
