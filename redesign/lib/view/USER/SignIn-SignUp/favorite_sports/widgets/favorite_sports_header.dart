import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class FavoriteSportsHeader extends StatelessWidget {
  const FavoriteSportsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.widthPct(5),
        context.heightPct(2),
        context.widthPct(5),
        context.heightPct(3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select your favorites',
            style: AppTypography.displaySm.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(26),
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: context.heightPct(1)),
          Text(
            'Choose at least 4 sports to personalize your feed',
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.muted,
              fontSize: context.responsiveFont(14),
            ),
          ),
        ],
      ),
    );
  }
}
