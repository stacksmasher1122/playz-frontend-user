import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ProfileSetupField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final int maxLines;
  final IconData? suffixIcon;
  final bool readOnly;
  final VoidCallback? onTap;

  const ProfileSetupField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.maxLines = 1,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelCaps10.copyWith(
            color: AppColors.muted,
            fontSize: context.responsiveFont(11),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: context.heightPct(1)),
        TextField(
          controller: controller,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          style: AppTypography.bodyMd.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.responsiveFont(14),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodyMd.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.5),
              fontSize: context.responsiveFont(13.5),
            ),
            prefixIcon: maxLines == 1
                ? Icon(
                    icon,
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                    size: context.responsiveFont(20),
                  )
                : Padding(
                    padding: EdgeInsets.only(bottom: context.heightPct(4)),
                    child: Icon(
                      icon,
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
                      size: context.responsiveFont(20),
                    ),
                  ),
            suffixIcon: suffixIcon != null
                ? Icon(
                    suffixIcon,
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                    size: context.responsiveFont(20),
                  )
                : null,
            filled: true,
            fillColor: AppColors.card,
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.widthPct(4),
              vertical: maxLines > 1 ? context.heightPct(2) : context.heightPct(1.8),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
              borderSide: const BorderSide(color: AppColors.borderDark),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
              borderSide: const BorderSide(color: AppColors.borderDark),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
              borderSide: BorderSide(
                color: AppColors.accent.withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
