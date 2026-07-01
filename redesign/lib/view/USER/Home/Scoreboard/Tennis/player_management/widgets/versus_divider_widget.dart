import 'package:flutter/material.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class VersusDividerWidget extends StatelessWidget {
  VersusDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      width: ResponsiveHelper.w(64),
      height: ResponsiveHelper.h(64),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.background,
        border: Border.all(
          color: AppColors.surfaceContainerHighest,
          width: ResponsiveHelper.w(4),
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
