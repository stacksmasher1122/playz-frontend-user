import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';

class FinalReviewHeader extends StatelessWidget {
  const FinalReviewHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Final Review', style: AppTypography.headlineLg),
        const SizedBox(height: 8),
        Text(
          'Confirm your match settings before the serve.',
          style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
        ),
      ],
    );
  }
}
