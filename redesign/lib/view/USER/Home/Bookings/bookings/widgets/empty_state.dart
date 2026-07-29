import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BookingsEmptyState extends StatelessWidget {
  final IconData icon;
  final String text;

  const BookingsEmptyState({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final iconSize = context.minDimensionPct(12).clamp(40.0, 56.0);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: iconSize, color: AppColors.muted),
          SizedBox(height: context.heightPct(1.5)),
          Text(
            text,
            textAlign: TextAlign.center,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textSecondary,
              fontSize: context.responsiveFont(14),
            ),
          ),
        ],
      ),
    );
  }
}
