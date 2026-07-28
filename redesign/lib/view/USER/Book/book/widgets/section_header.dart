import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(5)),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.headlineLgMobile.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(18),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            'See all',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.accent,
              fontSize: context.responsiveFont(13),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
