import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QrAmountRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const QrAmountRow(
    this.label,
    this.value, {
    super.key,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.heightPct(0.6)),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySm.copyWith(
                color: highlight ? AppColors.textPrimary : AppColors.muted,
                fontSize: context.responsiveFont(13),
              ),
            ),
          ),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySm.copyWith(
              color: highlight ? AppColors.textPrimary : AppColors.textSecondary,
              fontSize: context.responsiveFont(14),
              fontWeight: highlight ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
