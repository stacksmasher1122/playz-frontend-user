import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class EquipmentOptionsSection extends StatelessWidget {
  final String? selectedOption;
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
            const Icon(Icons.sports_tennis_rounded, color: AppColors.accent, size: 18),
            SizedBox(width: context.widthPct(2)),
            Text(
              'Equipment Options',
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: context.responsiveFont(14),
              ),
            ),
          ],
        ),
        SizedBox(height: context.heightPct(1)),
        Row(
          children: [
            Expanded(
              child: _EquipmentOptionCard(
                title: 'Carry your own equipment',
                icon: Icons.backpack_outlined,
                isSelected: selectedOption == 'carry_own',
                onTap: () {
                  if (selectedOption == 'carry_own') {
                    onOptionSelected(null);
                  } else {
                    onOptionSelected('carry_own');
                  }
                },
              ),
            ),
            SizedBox(width: context.widthPct(2.5)),
            Expanded(
              child: _EquipmentOptionCard(
                title: 'Equipment provided',
                icon: Icons.inventory_2_outlined,
                isSelected: selectedOption == 'provided',
                onTap: () {
                  if (selectedOption == 'provided') {
                    onOptionSelected(null);
                  } else {
                    onOptionSelected('provided');
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EquipmentOptionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _EquipmentOptionCard({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.all(context.widthPct(3)),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent.withValues(alpha: 0.15) : AppColors.card,
          borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.borderDark,
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.accent : AppColors.textSecondary,
              size: 20,
            ),
            SizedBox(width: context.widthPct(2)),
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodySm.copyWith(
                  color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: context.responsiveFont(11),
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.accent, size: 16),
          ],
        ),
      ),
    );
  }
}
