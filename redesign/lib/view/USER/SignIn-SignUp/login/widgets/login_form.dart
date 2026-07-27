import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool rememberMe;
  final bool isLoading;
  final Function(bool?) onRememberMeChanged;
  final VoidCallback onForgotPassword;
  final VoidCallback onLogin;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.rememberMe,
    required this.isLoading,
    required this.onRememberMeChanged,
    required this.onForgotPassword,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          SizedBox(height: context.heightPct(2)),

          /// 📧 EMAIL
          _InputField(
            controller: emailController,
            icon: Icons.email_outlined,
            hint: 'user@playz.com',
            fillColor: AppColors.card,
            validator: (value) =>
                value == null || value.isEmpty ? 'Email is required' : null,
          ),

          SizedBox(height: context.heightPct(1.5)),

          /// 🔒 PASSWORD
          _InputField(
            controller: passwordController,
            icon: Icons.lock_outline,
            hint: '••••••••',
            obscure: true,
            fillColor: AppColors.card,
            validator: (value) =>
                value == null || value.length < 6
                    ? 'Minimum 6 characters'
                    : null,
          ),

          SizedBox(height: context.heightPct(1.2)),

          /// ☑ REMEMBER + FORGOT
          Row(
            children: [
              Transform.scale(
                scale: 0.9,
                child: Checkbox(
                  value: rememberMe,
                  activeColor: AppColors.spotifyGreen,
                  checkColor: AppColors.background,
                  side: BorderSide(
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  onChanged: onRememberMeChanged,
                ),
              ),
              Text(
                'Remember me',
                style: AppTypography.bodySm.copyWith(
                  fontSize: context.responsiveFont(12.5),
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: onForgotPassword,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                ),
                child: Text(
                  'Forgot password?',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.spotifyGreen,
                    fontSize: context.responsiveFont(12.5),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: context.heightPct(1.8)),

          /// PRIMARY CTA BUTTON
          SizedBox(
            width: double.infinity,
            height: context.responsiveFont(48),
            child: ElevatedButton(
              onPressed: isLoading ? null : onLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.spotifyGreen,
                disabledBackgroundColor: AppColors.spotifyGreen
                    .withValues(alpha: 0.5),
                elevation: 0,
                shape: const StadiumBorder(),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isLoading
                    ? SizedBox(
                        key: const ValueKey('loader'),
                        height: context.responsiveFont(20),
                        width: context.responsiveFont(20),
                        child: const CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: AppColors.background,
                        ),
                      )
                    : Text(
                        'Sign In',
                        key: const ValueKey('text'),
                        style: AppTypography.headlineSm.copyWith(
                          fontSize: context.responsiveFont(15.5),
                          fontWeight: FontWeight.w800,
                          color: AppColors.background,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String hint;
  final bool obscure;
  final Color fillColor;
  final String? Function(String?)? validator;

  const _InputField({
    required this.controller,
    required this.icon,
    required this.hint,
    required this.fillColor,
    this.obscure = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: AppTypography.bodyMd.copyWith(
        color: AppColors.textPrimary,
        fontSize: context.responsiveFont(14),
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: AppColors.textSecondary,
          size: context.responsiveFont(20),
        ),
        hintText: hint,
        hintStyle: AppTypography.bodyMd.copyWith(
          color: AppColors.textSecondary.withValues(alpha: 0.6),
          fontSize: context.responsiveFont(14),
        ),
        filled: true,
        fillColor: fillColor,
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.widthPct(4),
          vertical: context.heightPct(1.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
