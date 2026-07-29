import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: context.widthPct(1)),
        child: Text(
          title,
          style: AppTypography.labelCaps10.copyWith(
            color: AppColors.muted.withValues(alpha: 0.5),
            fontSize: context.responsiveFont(10),
            letterSpacing: 1.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
