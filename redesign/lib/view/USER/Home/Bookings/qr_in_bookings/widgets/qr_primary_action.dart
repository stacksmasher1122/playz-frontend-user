import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QrPrimaryAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const QrPrimaryAction(
    this.label,
    this.icon, {
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Material(
      color: AppColors.accent,
      borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
      child: InkWell(
        borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.widthPct(4.5),
            vertical: context.heightPct(1.6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: AppColors.background),
              SizedBox(width: context.widthPct(2)),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.background,
                    fontWeight: FontWeight.w700,
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
