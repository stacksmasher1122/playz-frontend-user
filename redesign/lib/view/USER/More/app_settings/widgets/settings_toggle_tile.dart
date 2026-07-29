import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SettingsToggleTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsToggleTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
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
          child: Icon(icon, color: AppColors.accent, size: 20),
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
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.muted,
                  fontSize: context.responsiveFont(12),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: Switch.adaptive(
          value: value,
          activeTrackColor: AppColors.accent,
          activeThumbColor: AppColors.textPrimary,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
