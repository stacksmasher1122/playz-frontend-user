import 'package:flutter/material.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';

class VersusDividerWidget extends StatelessWidget {
  const VersusDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.background,
        border: Border.all(
          color: AppColors.surfaceContainerHighest,
          width: 4,
        ),
      ),
      child: Center(
        child: Text(
          'VS',
          style: AppTypography.displayScoreSora.copyWith(
            color: AppColors.primaryContainer,
          ),
        ),
      ),
    );
  }
}
