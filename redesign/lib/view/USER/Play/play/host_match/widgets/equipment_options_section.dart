import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class EquipmentOptionsSection extends StatelessWidget {
  final String? selectedOption; // null, 'carry_own', 'provided'
  final ValueChanged<String?> onOptionSelected;

  const EquipmentOptionsSection({
    super.key,
    required this.selectedOption,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.sports_soccer_outlined, color: AppColors.accent, size: 18),
            SizedBox(width: context.widthPct(2)),
            Text(
              'Equipment Requirement Options',
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: context.responsiveFont(14),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        SizedBox(height: context.heightPct(1)),
        Row(
          children: [
            Expanded(
              child: _buildEquipmentChip(
                context: context,
                label: 'Carry Your Own',
                icon: Icons.backpack_outlined,
                isSelected: selectedOption == 'carry_own',
                onTap: () {
                  onOptionSelected(selectedOption == 'carry_own' ? null : 'carry_own');
                },
              ),
            ),
            SizedBox(width: context.widthPct(2.5)),
            Expanded(
              child: _buildEquipmentChip(
                context: context,
                label: 'Provided by Host',
                icon: Icons.inventory_2_outlined,
                isSelected: selectedOption == 'provided',
                onTap: () {
                  onOptionSelected(selectedOption == 'provided' ? null : 'provided');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEquipmentChip({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: context.widthPct(3),
          vertical: context.heightPct(1.5),
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent.withValues(alpha: 0.15) : AppColors.card,
          borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.borderDark,
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppColors.accent : AppColors.muted,
            ),
            SizedBox(width: context.widthPct(2)),
            Flexible(
              child: Text(
                label,
                style: AppTypography.bodySm.copyWith(
                  color: isSelected ? AppColors.accent : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: context.responsiveFont(12),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
