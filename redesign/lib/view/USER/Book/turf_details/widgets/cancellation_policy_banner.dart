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
        padding: EdgeInsets.all(context.widthPct(3)),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
          border: Border.all(color: AppColors.error),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning, color: AppColors.error),
            SizedBox(width: context.widthPct(2)),
            Expanded(
              child: Text(
                'Free cancellation up to 4 hours before the booked slot. 50% refund thereafter.',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.error,
                  fontSize: context.responsiveFont(13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
