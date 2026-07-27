import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class RegisterSigninPrompt extends StatelessWidget {
  final VoidCallback onSigninTap;

  const RegisterSigninPrompt({super.key, required this.onSigninTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.heightPct(1.5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have an account?',
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.textSecondary,
              fontSize: context.responsiveFont(13.5),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onSigninTap,
            child: Text(
              'Sign in',
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.spotifyGreen,
                fontSize: context.responsiveFont(13.5),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
