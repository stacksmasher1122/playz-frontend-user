import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_dimensions.dart';
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
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: (label.isEmpty ? context.widthPct(3.2) : context.widthPct(2.5)).clamp(AppDimensions.xs, AppDimensions.md),
            vertical: context.heightPct(1.0).clamp(AppDimensions.xs, AppDimensions.sm),
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: AppDimensions.iconSm, color: contentColor),
              if (label.isNotEmpty) ...[
                SizedBox(width: AppDimensions.xs),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.headlineSm.copyWith(
                        color: contentColor,
                        fontSize: context.responsiveFont(12),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
