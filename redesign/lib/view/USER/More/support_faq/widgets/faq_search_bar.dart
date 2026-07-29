import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class FaqSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const FaqSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.widthPct(4),
        vertical: context.heightPct(1),
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: TextField(
        onChanged: onChanged,
        style: AppTypography.bodySm.copyWith(
          color: AppColors.textPrimary,
          fontSize: context.responsiveFont(14),
        ),
        decoration: InputDecoration(
          hintText: 'Search FAQs, scoreboards, bookings...',
          hintStyle: AppTypography.bodySm.copyWith(
            color: AppColors.muted.withValues(alpha: 0.6),
            fontSize: context.responsiveFont(14),
          ),
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.accent),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: context.heightPct(1.5)),
        ),
      ),
    );
  }
}
