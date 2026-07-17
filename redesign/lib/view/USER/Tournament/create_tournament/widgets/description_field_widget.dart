import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class DescriptionFieldWidget extends StatefulWidget {
  final TextEditingController controller;

  const DescriptionFieldWidget({
    super.key,
    required this.controller,
  });

  
  @override
  State<DescriptionFieldWidget> createState() => _DescriptionFieldWidgetState();
}

class _DescriptionFieldWidgetState extends State<DescriptionFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description",
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(8)),
        TextFormField(
          controller: widget.controller,
          maxLines: 4,
          style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary),
          decoration: InputDecoration(
            hintText: "Brief rules, location info, etc.",
            hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.muted),
            filled: true,
            fillColor: AppColors.card,
            contentPadding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.w(16),
              vertical: ResponsiveHelper.h(16),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
              borderSide: BorderSide(color: AppColors.accent, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
