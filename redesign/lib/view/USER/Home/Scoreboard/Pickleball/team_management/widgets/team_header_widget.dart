import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';

class TeamHeaderWidget extends StatelessWidget {
  const TeamHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Team Management', style: AppTypography.headlineLg),
        const SizedBox(height: 8),
        Text(
          'Assign players to Team A and Team B. Switch between Singles and Doubles for this match.',
          style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
        ),
      ],
    );
  }
}
