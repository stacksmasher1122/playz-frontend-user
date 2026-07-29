import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class FavoriteSportsSheet extends StatelessWidget {
  final List<String> allSports;
  final List<String> selectedSports;
  final ValueChanged<String> onToggle;

  const FavoriteSportsSheet({
    super.key,
    required this.allSports,
    required this.selectedSports,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(context.widthPct(6)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(context.minDimensionPct(6))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: context.widthPct(10),
              height: context.heightPct(0.5),
              decoration: BoxDecoration(
                color: AppColors.borderDark,
                borderRadius: BorderRadius.circular(context.minDimensionPct(1)),
              ),
            ),
          ),
          SizedBox(height: context.heightPct(2.5)),
          Row(
            children: [
              const Icon(Icons.sports_soccer, color: AppColors.accent, size: 24),
              SizedBox(width: context.widthPct(2.5)),
              Expanded(
                child: Text(
                  'Customize Favorite Sports',
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(18),
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: context.heightPct(0.8)),
          Text(
            'Select sports to customize your home feed and match recommendations.',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.muted,
              fontSize: context.responsiveFont(13),
            ),
          ),
          SizedBox(height: context.heightPct(2.5)),
          Wrap(
            spacing: context.widthPct(2.5),
            runSpacing: context.heightPct(1.2),
            children: allSports.map((sport) {
              final isSelected = selectedSports.contains(sport);
              return StatefulBuilder(
                builder: (context, setState) {
                  return ChoiceChip(
                    label: Text(sport),
                    selected: isSelected,
                    selectedColor: AppColors.accent,
                    backgroundColor: AppColors.textPrimary.withValues(alpha: 0.06),
                    labelStyle: AppTypography.bodySm.copyWith(
                      color: isSelected ? AppColors.background : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: context.responsiveFont(13),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                      side: BorderSide(
                        color: isSelected ? AppColors.accent : Colors.transparent,
                      ),
                    ),
                    onSelected: (_) {
                      onToggle(sport);
                      (context as Element).markNeedsBuild();
                    },
                  );
                },
              );
            }).toList(),
          ),
          SizedBox(height: context.heightPct(3)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.background,
                padding: EdgeInsets.symmetric(vertical: context.heightPct(1.8)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Done',
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.background,
                    fontWeight: FontWeight.bold,
                    fontSize: context.responsiveFont(15),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
