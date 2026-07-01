import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_match_statistics_controller.dart';
import '../../../../../../../theme/responsive_helper.dart';

class BottomSummaryWidget extends StatelessWidget {
  BottomSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<FootballMatchStatisticsController>();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(32),
        vertical: ResponsiveHelper.h(16),
      ),
      child: TextButton(
        onPressed: controller.openFullAnalytics,
        child: Text(
          'VIEW FULL SQUAD ANALYTICS',
          style: TextStyle(
            color: Color(0xFFC6FF00),
            fontSize: ResponsiveHelper.sp(12),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }
}
