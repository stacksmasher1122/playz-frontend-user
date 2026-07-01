import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';

class TimelineWidget extends StatelessWidget {
  final List<Map<String, dynamic>> timeline;

  const TimelineWidget({super.key, required this.timeline});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: timeline.map((event) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event['game'] as String,
                style: AppTypography.labelCaps10.copyWith(color: AppColors.primaryContainer, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                event['desc'] as String,
                style: AppTypography.bodySm.copyWith(color: AppColors.primary),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
