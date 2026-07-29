import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class EquipmentStatusCard extends StatelessWidget {
  final String option; // 'carry_own', 'provided', or 'none'

  const EquipmentStatusCard({
    super.key,
    required this.option,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    if (option == 'none' || option.isEmpty) return const SizedBox.shrink();

    final isProvided = option == 'provided';
    final title = isProvided ? 'Equipment Provided' : 'Carry Your Own Equipment';
    final subtitle = isProvided
        ? 'The host or venue will provide sports equipment.'
        : 'Please bring your own sports equipment to the match.';
    final icon = isProvided ? Icons.inventory_2_outlined : Icons.backpack_outlined;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.widthPct(4)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.minDimensionPct(4.5)),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(context.widthPct(2.5)),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
            ),
            child: Icon(icon, color: AppColors.accent, size: 22),
          ),
          SizedBox(width: context.widthPct(3.5)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.headlineSm.copyWith(
                    fontSize: context.responsiveFont(14),
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.heightPct(0.3)),
                Text(
                  subtitle,
                  style: AppTypography.bodySm.copyWith(
                    fontSize: context.responsiveFont(11.5),
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
