import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';

class TeamScoreWidget extends StatelessWidget {
  final String teamName;
  final int setsWon;
  final bool isHighlighted;
  final bool isLeftAligned;

  const TeamScoreWidget({
    super.key,
    required this.teamName,
    required this.setsWon,
    required this.isHighlighted,
    this.isLeftAligned = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isLeftAligned ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(
          teamName,
          style: AppTypography.headlineMd.copyWith(
            color: isHighlighted ? AppColors.primaryContainer : AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isHighlighted ? AppColors.primaryContainer : AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              '$setsWon',
              style: AppTypography.headlineMd.copyWith(
                color: isHighlighted ? Colors.black : AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
