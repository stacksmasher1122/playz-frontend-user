import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/live_football_dashboard_controller.dart';
import 'stats_tile_widget.dart';
import 'package:redesign/theme/responsive_helper.dart';

class StatsSummaryGrid extends StatelessWidget {
  StatsSummaryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<LiveFootballDashboardController>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0), vertical: ResponsiveHelper.h(8.0)),
      child: Obx(() {
        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            StatsTileWidget(
              title: 'XP Gained',
              value: controller.xpPoints.value.toStringAsFixed(2),
              isPrimary: true,
            ),
            StatsTileWidget(
              title: 'Pass Accuracy',
              value: '${controller.passAccuracy.value}%',
            ),
            StatsTileWidget(
              title: 'Corners',
              value: '${controller.corners.value}',
            ),
            StatsTileWidget(
              title: 'Interceptions',
              value: '${controller.interceptions.value}',
            ),
          ],
        );
      }),
    );
  }
}
