import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_dimensions.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LeaderboardSportFilter extends StatelessWidget {
  final String selectedSport;
  final ValueChanged<String> onSportChanged;

  const LeaderboardSportFilter({
    super.key,
    required this.selectedSport,
    required this.onSportChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final sports = const [
      'All Sports',
      'Football',
      'Cricket',
      'Badminton',
      'Tennis',
      'Basketball',
      'Volleyball',
      'Table Tennis',
      'Swimming',
      'Cycling',
      'Boxing',
      'Baseball',
      'Rugby',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      child: Row(
        children: sports.map((sport) {
          final isSelected = sport == selectedSport ||
              (selectedSport == 'All' && sport == 'All Sports');

          return Padding(
            padding: EdgeInsets.only(right: context.widthPct(2)),
            child: InkWell(
              onTap: () => onSportChanged(sport),
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: EdgeInsets.symmetric(
                  horizontal: context.widthPct(4),
                  vertical: context.heightPct(1),
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent : AppColors.card,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  border: Border.all(
                    color: isSelected ? AppColors.accent : AppColors.borderDark,
                    width: 1,
                  ),
                ),
                child: Text(
                  sport,
                  style: AppTypography.bodySm.copyWith(
                    color: isSelected ? AppColors.background : AppColors.textPrimary,
                    fontSize: context.responsiveFont(13),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
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
