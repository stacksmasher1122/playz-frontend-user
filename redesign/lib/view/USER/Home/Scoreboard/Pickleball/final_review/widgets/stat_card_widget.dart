import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class StatCardWidget extends StatelessWidget {
  final Widget icon;
  final String label;
  final String value;

  StatCardWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      ),
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(20), horizontal: ResponsiveHelper.w(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          SizedBox(height: 12),
          Text(label, style: AppTypography.labelCaps10.copyWith(color: AppColors.muted)),
          SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.headlineMd.copyWith(color: AppColors.accent, fontWeight: FontWeight.w900),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
