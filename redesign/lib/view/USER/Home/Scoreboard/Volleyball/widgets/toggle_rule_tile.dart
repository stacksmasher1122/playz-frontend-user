import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:get/get.dart';

class ToggleRuleTile extends StatelessWidget {
  final String label;
  final RxBool value;
  final Function(bool) onChanged;

  const ToggleRuleTile({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceContainerHighest),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          Obx(() => Switch(
            value: value.value,
            onChanged: onChanged,
            activeColor: AppColors.primaryContainer,
            activeTrackColor: AppColors.primaryContainer.withOpacity(0.5),
            inactiveThumbColor: AppColors.muted,
            inactiveTrackColor: AppColors.surfaceContainerHigh,
          )),
        ],
      ),
    );
  }
}
