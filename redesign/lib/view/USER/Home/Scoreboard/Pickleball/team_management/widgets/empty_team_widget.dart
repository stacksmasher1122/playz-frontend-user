import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class EmptyTeamWidget extends StatelessWidget {
  final VoidCallback onTap;

  const EmptyTeamWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(24)),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.02),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
          border: Border.all(color: Colors.white.withOpacity(0.05), style: BorderStyle.solid),
        ),
        child: Column(
          children: [
            Icon(Icons.group_add_outlined, color: AppColors.textSecondary, size: 48),
            SizedBox(height: 12),
            Text("No Player Selected", style: AppTypography.headlineSm.copyWith(color: AppColors.textSecondary)),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.accent.withOpacity(0.3)),
              ),
              child: Text("Select Player", style: AppTypography.bodyMd.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
