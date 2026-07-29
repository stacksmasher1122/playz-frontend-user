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
    ResponsiveHelper.init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description",
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.responsiveFont(15),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: context.heightPct(1)),
        TextFormField(
          controller: widget.controller,
          maxLines: 4,
          style: AppTypography.bodyMd.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.responsiveFont(14),
          ),
          decoration: InputDecoration(
            hintText: "Brief rules, location info, etc.",
            hintStyle: AppTypography.bodyMd.copyWith(
              color: AppColors.muted,
              fontSize: context.responsiveFont(13.5),
            ),
            filled: true,
            fillColor: AppColors.card,
            contentPadding: EdgeInsets.all(context.widthPct(4)),
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
          ),
        ),
      ],
    );
  }
}
