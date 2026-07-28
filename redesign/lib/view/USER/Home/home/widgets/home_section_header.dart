import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

/* ============================================================
   SECTION HEADER
   ============================================================ */
class HomeSectionHeader extends StatelessWidget {
  final String title;
  const HomeSectionHeader(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Row(
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
          'See All',
          style: AppTypography.bodySm.copyWith(
            color: AppColors.accent,
            fontSize: context.responsiveFont(13),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
