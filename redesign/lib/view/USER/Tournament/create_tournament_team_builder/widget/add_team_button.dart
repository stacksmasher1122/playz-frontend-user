import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class AddTeamButton extends StatelessWidget {
  final VoidCallback onTap;

  const AddTeamButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(50)),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.w(16),
          vertical: ResponsiveHelper.h(8),
        ),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(50)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: AppColors.accent, size: ResponsiveHelper.w(16)),
            SizedBox(width: ResponsiveHelper.w(8)),
            Text(
              "Add Team",
              style: AppTypography.labelCaps.copyWith(color: AppColors.accent),
            ),
          ],
        ),
      ),
    );
  }
}
