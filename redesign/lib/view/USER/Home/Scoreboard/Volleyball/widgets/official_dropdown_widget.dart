import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';

class OfficialDropdownWidget extends StatelessWidget {
  final String label;
  final String hint;
  final Function(String?) onChanged;

  const OfficialDropdownWidget({
    super.key,
    required this.label,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surfaceContainerLowest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.surfaceContainerHighest),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.surfaceContainerHighest),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryContainer),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          dropdownColor: AppColors.surfaceContainerHigh,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.muted),
          hint: Text(hint, style: AppTypography.bodyMd.copyWith(color: AppColors.muted)),
          items: const [
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
