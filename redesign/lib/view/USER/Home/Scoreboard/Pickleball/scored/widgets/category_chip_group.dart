import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CategoryChipGroup extends StatelessWidget {
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelect;

  CategoryChipGroup({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Match Category", style: AppTypography.bodySm.copyWith(color: AppColors.muted)),
        SizedBox(height: 8),
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

class MatchCustomChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  MatchCustomChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(10)),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : AppColors.card,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
        ),
        child: Text(
          label,
          style: AppTypography.bodyMd.copyWith(
            color: isSelected ? Colors.black : AppColors.accent,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
