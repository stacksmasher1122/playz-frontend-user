import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

/// A reusable Pro Rules toggle switch card widget.
class ProRulesSwitchCard extends StatelessWidget {
  final RxBool valueStream;
  final ValueChanged<bool> onChanged;
  final String title;
  final String subtitle;
  final IconData icon;

  const ProRulesSwitchCard({
    super.key,
    required this.valueStream,
    required this.onChanged,
    this.title = 'PRO RULES',
    this.subtitle = 'Formal Match Guidelines & Offside/LBW/Over Rules',
    this.icon = Icons.gavel_rounded,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20.0)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(20.0),
        vertical: ResponsiveHelper.h(18.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveHelper.w(10.0)),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(12.0)),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.accent,
                    size: ResponsiveHelper.w(22.0),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(14.0)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: ResponsiveHelper.sp(15.0),
                          fontWeight: FontWeight.bold,
                        ).responsive(context),
                      ),
                      SizedBox(height: ResponsiveHelper.h(4.0)),
                      Text(
                        subtitle,
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.mutedText,
                          fontSize: ResponsiveHelper.sp(12.0),
                          height: 1.2,
                        ).responsive(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => Switch(
              value: valueStream.value,
              onChanged: onChanged,
              activeColor: AppColors.background,
              activeTrackColor: AppColors.accent,
              inactiveThumbColor: AppColors.mutedText,
              inactiveTrackColor: const Color(0xFF131313),
            ),
          ),
        ],
      ),
    );
  }
}
