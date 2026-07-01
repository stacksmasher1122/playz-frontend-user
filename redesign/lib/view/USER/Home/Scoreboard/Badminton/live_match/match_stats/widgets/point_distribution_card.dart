import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Badminton/match_stats_controller.dart';
import 'line_chart_widget.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PointDistributionCard extends StatefulWidget {
  PointDistributionCard({super.key});

  @override
  State<PointDistributionCard> createState() => _PointDistributionCardState();
}

class _PointDistributionCardState extends State<PointDistributionCard> with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _animation = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<MatchStatsController>();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0), vertical: ResponsiveHelper.h(12.0)),
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'POINT DISTRIBUTION',
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(14),
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Progression of total points over match duration.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: ResponsiveHelper.sp(10),
            ),
          ),
          SizedBox(height: 24),
          Obx(() {
            return LineChartWidget(
              points: controller.chartPoints,
              animation: _animation,
            );
          }),
          SizedBox(height: 16),
          // X-Axis Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('START', style: TextStyle(color: Colors.grey, fontSize: ResponsiveHelper.sp(10), fontWeight: FontWeight.bold)),
              Text('GAME 1', style: TextStyle(color: Colors.grey, fontSize: ResponsiveHelper.sp(10), fontWeight: FontWeight.bold)),
              Text('GAME 2', style: TextStyle(color: Colors.grey, fontSize: ResponsiveHelper.sp(10), fontWeight: FontWeight.bold)),
              Text('FINAL', style: TextStyle(color: Colors.grey, fontSize: ResponsiveHelper.sp(10), fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
