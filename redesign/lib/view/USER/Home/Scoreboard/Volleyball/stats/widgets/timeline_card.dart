import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_stats_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/timeline_event_model.dart';

class TimelineCard extends StatelessWidget {
  final VolleyballStatsController controller;

  TimelineCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('MATCH TIMELINE', style: AppTypography.headlineMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
            Row(
              children: [
                Text('ALL EVENTS', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, letterSpacing: 1.2)),
                SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down, color: AppColors.muted, size: 16),
              ],
            ),
          ],
        ),
        SizedBox(height: 24),
        Obx(() {
          return Column(
            children: controller.timelineEvents.map((event) => _buildTimelineItem(event)).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildTimelineItem(TimelineEventModel event) {
    Color iconColor = AppColors.muted;
    IconData icon = Icons.circle;

    if (event.type == TimelineEventType.point) {
      iconColor = event.isTeamA ? AppColors.primaryContainer : AppColors.surfaceContainerHighest;
      icon = Icons.circle;
    } else if (event.type == TimelineEventType.ace) {
      iconColor = AppColors.primaryContainer;
      icon = Icons.star;
    } else if (event.type == TimelineEventType.block) {
      iconColor = AppColors.primary;
      icon = Icons.shield;
    } else if (event.type == TimelineEventType.substitution) {
      iconColor = Colors.blueAccent;
      icon = Icons.sync;
    } else if (event.type == TimelineEventType.timeout) {
      iconColor = Colors.orange;
      icon = Icons.timer_outlined;
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(icon, color: iconColor, size: 16),
              SizedBox(height: 8),
              Container(width: 2, height: 40, color: AppColors.surfaceContainerHighest),
            ],
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title, style: AppTypography.bodyLg.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
                SizedBox(height: 4),
                Text(event.description, style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, letterSpacing: 1.2)),
              ],
            ),
          ),
          Text(event.time, style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, letterSpacing: 1.2)),
        ],
      ),
    );
  }
}
