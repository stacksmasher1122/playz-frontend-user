import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SearchPlayerWidget extends StatelessWidget {
  final TextEditingController controller;

  const SearchPlayerWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.h(16)),
      child: TextField(
        controller: controller,
        style: AppTypography.bodySm.copyWith(color: AppColors.onPrimary),
        decoration: InputDecoration(
          hintText: "Search players to add...",
          hintStyle: AppTypography.bodySm.copyWith(color: const Color(0xFF8E8E93)),
          prefixIcon: Icon(Icons.search, color: AppColors.muted, size: ResponsiveHelper.w(20)),
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: EdgeInsets.symmetric(
            vertical: ResponsiveHelper.h(12),
            horizontal: ResponsiveHelper.w(16),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
            borderSide: const BorderSide(color: Color(0xFF2C2C2E)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
            borderSide: const BorderSide(color: Color(0xFF2C2C2E)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
            borderSide: const BorderSide(color: AppColors.accent),
          ),
        ),
      ),
    );
  }
}
