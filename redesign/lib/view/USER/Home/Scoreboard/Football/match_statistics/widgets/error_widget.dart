import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_match_statistics_controller.dart';
import '../../../../../../../theme/responsive_helper.dart';

class CustomErrorWidget extends StatelessWidget {
  CustomErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<FootballMatchStatisticsController>();

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.redAccent,
            size: ResponsiveHelper.w(48),
          ),
          SizedBox(height: ResponsiveHelper.h(16)),
          Text(
            'Unable to load statistics.',
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(16),
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(16)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFC6FF00),
              foregroundColor: Colors.black,
            ),
            onPressed: controller.loadStatistics,
            child: Text(
              'RETRY',
              style: TextStyle(fontSize: ResponsiveHelper.sp(12)),
            ),
          ),
        ],
      ),
    );
  }
}
