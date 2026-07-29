import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SpecialInstructionsCard extends StatelessWidget {
  final String instructions;

  const SpecialInstructionsCard({
    super.key,
    required this.instructions,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    if (instructions.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.widthPct(4.5)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.minDimensionPct(4.5)),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.sticky_note_2_rounded, color: AppColors.accent, size: 18),
              SizedBox(width: context.widthPct(2)),
              Text(
                "HOST SPECIAL INSTRUCTIONS",
                style: AppTypography.labelCaps10.copyWith(
                  fontSize: context.responsiveFont(12),
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.bold,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
          SizedBox(height: context.heightPct(1.5)),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(context.widthPct(3)),
            decoration: BoxDecoration(
              color: AppColors.textPrimary.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
              border: Border.all(color: AppColors.borderDark),
            ),
            child: Text(
              instructions,
              style: AppTypography.bodySm.copyWith(
                fontSize: context.responsiveFont(13),
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
