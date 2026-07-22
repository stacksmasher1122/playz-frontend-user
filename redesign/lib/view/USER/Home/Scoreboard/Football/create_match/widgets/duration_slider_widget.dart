import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class DurationSliderWidget extends StatelessWidget {
  final double duration;
  final ValueChanged<double> onChanged;

  DurationSliderWidget({
    super.key,
    required this.duration,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'TOTAL DURATION',
              style: TextStyle(
                color: Colors.grey,
                fontSize: ResponsiveHelper.sp(10),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${duration.toInt()} MINS',
              style: TextStyle(
                color: AppColors.accent, // Lime Green
                fontSize: ResponsiveHelper.sp(14),
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        RepaintBoundary(
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.accent,
              inactiveTrackColor: Color(0xFF1E1E1E),
              thumbColor: AppColors.accent,
              trackHeight: 2.0,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
              overlayColor: AppColors.accent.withValues(alpha: 0.2),
            ),
            child: Slider(
              value: duration,
              min: 10,
              max: 120,
              divisions: 11, // 10 to 120 with steps of 10
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
