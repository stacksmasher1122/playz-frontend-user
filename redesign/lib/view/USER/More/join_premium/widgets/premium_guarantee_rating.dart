import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PremiumGuaranteeRating extends StatelessWidget {
  const PremiumGuaranteeRating({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      children: [
        // Star Rating Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(
              5,
              (index) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: Icon(Icons.star, color: AppColors.accent, size: 18),
              ),
            ),
            SizedBox(width: context.widthPct(2)),
            Text(
              '4.9/5 Rating',
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(13),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: context.heightPct(1)),

        // 7-Day Money Back Guarantee Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shield_outlined, color: AppColors.muted, size: 14),
            SizedBox(width: context.widthPct(1.5)),
            Text(
              '7-Day Money Back Guarantee',
              style: AppTypography.bodySm.copyWith(
                color: AppColors.muted,
                fontSize: context.responsiveFont(12),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
