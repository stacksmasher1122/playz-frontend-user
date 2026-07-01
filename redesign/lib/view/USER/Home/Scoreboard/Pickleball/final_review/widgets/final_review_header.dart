import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class FinalReviewHeader extends StatelessWidget {
  FinalReviewHeader({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Final Review', style: AppTypography.headlineLg),
        SizedBox(height: 8),
        Text(
          'Confirm your match settings before the serve.',
          style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
        ),
      ],
    );
  }
}
