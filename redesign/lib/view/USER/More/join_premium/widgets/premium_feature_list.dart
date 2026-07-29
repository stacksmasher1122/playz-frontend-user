import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PremiumFeatureList extends StatelessWidget {
  const PremiumFeatureList({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final features = [
      'Unlimited Match History',
      'Advanced Performance Analytics',
      'AI-Powered Coaching Insights',
      'Exclusive Premium Badges',
      'Priority Booking at Partner Venues',
    ];

    return Column(
      children: features.map((feature) {
        return Padding(
          padding: EdgeInsets.only(bottom: context.heightPct(1.5)),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.accent,
                  size: 20,
                ),
              ),
              SizedBox(width: context.widthPct(3)),
              Expanded(
                child: Text(
                  feature,
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(14),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
