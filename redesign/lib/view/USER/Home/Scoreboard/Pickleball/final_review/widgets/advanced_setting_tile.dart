import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class AdvancedSettingTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool valueIsHighlighted;

  AdvancedSettingTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueIsHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
      child: Row(
        children: [
          Icon(icon, color: AppColors.muted, size: 20),
          SizedBox(width: 12),
          Text(label, style: AppTypography.bodyMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
          Spacer(),
          Text(
            value,
            style: AppTypography.bodyMd.copyWith(
              color: valueIsHighlighted ? AppColors.primaryContainer : AppColors.muted,
              fontWeight: valueIsHighlighted ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
