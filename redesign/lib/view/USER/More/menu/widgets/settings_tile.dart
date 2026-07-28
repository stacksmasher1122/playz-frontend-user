import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.label,
    this.color = AppColors.textPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: color),
        title: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.bodySm.copyWith(
            color: color,
            fontSize: context.responsiveFont(14),
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      ),
    );
  }
}
