import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

class CommonSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CommonSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.background,
      activeTrackColor: AppColors.accent,
      inactiveThumbColor: AppColors.muted,
      inactiveTrackColor: AppColors.outlineVariant,
    );
  }
}
