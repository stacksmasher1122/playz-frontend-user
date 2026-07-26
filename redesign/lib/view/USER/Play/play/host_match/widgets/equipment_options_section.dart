import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.sports_tennis_rounded, color: AppColors.accent, size: 18),
            const SizedBox(width: 8),
            Text(
              'Equipment Options',
              style: GoogleFonts.inter(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveHelper.sp(14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
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
            const SizedBox(width: 10),
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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent.withValues(alpha: 0.15) : AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.accent : Colors.white12,
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.accent : Colors.white54,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: ResponsiveHelper.sp(11),
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
