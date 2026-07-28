import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

import 'package:redesign/view/USER/More/reward_center/reward_center_screen.dart';

class RewardsCard extends StatelessWidget {
  const RewardsCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final iconBgSize = context.minDimensionPct(11).clamp(38.0, 46.0);
    final chevronBgSize = context.minDimensionPct(8).clamp(28.0, 36.0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
        child: InkWell(
          borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RewardCenterScreen()),
            );
          },
          child: Container(
            padding: EdgeInsets.all(context.widthPct(4)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 0),
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.surface, AppColors.accent.withValues(alpha: 0.12)],
              ),
              border: Border.all(color: AppColors.borderDark),
            ),
            child: Row(
              children: [
                /// ICON CONTAINER
                Container(
                  height: iconBgSize,
                  width: iconBgSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accent.withValues(alpha: 0.15),
                  ),
                  child: Icon(
                    Icons.card_giftcard,
                    color: AppColors.accent,
                    size: iconBgSize * 0.52,
                  ),
                ),

                SizedBox(width: context.widthPct(3.5)),

                /// TEXT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rewards Center',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: context.responsiveFont(15),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: context.heightPct(0.3)),
                      Text(
                        'Redeem coins for merch & discounts',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.muted,
                          fontSize: context.responsiveFont(12),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: context.widthPct(2.5)),

                /// CTA
                Container(
                  height: chevronBgSize,
                  width: chevronBgSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.card,
                  ),
                  child: Icon(
                    Icons.chevron_right,
                    color: AppColors.textPrimary,
                    size: chevronBgSize * 0.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
