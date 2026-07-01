import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Badminton/match_stats_controller.dart';
import 'performance_radar_chart.dart';
import 'performance_bar_widget.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PerformanceMetricsCard extends StatefulWidget {
  PerformanceMetricsCard({super.key});

  @override
  State<PerformanceMetricsCard> createState() => _PerformanceMetricsCardState();
}

class _PerformanceMetricsCardState extends State<PerformanceMetricsCard> with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );
    _animation = CurvedAnimation(parent: _animController, curve: Curves.easeOutBack);
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
      child: Obx(() {
        if (controller.performanceMetrics.isEmpty) return SizedBox.shrink();
        final metrics = controller.performanceMetrics.first;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PERFORMANCE\nMETRICS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.sp(14),
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    height: ResponsiveHelper.h(1.2),
                  ),
                ),
                Row(
                  children: [
                    _buildLegendItem(true, 'VIKTOR'),
                    SizedBox(width: 12),
                    _buildLegendItem(false, 'LIN DAN'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24),
            Center(
              child: PerformanceRadarChart(
                metrics: metrics,
                animation: _animation,
              ),
            ),
            SizedBox(height: 32),
            PerformanceBarWidget(
              label: 'Winners',
              valueText: '${metrics.playerOneWinners} — ${metrics.playerTwoWinners}',
              fillRatio: metrics.playerOneWinners / (metrics.playerOneWinners + metrics.playerTwoWinners),
            ),
            PerformanceBarWidget(
              label: 'Smashes',
              valueText: '${metrics.playerOneSmashes} — ${metrics.playerTwoSmashes}',
              fillRatio: metrics.playerOneSmashes / (metrics.playerOneSmashes + metrics.playerTwoSmashes),
            ),
            PerformanceBarWidget(
              label: 'Net Winners',
              valueText: '${metrics.playerOneNetWinners} — ${metrics.playerTwoNetWinners}',
              fillRatio: metrics.playerOneNetWinners / (metrics.playerOneNetWinners + metrics.playerTwoNetWinners),
            ),
            PerformanceBarWidget(
              label: 'Unforced Errors',
              valueText: '${metrics.playerOneUnforcedErrors} — ${metrics.playerTwoUnforcedErrors}',
              fillRatio: metrics.playerOneUnforcedErrors / (metrics.playerOneUnforcedErrors + metrics.playerTwoUnforcedErrors),
              isInverseMetric: true, // colors it red
            ),
          ],
        );
      }),
    );
  }

  Widget _buildLegendItem(bool isFilled, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: ResponsiveHelper.w(10),
          height: ResponsiveHelper.h(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? Color(0xFFC6FF00) : Colors.transparent, // Neon Yellow-Green
            border: Border.all(
              color: Color(0xFFC6FF00),
              width: ResponsiveHelper.w(1.5),
            ),
          ),
        ),
        SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveHelper.sp(10),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
