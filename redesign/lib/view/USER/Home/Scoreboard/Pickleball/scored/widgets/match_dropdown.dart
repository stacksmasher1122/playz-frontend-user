import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchDropdown extends StatelessWidget {
  final String label;
  final String hint;
  final String value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  MatchDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.bodySm.copyWith(color: AppColors.muted)),
        SizedBox(height: 6),
        Container(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value.isEmpty ? null : value,
              hint: Text(hint, style: AppTypography.bodyMd.copyWith(color: AppColors.outlineVariant)),
              icon: Icon(Icons.keyboard_arrow_down, color: AppColors.muted),
              dropdownColor: AppColors.card,
              style: AppTypography.bodyMd.copyWith(color: AppColors.accent),
              items: options.map((String opt) {
                return DropdownMenuItem<String>(
                  value: opt,
                  child: Text(opt),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
