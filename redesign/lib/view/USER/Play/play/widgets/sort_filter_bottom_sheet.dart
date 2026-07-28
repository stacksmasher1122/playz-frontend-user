import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Match_Controller/match_controller.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SortFilterBottomSheet extends StatelessWidget {
  const SortFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final matchCtrl = Get.find<MatchController>();
    final buttonHeight = context.heightPct(6).clamp(44.0, 52.0);

    return Container(
      padding: EdgeInsets.all(context.widthPct(5)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.minDimensionPct(6)),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HANDLE & HEADER
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.muted.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: context.heightPct(1.8)),

            Row(
              children: [
                Expanded(
                  child: Text(
                    'Sort & Filter Matches',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.headlineLgMobile.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: context.responsiveFont(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(color: AppColors.divider),
            SizedBox(height: context.heightPct(1.2)),

            /// SORT BY OPTIONS
            Text(
              'Sort By',
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.accent,
                fontSize: context.responsiveFont(14),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: context.heightPct(1)),

            Obx(() {
              final selected = matchCtrl.sortOption.value;

              return Wrap(
                spacing: context.widthPct(2),
                runSpacing: context.heightPct(1),
                children: [
                  _SortChip(
                    label: 'Time: Earliest First',
                    isSelected: selected == MatchSortOption.timeAsc,
                    onTap: () => matchCtrl.sortOption.value = MatchSortOption.timeAsc,
                  ),
                  _SortChip(
                    label: 'Time: Latest First',
                    isSelected: selected == MatchSortOption.timeDesc,
                    onTap: () => matchCtrl.sortOption.value = MatchSortOption.timeDesc,
                  ),
                  _SortChip(
                    label: 'Distance: Closest First',
                    isSelected: selected == MatchSortOption.distanceAsc,
                    onTap: () => matchCtrl.sortOption.value = MatchSortOption.distanceAsc,
                  ),
                  _SortChip(
                    label: 'Distance: Farthest First',
                    isSelected: selected == MatchSortOption.distanceDesc,
                    onTap: () => matchCtrl.sortOption.value = MatchSortOption.distanceDesc,
                  ),
                  _SortChip(
                    label: 'Price: Lowest First',
                    isSelected: selected == MatchSortOption.priceAsc,
                    onTap: () => matchCtrl.sortOption.value = MatchSortOption.priceAsc,
                  ),
                  _SortChip(
                    label: 'Price: Highest First',
                    isSelected: selected == MatchSortOption.priceDesc,
                    onTap: () => matchCtrl.sortOption.value = MatchSortOption.priceDesc,
                  ),
                ],
              );
            }),

            SizedBox(height: context.heightPct(2.5)),

            /// DISTANCE RADIUS SLIDER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Search Radius',
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.accent,
                    fontSize: context.responsiveFont(14),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(() => Text(
                      '${matchCtrl.distanceRadiusKm.value.toInt()} km',
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: context.responsiveFont(14),
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ],
            ),
            SizedBox(height: context.heightPct(0.5)),

            Obx(() {
              return SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: AppColors.accent,
                  inactiveTrackColor: AppColors.borderDark,
                  thumbColor: AppColors.accent,
                  overlayColor: AppColors.accent.withValues(alpha: 0.2),
                  valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                  valueIndicatorColor: AppColors.accent,
                  valueIndicatorTextStyle: const TextStyle(color: AppColors.background, fontWeight: FontWeight.bold),
                ),
                child: Slider(
                  value: matchCtrl.distanceRadiusKm.value,
                  min: 1.0,
                  max: 50.0,
                  divisions: 49,
                  label: '${matchCtrl.distanceRadiusKm.value.toInt()} km',
                  onChanged: (val) {
                    matchCtrl.distanceRadiusKm.value = val;
                  },
                ),
              );
            }),
            Text(
              'Showing matches within ${matchCtrl.distanceRadiusKm.value.toInt()} km around your location',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodyXs.copyWith(
                color: AppColors.textSecondary,
                fontSize: context.responsiveFont(11.5),
              ),
            ),

            SizedBox(height: context.heightPct(2.5)),

            /// APPLY BUTTON
            SizedBox(
              width: double.infinity,
              height: buttonHeight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Apply Filters',
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
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: context.widthPct(3.5),
          vertical: context.heightPct(1),
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.borderDark,
          ),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.bodySm.copyWith(
            color: isSelected ? AppColors.background : AppColors.textSecondary,
            fontSize: context.responsiveFont(12),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
