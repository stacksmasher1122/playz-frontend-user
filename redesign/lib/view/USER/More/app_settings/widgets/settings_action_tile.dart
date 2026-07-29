import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SettingsActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? valueText;
  final VoidCallback onTap;
  final Color? iconColor;

  const SettingsActionTile({
    super.key,
    required this.icon,
    required this.title,
    this.valueText,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.widthPct(4),
        vertical: context.heightPct(0.5),
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.widthPct(4),
          vertical: context.heightPct(0.5),
        ),
        leading: Container(
          padding: EdgeInsets.all(context.widthPct(2.5)),
          decoration: BoxDecoration(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor ?? AppColors.accent, size: 20),
        ),
        title: Text(
          title,
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: context.responsiveFont(14),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (valueText != null)
              Flexible(
                child: Text(
                  valueText!,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(13),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            SizedBox(width: context.widthPct(2)),
            const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.muted, size: 14),
          ],
        ),
      ),
    );
  }
}
