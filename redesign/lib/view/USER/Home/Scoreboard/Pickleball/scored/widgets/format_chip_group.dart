import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'category_chip_group.dart'; // for MatchCustomChip

class FormatChipGroup extends StatelessWidget {
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelect;

  const FormatChipGroup({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Match Format", style: AppTypography.bodySm.copyWith(color: AppColors.muted)),
        const SizedBox(height: 8),
        RepaintBoundary(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((opt) => MatchCustomChip(
              label: opt,
              isSelected: opt == selected,
              onTap: () => onSelect(opt),
            )).toList(),
          ),
        ),
      ],
    );
  }
}
