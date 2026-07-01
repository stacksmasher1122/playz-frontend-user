import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:get/get.dart';

class MatchCategorySelector extends StatelessWidget {
  final RxString selectedCategory;
  final Function(String) onSelect;

  const MatchCategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('MATCH CATEGORY', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          const SizedBox(height: 16),
          Obx(() => Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildChip("MEN'S"),
              _buildChip("WOMEN'S"),
              _buildChip("MIXED"),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    bool isSelected = selectedCategory.value == label || selectedCategory.value.toUpperCase() == label.toUpperCase();
    return GestureDetector(
      onTap: () => onSelect(label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: isSelected ? AppColors.primaryContainer : AppColors.surfaceContainerHighest),
        ),
        child: Text(
          label,
          style: AppTypography.labelCaps10.copyWith(
            color: isSelected ? AppColors.onPrimaryContainer : AppColors.muted,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}
