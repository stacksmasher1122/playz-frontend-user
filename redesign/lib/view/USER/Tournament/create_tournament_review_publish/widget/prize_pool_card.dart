import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PrizePoolCard extends StatelessWidget {
  final String title;
  final String total;
  final String distribution;

  const PrizePoolCard({
    super.key,
    required this.title,
    required this.total,
    required this.distribution,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.card,
            AppColors.card.withValues(alpha: 0.2),
          ],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: ResponsiveHelper.w(48),
            height: ResponsiveHelper.w(48),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.emoji_events, color: AppColors.accent, size: ResponsiveHelper.w(24)),
          ),
          SizedBox(width: ResponsiveHelper.w(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: AppTypography.labelCaps.copyWith(
                    color: AppColors.accent,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: ResponsiveHelper.h(4)),
                Text(
                  total,
                  style: AppTypography.headlineMd.copyWith(color: AppColors.onPrimary),
                ),
                SizedBox(height: ResponsiveHelper.h(2)),
                Text(
                  distribution,
                  style: AppTypography.bodySm.copyWith(color: AppColors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
