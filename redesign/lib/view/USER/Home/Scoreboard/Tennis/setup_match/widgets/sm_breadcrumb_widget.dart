import 'package:flutter/material.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../theme/app_dimensions.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SmBreadcrumbWidget extends StatelessWidget {
  SmBreadcrumbWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NEW FIXTURE',
            style: AppTypography.labelCaps.copyWith(
              color: AppColors.muted,
            ),
          ),
          SizedBox(height: AppDimensions.xs),
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 768;
              return Text(
                'Setup Match',
                style: isMobile 
                  ? AppTypography.headlineLgMobile.copyWith(color: AppColors.accent)
                  : AppTypography.headlineLg.copyWith(color: AppColors.accent),
              );
            },
          ),
        ],
      ),
    );
  }
}
