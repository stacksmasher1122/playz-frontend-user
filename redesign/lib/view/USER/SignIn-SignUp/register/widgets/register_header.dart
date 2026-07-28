import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: context.heightPct(1.2)),
        Text(
          'Create Account',
          style: AppTypography.headlineLg.copyWith(
            fontSize: context.responsiveFont(22),
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.2,
          ),
        ),
        SizedBox(height: context.heightPct(0.8)),
        Text(
          'Join the PlayZ sports community',
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
