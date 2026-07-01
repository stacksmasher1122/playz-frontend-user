import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onStart;

  const ActionButtons({super.key, required this.onEdit, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: AppColors.surface, // Matches background to stick cleanly
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: onEdit,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.surfaceContainerHighest),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                'EDIT CONFIGURATION',
                style: AppTypography.labelCaps10.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: onStart,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryContainer,
                foregroundColor: AppColors.onPrimaryContainer,
                elevation: 10,
                shadowColor: AppColors.primaryContainer.withOpacity(0.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'START MATCH',
                    style: AppTypography.headlineSm.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.5),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.play_arrow),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('SESSION ID: PBZ-992-ALPHA-X', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, letterSpacing: 2)),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
