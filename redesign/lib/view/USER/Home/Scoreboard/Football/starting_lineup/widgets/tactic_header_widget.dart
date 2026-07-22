import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/starting_lineup_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TacticHeaderWidget extends StatelessWidget {
  TacticHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<StartingLineupController>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0), vertical: ResponsiveHelper.h(12.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Tactic: Pitch',
            style: TextStyle(
              color: AppColors.accent, // Lime Green
              fontSize: ResponsiveHelper.sp(24),
              fontWeight: FontWeight.w900,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12), vertical: ResponsiveHelper.h(6)),
            decoration: BoxDecoration(
              color: Color(0xFF121212),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
            ),
            child: Obx(() {
              return Text(
                'Match Week ${controller.matchWeek.value}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.bold,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
