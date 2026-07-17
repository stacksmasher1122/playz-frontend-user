import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SummaryCardWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? unit;

  SummaryCardWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.unit,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        border: Border.all(color: AppColors.outlineVariant, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.muted, size: 24),
          SizedBox(height: 12),
          Text(label, style: AppTypography.labelCaps10.copyWith(color: AppColors.muted)),
          SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: AppTypography.headlineLg.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
              if (unit != null) ...[
                SizedBox(width: 4),
                Text(unit!, style: AppTypography.bodySm.copyWith(color: AppColors.muted)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
