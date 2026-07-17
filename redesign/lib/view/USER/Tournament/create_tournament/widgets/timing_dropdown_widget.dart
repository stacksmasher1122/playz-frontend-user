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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Preferred Match Timings",
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(8)),
        DropdownButtonFormField<String>(
          initialValue: widget.selectedValue,
          icon: Icon(Icons.keyboard_arrow_down, color: AppColors.muted, size: ResponsiveHelper.w(24)),
          dropdownColor: AppColors.card,
          style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary),
          decoration: InputDecoration(
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
          items: widget.options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}
