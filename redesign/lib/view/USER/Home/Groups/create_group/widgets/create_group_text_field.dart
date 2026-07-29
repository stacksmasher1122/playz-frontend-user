import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CreateGroupTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final int? maxLength;

  const CreateGroupTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(3.5),
        vertical: context.heightPct(0.5),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: TextField(
        controller: controller,
        style: AppTypography.bodySm.copyWith(
          color: AppColors.textPrimary,
          fontSize: context.responsiveFont(14),
        ),
        maxLines: maxLines,
        maxLength: maxLength,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTypography.bodySm.copyWith(
            color: AppColors.muted,
            fontSize: context.responsiveFont(14),
          ),
          border: InputBorder.none,
          counterText: '',
        ),
      ),
    );
  }
}
