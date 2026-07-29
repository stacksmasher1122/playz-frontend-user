import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QrOutlinedAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const QrOutlinedAction(
    this.label,
    this.icon, {
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
            border: Border.all(color: AppColors.borderDark),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: AppColors.textPrimary),
              SizedBox(width: context.widthPct(2)),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: context.responsiveFont(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
