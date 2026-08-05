import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SquashGamesCard extends StatelessWidget {
  final RxInt gamesToWin;
  final Function(int) onGamesToWinChanged;

  const SquashGamesCard({
    super.key,
    required this.gamesToWin,
    required this.onGamesToWinChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: AppColors.borderDark, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MATCH LENGTH (GAMES TO WIN)',
            style: AppTypography.labelCaps.copyWith(
              color: AppColors.mutedText,
              fontSize: context.responsiveFont(11),
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(12)),
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: _buildGameOption(
                    context: context,
                    label: 'Best of 3',
                    subtitle: 'First to 2',
                    value: 2,
                    isSelected: gamesToWin.value == 2,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(8)),
                Expanded(
                  child: _buildGameOption(
                    context: context,
                    label: 'Best of 5',
                    subtitle: 'First to 3',
                    value: 3,
                    isSelected: gamesToWin.value == 3,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(8)),
                Expanded(
                  child: _buildGameOption(
                    context: context,
                    label: '1 Game',
                    subtitle: 'Single Game',
                    value: 1,
                    isSelected: gamesToWin.value == 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameOption({
    required BuildContext context,
    required String label,
    required String subtitle,
    required int value,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onGamesToWinChanged(value),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveHelper.h(12),
          horizontal: ResponsiveHelper.w(8),
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGreen.withValues(alpha: 0.15)
              : AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.borderDark,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: AppTypography.bodyMd.copyWith(
                color: isSelected ? AppColors.primaryGreen : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                fontSize: context.responsiveFont(13),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ResponsiveHelper.h(4)),
            Text(
              subtitle,
              style: AppTypography.bodyXs.copyWith(
                color: isSelected ? AppColors.primaryGreen.withValues(alpha: 0.8) : AppColors.mutedText,
                fontSize: context.responsiveFont(10),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
