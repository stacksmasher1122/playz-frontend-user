import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TimingDropdownWidget extends StatefulWidget {
  final List<String> options;
  final String selectedValue;
  final Function(String?) onChanged;

  const TimingDropdownWidget({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  State<TimingDropdownWidget> createState() => _TimingDropdownWidgetState();
}

class _TimingDropdownWidgetState extends State<TimingDropdownWidget> {
  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Preferred Match Timings",
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.responsiveFont(15),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: context.heightPct(1)),
        DropdownButtonFormField<String>(
          initialValue: widget.selectedValue,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.muted,
            size: context.responsiveFont(22),
          ),
          dropdownColor: AppColors.card,
          style: AppTypography.bodyMd.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.responsiveFont(14),
          ),
          decoration: InputDecoration(
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
          ),
          items: widget.options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(14),
                ),
              ),
            );
          }).toList(),
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}
