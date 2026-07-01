import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_match_statistics_controller.dart';
import '../../../../../../../theme/responsive_helper.dart';

class MatchMomentumCard extends StatelessWidget {
  MatchMomentumCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<FootballMatchStatisticsController>();

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(16),
        vertical: ResponsiveHelper.h(8),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.w(24)),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.show_chart,
                color: Color(0xFFC6FF00),
                size: ResponsiveHelper.w(20),
              ),
              SizedBox(width: ResponsiveHelper.w(8)),
              Text(
                'MATCH MOMENTUM',
                style: TextStyle(
                  color: Color(0xFFC6FF00).withValues(alpha: 0.8),
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(24)),
          Obx(() {
            return MomentumChartWidget(
              points: controller.momentumPoints.toList(),
            );
          }),
        ],
      ),
    );
  }
}

class MomentumChartWidget extends StatelessWidget {
  final dynamic points;
  MomentumChartWidget({super.key, this.points});
  @override
  Widget build(BuildContext context) => SizedBox();
}
