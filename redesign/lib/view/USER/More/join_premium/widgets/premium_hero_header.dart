import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PremiumHeroHeader extends StatelessWidget {
  const PremiumHeroHeader({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final badgeSize = context.minDimensionPct(16).clamp(60.0, 76.0);

    return Column(
      children: [
        // Top Close Button Row
        Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
            child: Container(
              padding: EdgeInsets.all(context.widthPct(2)),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: AppColors.textPrimary,
                size: 24,
              ),
            ),
          ),
        ),
        SizedBox(height: context.heightPct(1)),

        // Circular Green Medal Badge
        Container(
          width: badgeSize,
          height: badgeSize,
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.accent.withValues(alpha: 0.6),
              width: 2,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.workspace_premium,
              color: AppColors.accent,
              size: 38,
            ),
          ),
        ),
        SizedBox(height: context.heightPct(2)),

        // Title: Upgrade to PlayZ Pro
        Text(
          'Upgrade to PlayZ Pro',
          textAlign: TextAlign.center,
          style: AppTypography.displayLg.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.responsiveFont(24),
            fontWeight: FontWeight.w900,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: context.heightPct(0.8)),

        // Subtitle: Unlock premium features for every sport
        Text(
          'Unlock premium features for every sport',
          textAlign: TextAlign.center,
          style: AppTypography.bodySm.copyWith(
            color: AppColors.muted,
            fontSize: context.responsiveFont(14),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
