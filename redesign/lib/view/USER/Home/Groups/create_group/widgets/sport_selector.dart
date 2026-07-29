import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SportSelector extends StatelessWidget {
  final List<String> sports;
  final String selectedSport;
  final Function(String) onSportSelected;

  const SportSelector({
    super.key,
    required this.sports,
    required this.selectedSport,
    required this.onSportSelected,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: sports.map((sport) {
          final isSelected = selectedSport == sport;
          return Padding(
            padding: EdgeInsets.only(right: context.widthPct(3)),
            child: InkWell(
              onTap: () => onSportSelected(sport),
              borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.widthPct(4.5),
                  vertical: context.heightPct(1.2),
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent.withValues(alpha: 0.15) : AppColors.surface,
                  borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                  border: Border.all(
                    color: isSelected ? AppColors.accent : AppColors.borderDark,
                    width: 1,
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    sport,
                    style: AppTypography.bodySm.copyWith(
                      color: isSelected ? AppColors.accent : AppColors.muted,
                      fontSize: context.responsiveFont(13),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
