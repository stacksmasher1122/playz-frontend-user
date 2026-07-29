import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QrDangerAction extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const QrDangerAction(
    this.label, {
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.widthPct(4.5),
            vertical: context.heightPct(1.6),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
            border: Border.all(
              color: AppColors.error.withValues(alpha: 0.4),
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
                fontSize: context.responsiveFont(14),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
