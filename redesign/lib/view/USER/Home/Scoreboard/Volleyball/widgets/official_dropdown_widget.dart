import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class OfficialDropdownWidget extends StatelessWidget {
  final String label;
  final String hint;
  final Function(String?) onChanged;

  OfficialDropdownWidget({
    super.key,
    required this.label,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surfaceContainerLowest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
              borderSide: BorderSide(color: AppColors.surfaceContainerHighest),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
              borderSide: BorderSide(color: AppColors.surfaceContainerHighest),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
              borderSide: BorderSide(color: AppColors.primaryContainer),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(16)),
          ),
          dropdownColor: AppColors.surfaceContainerHigh,
          icon: Icon(Icons.keyboard_arrow_down, color: AppColors.muted),
          hint: Text(hint, style: AppTypography.bodyMd.copyWith(color: AppColors.muted)),
          items: [
            DropdownMenuItem(value: 'Marcus Aurelius (International A)', child: Text('Marcus Aurelius (International A)')),
            DropdownMenuItem(value: 'Sarah Jenkins (Regional B)', child: Text('Sarah Jenkins (Regional B)')),
            DropdownMenuItem(value: 'David Chen (National A)', child: Text('David Chen (National A)')),
          ],
          onChanged: onChanged,
          style: AppTypography.bodyMd.copyWith(color: AppColors.primary),
        ),
      ],
    );
  }
}
