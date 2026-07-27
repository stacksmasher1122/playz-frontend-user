import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: context.heightPct(1.2)),
        Text(
          'Welcome back',
          style: AppTypography.headlineLg.copyWith(
            fontSize: context.responsiveFont(22),
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.2,
          ),
        ),
        SizedBox(height: context.heightPct(0.8)),
        Text(
          'Ready to get back on the field?',
          textAlign: TextAlign.center,
          style: AppTypography.bodyMd.copyWith(
            fontSize: context.responsiveFont(13.5),
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
