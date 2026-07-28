import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class EliteBadge extends StatelessWidget {
  final String label;
  const EliteBadge(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(1.5),
        vertical: context.heightPct(0.3),
      ),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(context.minDimensionPct(2)),
      ),
      child: Text(
        label,
        style: AppTypography.labelCaps10.copyWith(
          fontSize: context.responsiveFont(10),
          fontWeight: FontWeight.w700,
          color: AppColors.background,
        ),
      ),
    );
  }
}
