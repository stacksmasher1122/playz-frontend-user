import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class OnboardTopBar extends StatelessWidget {
  final VoidCallback onSkip;

  const OnboardTopBar({super.key, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(5),
        vertical: context.heightPct(1.5),
      ),
      child: Row(
        children: [
          Text(
            'PlayZ',
            style: AppTypography.headlineLg.copyWith(
              fontSize: context.responsiveFont(22),
              fontWeight: FontWeight.w900,
              color: AppColors.spotifyGreen,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: onSkip,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
            ),
            child: Text(
              'Skip',
              style: AppTypography.bodyMd.copyWith(
                fontSize: context.responsiveFont(14),
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
