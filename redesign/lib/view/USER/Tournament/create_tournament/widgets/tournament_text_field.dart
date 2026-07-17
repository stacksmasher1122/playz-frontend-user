import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TournamentTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;
  final int maxLines;

  const TournamentTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    this.validator,
    this.maxLines = 1,
  });

  
  @override
  State<TournamentTextField> createState() => _TournamentTextFieldState();
}

class _TournamentTextFieldState extends State<TournamentTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(8)),
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          maxLines: widget.maxLines,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary),
          decoration: InputDecoration(
            hintText: widget.hint,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
              borderSide: BorderSide(color: AppColors.error, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
