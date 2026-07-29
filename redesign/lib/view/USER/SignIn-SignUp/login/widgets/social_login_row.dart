import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SocialLoginRow extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onGoogleLogin;
  final VoidCallback onPhoneLogin;

  const SocialLoginRow({
    super.key,
    required this.isLoading,
    required this.onGoogleLogin,
    required this.onPhoneLogin,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      children: [
        SizedBox(height: context.heightPct(2.4)),

        /// ─── DIVIDER
        Row(
          children: [
            const Expanded(
              child: Divider(color: AppColors.borderDark),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.widthPct(3),
              ),
              child: Text(
                'or continue with',
                style: AppTypography.bodySm.copyWith(
                  fontSize: context.responsiveFont(12),
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const Expanded(
              child: Divider(color: AppColors.borderDark),
            ),
          ],
        ),

        SizedBox(height: context.heightPct(1.8)),

        /// SOCIAL BUTTONS
        Row(
          children: [
            Expanded(
              child: _SocialButton(
                icon: Icons.g_mobiledata_rounded,
                label: 'Google',
                onPressed: onGoogleLogin,
                isLoading: isLoading,
              ),
            ),
            SizedBox(width: context.widthPct(3)),
            Expanded(
              child: _SocialButton(
                icon: Icons.phone_rounded,
                label: 'Phone',
                onPressed: onPhoneLogin,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const _SocialButton({
    required this.icon,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: isLoading ? null : onPressed ?? () {},
      icon: Icon(
        icon,
        color: AppColors.accent,
        size: context.responsiveFont(20),
      ),
      label: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          style: AppTypography.bodyMd.copyWith(
            color: AppColors.accent,
            fontSize: context.responsiveFont(13.5),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: context.heightPct(1.4)),
        side: const BorderSide(color: AppColors.borderDark),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
        ),
      ),
    );
  }
}
