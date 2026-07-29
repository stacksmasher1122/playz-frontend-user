import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class FaqCategoryChips extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  const FaqCategoryChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return SizedBox(
      height: context.heightPct(5.5).clamp(38.0, 46.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = cat == selectedCategory;
          return Padding(
            padding: EdgeInsets.only(right: context.widthPct(2)),
            child: ChoiceChip(
              label: Text(cat),
              selected: isSelected,
              selectedColor: AppColors.accent,
              backgroundColor: AppColors.card,
              labelStyle: AppTypography.bodySm.copyWith(
                color: isSelected ? AppColors.background : AppColors.muted,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: context.responsiveFont(13),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                side: BorderSide(
                  color: isSelected ? AppColors.accent : AppColors.borderDark,
                ),
              ),
              onSelected: (_) => onSelected(cat),
            ),
          );
        },
      ),
    );
  }
}
