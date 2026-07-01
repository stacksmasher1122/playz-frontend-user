import 'package:flutter/material.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../theme/app_dimensions.dart';

class PmHeaderWidget extends StatelessWidget {
  const PmHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TOURNAMENT SETUP',
          style: AppTypography.labelCaps.copyWith(
            color: AppColors.primaryContainer,
          ),
        ),
        const SizedBox(height: AppDimensions.xs),
        Text(
          'Player Management',
          style: AppTypography.headlineLg.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: AppDimensions.lg),
        
        // QR Check-in Button
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            children: [
              const Icon(Icons.qr_code_scanner, color: AppColors.primaryContainer, size: 20),
              const SizedBox(width: 12),
              Text(
                'QR CHECK-IN',
                style: AppTypography.labelCaps.copyWith(
                  color: AppColors.onSurface,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
