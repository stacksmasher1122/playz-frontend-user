import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ReviewInfoTile extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  ReviewInfoTile({super.key, required this.label, required this.value, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTypography.bodyMd.copyWith(color: AppColors.muted)),
              Text(value, style: AppTypography.bodyMd.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        if (!isLast) Divider(color: AppColors.outlineVariant, height: 1),
      ],
    );
  }
}
