import 'package:flutter/material.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../theme/app_dimensions.dart';

class SmBreadcrumbWidget extends StatelessWidget {
  const SmBreadcrumbWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NEW FIXTURE',
            style: AppTypography.labelCaps.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppDimensions.xs),
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 768;
              return Text(
                'Setup Match',
                style: isMobile 
                  ? AppTypography.headlineLgMobile.copyWith(color: AppColors.primary)
                  : AppTypography.headlineLg.copyWith(color: AppColors.primary),
              );
            },
          ),
        ],
      ),
    );
  }
}
