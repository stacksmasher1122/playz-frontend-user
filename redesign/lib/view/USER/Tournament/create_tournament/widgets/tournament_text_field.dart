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
    ResponsiveHelper.init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.responsiveFont(15),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: context.heightPct(1)),
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          maxLines: widget.maxLines,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: AppTypography.bodyMd.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.responsiveFont(14),
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTypography.bodyMd.copyWith(
              color: AppColors.muted,
              fontSize: context.responsiveFont(13.5),
            ),
            filled: true,
            fillColor: AppColors.card,
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.widthPct(4),
              vertical: context.heightPct(1.8),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
              borderSide: const BorderSide(color: AppColors.accent, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
              borderSide: const BorderSide(color: AppColors.error, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
