import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CancellationPolicyBanner extends StatelessWidget {
  const CancellationPolicyBanner({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      child: Container(
        padding: EdgeInsets.all(context.widthPct(3.5)),
        decoration: BoxDecoration(
          color: AppColors.accent.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
          border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            const Icon(Icons.verified_user_outlined, color: AppColors.accent),
            SizedBox(width: context.widthPct(3)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cancellation Policy',
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.accent,
                      fontSize: context.responsiveFont(13),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: context.heightPct(0.3)),
                  Text(
                    'Full refund if cancelled at least 5 days prior to booking date. No refund thereafter.',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: context.responsiveFont(12),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
