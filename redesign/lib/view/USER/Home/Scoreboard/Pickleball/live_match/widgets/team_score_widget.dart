import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TeamScoreWidget extends StatelessWidget {
  final String teamName;
  final int setsWon;
  final bool isHighlighted;
  final bool isLeftAligned;

  TeamScoreWidget({
    super.key,
    required this.teamName,
    required this.setsWon,
    required this.isHighlighted,
    this.isLeftAligned = true,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: isLeftAligned ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(
          teamName,
          style: AppTypography.headlineMd.copyWith(
            color: isHighlighted ? AppColors.accent : AppColors.accent,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: ResponsiveHelper.w(32),
          height: ResponsiveHelper.h(32),
          decoration: BoxDecoration(
            color: isHighlighted ? AppColors.accent : AppColors.card,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
          ),
          child: Center(
            child: Text(
              '$setsWon',
              style: AppTypography.headlineMd.copyWith(
                color: isHighlighted ? Colors.black : AppColors.accent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
