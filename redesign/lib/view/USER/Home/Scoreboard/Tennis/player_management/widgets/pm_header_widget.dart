import 'package:flutter/material.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../theme/app_dimensions.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PmHeaderWidget extends StatelessWidget {
  PmHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TOURNAMENT SETUP',
          style: AppTypography.labelCaps.copyWith(
            color: AppColors.primaryContainer,
          ),
        ),
        SizedBox(height: AppDimensions.xs),
        Text(
          'Player Management',
          style: AppTypography.headlineLg.copyWith(color: AppColors.primary),
        ),
        SizedBox(height: AppDimensions.lg),
        
        // QR Check-in Button
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16), horizontal: ResponsiveHelper.w(20)),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            children: [
              Icon(Icons.qr_code_scanner, color: AppColors.primaryContainer, size: 20),
              SizedBox(width: 12),
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
