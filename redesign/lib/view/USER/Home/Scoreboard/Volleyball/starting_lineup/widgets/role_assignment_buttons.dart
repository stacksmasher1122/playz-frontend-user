import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class RoleAssignmentButtons extends StatelessWidget {
  final VoidCallback onAssignCaptain;
  final VoidCallback onAssignLibero;

  RoleAssignmentButtons({super.key, required this.onAssignCaptain, required this.onAssignLibero});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onAssignCaptain,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(color: AppColors.surfaceContainerHighest),
              padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.w(12))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.stars, color: AppColors.primaryContainer, size: 20),
                SizedBox(width: 8),
                Text('Assign Captain', style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: onAssignLibero,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(color: AppColors.surfaceContainerHighest),
              padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.w(12))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shield_outlined, color: Colors.blueAccent, size: 20),
                SizedBox(width: 8),
                Text('Assign Libero', style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
