import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:get/get.dart';

class MatchFormatSelector extends StatelessWidget {
  final RxString selectedFormat;
  final Function(String) onSelect;

  const MatchFormatSelector({
    super.key,
    required this.selectedFormat,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('MATCH FORMAT', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          const SizedBox(height: 16),
          Obx(() => Row(
            children: [
              Expanded(child: _buildFormatCard('B3', 'BEST OF 3')),
              const SizedBox(width: 12),
              Expanded(child: _buildFormatCard('B5', 'BEST OF 5')),
              const SizedBox(width: 12),
              Expanded(child: _buildFormatCard('C', 'CUSTOM')),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildFormatCard(String id, String label) {
    bool isSelected = selectedFormat.value == id;
    return GestureDetector(
      onTap: () => onSelect(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.primaryContainer : AppColors.surfaceContainerHighest),
        ),
        child: Column(
          children: [
            Text(
              id,
              style: AppTypography.headlineMd.copyWith(
                color: isSelected ? AppColors.onPrimaryContainer : AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.labelCaps10.copyWith(
                color: isSelected ? AppColors.onPrimaryContainer.withOpacity(0.7) : AppColors.muted,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
