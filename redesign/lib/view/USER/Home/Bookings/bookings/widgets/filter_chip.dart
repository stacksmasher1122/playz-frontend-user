import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BookingFilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;

  const BookingFilterChip(this.label, {super.key, this.icon});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.only(right: context.widthPct(2)),
      child: Chip(
        backgroundColor: AppColors.surface,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) Icon(icon, size: 14, color: AppColors.accent),
            if (icon != null) SizedBox(width: context.widthPct(1.5)),
            Text(
              label,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(12),
              ),
            ),
          ],
        ),
        shape: StadiumBorder(
          side: BorderSide(color: AppColors.accent.withValues(alpha: 0.6)),
        ),
      ),
    );
  }
}
