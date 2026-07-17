import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onStart;

  ActionButtons({super.key, required this.onEdit, required this.onStart});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
      color: AppColors.surface, // Matches background to stick cleanly
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: ResponsiveHelper.h(50),
            child: OutlinedButton(
              onPressed: onEdit,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.accent,
                side: BorderSide(color: AppColors.outlineVariant),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.w(12))),
              ),
              child: Text(
                'EDIT CONFIGURATION',
                style: AppTypography.labelCaps10.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: ResponsiveHelper.h(60),
            child: ElevatedButton(
              onPressed: onStart,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.background,
                elevation: 10,
                shadowColor: AppColors.accent.withOpacity(0.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.w(12))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'START MATCH',
                    style: AppTypography.headlineSm.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.5),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.play_arrow),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Text('SESSION ID: PBZ-992-ALPHA-X', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, letterSpacing: 2)),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
