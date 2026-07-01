import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';

class ReviewInfoTile extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const ReviewInfoTile({super.key, required this.label, required this.value, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTypography.bodyMd.copyWith(color: AppColors.muted)),
              Text(value, style: AppTypography.bodyMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        if (!isLast) const Divider(color: AppColors.surfaceContainerHighest, height: 1),
      ],
    );
  }
}
