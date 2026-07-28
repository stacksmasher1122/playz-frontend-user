import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LoginSignupPrompt extends StatelessWidget {
  final VoidCallback onSignupTap;

  const LoginSignupPrompt({super.key, required this.onSignupTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.heightPct(1.5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account?",
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.textSecondary,
              fontSize: context.responsiveFont(13.5),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onSignupTap,
            child: Text(
              'Register here',
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
