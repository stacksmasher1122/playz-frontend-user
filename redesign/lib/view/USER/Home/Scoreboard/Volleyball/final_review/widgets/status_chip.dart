import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

enum SystemStatus { connected, waiting, offline, ready }

class StatusChip extends StatelessWidget {
  final SystemStatus status;

  StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    Color bgColor;
    Color textColor;
    String text;
    IconData icon;

    switch (status) {
      case SystemStatus.connected:
        bgColor = AppColors.accent.withOpacity(0.1);
        textColor = AppColors.accent;
        text = 'Active Connection';
        icon = Icons.wifi;
        break;
      case SystemStatus.waiting:
        bgColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        text = 'Waiting for signal';
        icon = Icons.hourglass_empty;
        break;
      case SystemStatus.offline:
        bgColor = AppColors.error.withOpacity(0.1);
        textColor = AppColors.error;
        text = 'Offline';
        icon = Icons.wifi_off;
        break;
      case SystemStatus.ready:
        bgColor = AppColors.accent.withOpacity(0.1);
        textColor = AppColors.accent;
        text = 'Ready';
        icon = Icons.check_circle_outline;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(8), vertical: ResponsiveHelper.h(4)),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 12),
          SizedBox(width: 4),
          Text(text, style: AppTypography.labelCaps10.copyWith(color: textColor, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
