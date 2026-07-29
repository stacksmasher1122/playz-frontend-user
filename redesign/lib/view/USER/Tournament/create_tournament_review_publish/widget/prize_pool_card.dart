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
    ResponsiveHelper.init(context);

    return Container(
      padding: EdgeInsets.all(context.widthPct(4)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
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
            width: context.widthPct(12).clamp(44.0, 52.0),
            height: context.widthPct(12).clamp(44.0, 52.0),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.emoji_events_rounded,
              color: AppColors.accent,
              size: context.responsiveFont(22),
            ),
          ),
          SizedBox(width: context.widthPct(3.5)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: AppTypography.labelCaps10.copyWith(
                    color: AppColors.accent,
                    fontSize: context.responsiveFont(11),
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: context.heightPct(0.5)),
                Text(
                  total,
                  style: AppTypography.headlineMd.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(18),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.heightPct(0.3)),
                Text(
                  distribution,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(12.5),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
