import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ActionChipWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool outlined;

  const ActionChipWidget(
    this.icon,
    this.label, {
    this.onTap,
    this.outlined = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final borderColor = outlined
        ? AppColors.borderDark
        : Colors.transparent;

    final backgroundColor = outlined
        ? Colors.transparent
        : AppColors.surface;

    final contentColor = AppColors.textPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.widthPct(3.5),
            vertical: context.heightPct(1),
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: contentColor),
              SizedBox(width: context.widthPct(1.5)),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: AppTypography.headlineSm.copyWith(
                    color: contentColor,
                    fontSize: context.responsiveFont(13),
                    fontWeight: FontWeight.w600,
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
