import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class DetailCardWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value1;
  final String value2;

  const DetailCardWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.value1,
    required this.value2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: ResponsiveHelper.w(48),
            height: ResponsiveHelper.w(48),
            decoration: BoxDecoration(
              color: AppColors.card,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.accent, size: ResponsiveHelper.w(24)),
          ),
          SizedBox(width: ResponsiveHelper.w(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodySm.copyWith(color: AppColors.muted),
                ),
                SizedBox(height: ResponsiveHelper.h(4)),
                Text(
                  value1,
                  style: AppTypography.bodyLg.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: ResponsiveHelper.h(2)),
                Text(
                  value2,
                  style: AppTypography.bodySm.copyWith(color: AppColors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
