import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final bool readOnly;
  final VoidCallback? onTap;

  MatchTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
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
        Text(label, style: AppTypography.bodySm.copyWith(color: AppColors.muted)),
        SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          style: AppTypography.bodyMd.copyWith(color: AppColors.accent),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.outlineVariant),
            filled: true,
            fillColor: AppColors.card,
            contentPadding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(14)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
              borderSide: BorderSide.none,
            ),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
