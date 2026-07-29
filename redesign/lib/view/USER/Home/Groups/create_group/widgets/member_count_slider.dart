import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MemberCountSlider extends StatelessWidget {
  final double maxMembers;
  final Function(double) onChanged;

  const MemberCountSlider({
    super.key,
    required this.maxMembers,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.accent,
            inactiveTrackColor: AppColors.surface,
            thumbColor: AppColors.accent,
            overlayColor: AppColors.accent.withValues(alpha: 0.2),
            trackHeight: 4,
          ),
          child: Slider(
            value: maxMembers.clamp(5.0, 500.0),
            min: 5,
            max: 500,
            divisions: 495,
            onChanged: onChanged,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.widthPct(3)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '5',
                style: AppTypography.labelCaps10.copyWith(
                  color: AppColors.muted,
                  fontSize: context.responsiveFont(11),
                ),
              ),
              Text(
                '500',
                style: AppTypography.labelCaps10.copyWith(
                  color: AppColors.muted,
                  fontSize: context.responsiveFont(11),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
