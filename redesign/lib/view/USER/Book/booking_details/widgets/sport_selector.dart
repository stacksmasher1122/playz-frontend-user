import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SportSelector extends StatelessWidget {
  final List<String> sports;
  final String? selectedSport;
  final ValueChanged<String> onSportSelected;

  const SportSelector({
    super.key,
    required this.sports,
    required this.selectedSport,
    required this.onSportSelected,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    if (sports.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
        child: Text(
          'No sports available',
          style: AppTypography.bodySm.copyWith(
            color: AppColors.muted,
            fontSize: context.responsiveFont(14),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      child: Wrap(
        spacing: context.widthPct(3),
        runSpacing: context.heightPct(1.2),
        children: sports.map((sport) {
          final bool isActive = selectedSport == sport;

          return _SportPill(
            label: sport,
            active: isActive,
            onTap: () => onSportSelected(sport),
          );
        }).toList(),
      ),
    );
  }
}

class _SportPill extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _SportPill({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return InkWell(
      borderRadius: BorderRadius.circular(context.minDimensionPct(8)),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(
          horizontal: context.widthPct(4.5),
          vertical: context.heightPct(1.2),
        ),
        decoration: BoxDecoration(
          color: active ? AppColors.accent.withValues(alpha: 0.15) : AppColors.card,
          borderRadius: BorderRadius.circular(context.minDimensionPct(8)),
          border: Border.all(
            color: active ? AppColors.accent : AppColors.borderDark,
            width: active ? 1.4 : 1,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.headlineSm.copyWith(
            color: active ? AppColors.accent : AppColors.textPrimary,
            fontSize: context.responsiveFont(14),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}
