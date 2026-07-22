import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class KickoffBallWidget extends StatelessWidget {
  KickoffBallWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      width: ResponsiveHelper.w(24),
      height: ResponsiveHelper.h(24),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.accent, // Lime Green
        border: Border.all(color: AppColors.background, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.6),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}
