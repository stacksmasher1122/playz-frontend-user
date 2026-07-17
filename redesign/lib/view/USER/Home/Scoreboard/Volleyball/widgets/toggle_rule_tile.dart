import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ToggleRuleTile extends StatelessWidget {
  final String label;
  final RxBool value;
  final Function(bool) onChanged;

  ToggleRuleTile({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      height: ResponsiveHelper.h(48),
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          Obx(() => Switch(
            value: value.value,
            onChanged: onChanged,
            activeColor: AppColors.accent,
            activeTrackColor: AppColors.accent.withOpacity(0.5),
            inactiveThumbColor: AppColors.muted,
            inactiveTrackColor: AppColors.card,
          )),
        ],
      ),
    );
  }
}
