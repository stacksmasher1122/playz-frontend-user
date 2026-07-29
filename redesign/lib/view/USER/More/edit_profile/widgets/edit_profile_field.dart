import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class EditProfileField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;

  const EditProfileField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.maxLines = 1,
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
            fontSize: context.responsiveFont(10),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: context.heightPct(0.8)),
        TextField(
          controller: controller,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          style: AppTypography.bodySm.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.responsiveFont(15),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodySm.copyWith(
              color: AppColors.muted.withValues(alpha: 0.5),
              fontSize: context.responsiveFont(14),
            ),
            prefixIcon: maxLines == 1
                ? Icon(icon, color: AppColors.muted, size: 20)
                : Padding(
                    padding: EdgeInsets.only(bottom: context.heightPct(4)),
                    child: Icon(icon, color: AppColors.muted, size: 20),
                  ),
            filled: true,
            fillColor: AppColors.card,
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.widthPct(4),
              vertical: maxLines > 1 ? context.heightPct(1.8) : context.heightPct(2),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
              borderSide: const BorderSide(color: AppColors.borderDark),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
              borderSide: const BorderSide(color: AppColors.borderDark),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
              borderSide: BorderSide(
                color: AppColors.accent.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
