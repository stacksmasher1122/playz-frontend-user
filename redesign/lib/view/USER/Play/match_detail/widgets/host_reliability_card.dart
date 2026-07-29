import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class HostReliabilityCard extends StatelessWidget {
  final int reliabilityScore;

  const HostReliabilityCard({
    super.key,
    this.reliabilityScore = 98,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.widthPct(4.5)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.minDimensionPct(4.5)),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "HOST RELIABILITY & SCORE",
            style: AppTypography.labelCaps10.copyWith(
              fontSize: context.responsiveFont(11),
              letterSpacing: 0.8,
              fontWeight: FontWeight.bold,
              color: AppColors.muted,
            ),
          ),
          SizedBox(height: context.heightPct(1.5)),
          Row(
            children: [
              Text(
                "$reliabilityScore%",
                style: AppTypography.displayLg.copyWith(
                  fontSize: context.responsiveFont(36),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(width: context.widthPct(3.5)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Verified Trusted Host 🛡️",
                      style: AppTypography.headlineSm.copyWith(
                        color: AppColors.accent,
                        fontSize: context.responsiveFont(14),
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: context.heightPct(0.3)),
                    Text(
                      "98% match completion rate with zero no-shows",
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.muted,
                        fontSize: context.responsiveFont(11.5),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
