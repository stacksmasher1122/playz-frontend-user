import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? prefixIcon;
  final TextInputType keyboardType;
  // onChanged was missing — added to fix the undefined_named_parameter error
  // in player_search_step.dart which passes a callback for real-time search.
  final ValueChanged<String>? onChanged;

  const CommonTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      // Wire the onChanged callback so callers (e.g. player_search_step.dart)
      // receive real-time change notifications for search/filter logic.
      onChanged: onChanged,
      style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.muted),
        prefixIcon: prefixIcon,
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
          borderSide: const BorderSide(color: AppColors.accent),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.w(16),
          vertical: ResponsiveHelper.h(12),
        ),
      ),
    );
  }
}
