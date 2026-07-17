import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TimelineWidget extends StatelessWidget {
  final List<Map<String, dynamic>> timeline;

  TimelineWidget({super.key, required this.timeline});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: timeline.map((event) {
        return Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event['game'] as String,
                style: AppTypography.labelCaps10.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                event['desc'] as String,
                style: AppTypography.bodySm.copyWith(color: AppColors.accent),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
