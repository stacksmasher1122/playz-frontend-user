import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';

enum SystemStatus { connected, waiting, offline, ready }

class StatusChip extends StatelessWidget {
  final SystemStatus status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String text;
    IconData icon;

    switch (status) {
      case SystemStatus.connected:
        bgColor = AppColors.primaryContainer.withOpacity(0.1);
        textColor = AppColors.primaryContainer;
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
        bgColor = AppColors.primaryContainer.withOpacity(0.1);
        textColor = AppColors.primaryContainer;
        text = 'Ready';
        icon = Icons.check_circle_outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 12),
          const SizedBox(width: 4),
          Text(text, style: AppTypography.labelCaps10.copyWith(color: textColor, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
