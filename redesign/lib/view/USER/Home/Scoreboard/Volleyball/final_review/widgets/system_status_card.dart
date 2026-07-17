import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'status_chip.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SystemStatusCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final SystemStatus status;

  SystemStatusCard({
    super.key,
    required this.icon,
    required this.title,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    Color iconBgColor = Colors.blueAccent;
    if (status == SystemStatus.ready) iconBgColor = AppColors.accent;
    if (status == SystemStatus.offline) iconBgColor = AppColors.error;

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.w(12)),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.headlineSm.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                StatusChip(status: status),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
