import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';

class AdvancedSettingTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool valueIsHighlighted;

  const AdvancedSettingTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueIsHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Icon(icon, color: AppColors.muted, size: 20),
          const SizedBox(width: 12),
          Text(label, style: AppTypography.bodyMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
          const Spacer(),
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
