import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/live_football_dashboard_controller.dart';
import 'statistics_progress_card.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PossessionCardWidget extends StatelessWidget {
  PossessionCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<LiveFootballDashboardController>();

    return Obx(() {
      return StatisticsProgressCard(
        title: 'Possession',
        valueA: controller.possessionA.value,
        valueB: controller.possessionB.value,
        isPercentage: true,
      );
    });
  }
}
