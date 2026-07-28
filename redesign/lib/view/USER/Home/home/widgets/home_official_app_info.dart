import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

/* ============================================================
   OFFICIAL APP INFO / FOOTER
   ============================================================ */
class HomeOfficialAppInfo extends StatelessWidget {
  const HomeOfficialAppInfo({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.heightPct(3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'PlayZ',
            style: AppTypography.headlineMd.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(16),
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: context.heightPct(0.8)),
          Text(
            'Play • Book • Compete',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textSecondary,
              fontSize: context.responsiveFont(13),
            ),
          ),
          SizedBox(height: context.heightPct(1)),
          Text(
            'Built for local sports, teams, and communities.',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textSecondary,
              fontSize: context.responsiveFont(12),
            ),
          ),
          SizedBox(height: context.heightPct(1.5)),
          Text(
            '© 2026 PlayZ Technologies. All rights reserved.',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodyXs.copyWith(
              color: AppColors.textSecondary,
              fontSize: context.responsiveFont(11),
            ),
          ),
        ],
      ),
    );
  }
}
