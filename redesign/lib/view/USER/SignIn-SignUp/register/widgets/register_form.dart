import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class RegisterForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isLoading;
  final VoidCallback onRegister;

  const RegisterForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isLoading,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Form(
      key: formKey,
      child: Column(
        children: [
          SizedBox(height: context.heightPct(2)),

          /// 👤 FULL NAME
          _InputField(
            controller: nameController,
            icon: Icons.person_outline_rounded,
            hint: 'Full Name',
            fillColor: AppColors.card,
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          SizedBox(height: context.heightPct(1.5)),

          /// 📧 EMAIL ADDRESS
          _InputField(
            controller: emailController,
            icon: Icons.email_outlined,
            hint: 'Email Address',
            fillColor: AppColors.card,
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          SizedBox(height: context.heightPct(1.5)),

          /// 🔒 PASSWORD
          _InputField(
            controller: passwordController,
            icon: Icons.lock_outline_rounded,
            hint: 'Password',
            obscure: true,
            fillColor: AppColors.card,
            validator: (v) =>
                v != null && v.length < 6 ? 'Min 6 characters' : null,
          ),
          SizedBox(height: context.heightPct(1.5)),

          /// 🔒 CONFIRM PASSWORD
          _InputField(
            controller: confirmPasswordController,
            icon: Icons.lock_outline_rounded,
            hint: 'Confirm Password',
            obscure: true,
            fillColor: AppColors.card,
            validator: (v) =>
                v != passwordController.text ? 'Passwords do not match' : null,
          ),
          SizedBox(height: context.heightPct(2.2)),

          /// CREATE ACCOUNT BUTTON
          SizedBox(
            width: double.infinity,
            height: context.heightPct(6).clamp(48.0, 56.0),
            child: ElevatedButton(
              onPressed: isLoading ? null : onRegister,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                disabledBackgroundColor: AppColors.accent.withValues(alpha: 0.5),
                shape: const StadiumBorder(),
                elevation: 0,
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
                    : FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Create Account',
                          key: const ValueKey('text'),
                          style: AppTypography.headlineSm.copyWith(
                            color: AppColors.background,
                            fontSize: context.responsiveFont(15.5),
                            fontWeight: FontWeight.w800,
                          ),
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
