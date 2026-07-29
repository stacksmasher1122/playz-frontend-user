import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? prefixIcon;
  final TextInputType keyboardType;
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
    ResponsiveHelper.init(context);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: AppTypography.bodyMd.copyWith(
        color: AppColors.textPrimary,
        fontSize: context.responsiveFont(14),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTypography.bodyMd.copyWith(
          color: AppColors.muted,
          fontSize: context.responsiveFont(13.5),
        ),
        prefixIcon: prefixIcon,
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.minDimensionPct(2.5)),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.minDimensionPct(2.5)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.minDimensionPct(2.5)),
          borderSide: const BorderSide(color: AppColors.accent),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.widthPct(4),
          vertical: context.heightPct(1.5),
        ),
      ),
    );
  }
}
