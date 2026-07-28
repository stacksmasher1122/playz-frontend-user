import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class DarkModeTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const DarkModeTile({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.accent,
        title: Text(
          'Dark Mode',
          style: AppTypography.bodySm.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.responsiveFont(14),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
