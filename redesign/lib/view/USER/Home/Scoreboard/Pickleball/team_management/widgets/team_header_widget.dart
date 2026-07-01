import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TeamHeaderWidget extends StatelessWidget {
  TeamHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Team Management', style: AppTypography.headlineLg),
        SizedBox(height: 8),
        Text(
          'Assign players to Team A and Team B. Switch between Singles and Doubles for this match.',
          style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
        ),
      ],
    );
  }
}
