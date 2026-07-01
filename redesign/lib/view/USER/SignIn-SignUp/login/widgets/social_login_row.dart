import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

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
    return Column(
      children: [
        const SizedBox(height: 28),

        /// ─── DIVIDER
        Row(
          children: [
            Expanded(
              child: Divider(
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              child: Text(
                'or continue with',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        /// 🌐 SOCIAL BUTTONS
        Row(
          children: [
            Expanded(
              child: _SocialButton(
                icon: Icons.g_mobiledata,
                label: 'Google',
                onPressed: onGoogleLogin,
                isLoading: isLoading,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SocialButton(
                icon: Icons.phone,
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
      icon: Icon(icon, color: AppColors.accent),
      label: Text(label, style: const TextStyle(color: AppColors.accent)),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
