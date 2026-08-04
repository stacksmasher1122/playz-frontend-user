import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TennisSetsCard extends StatelessWidget {
  final RxString selectedSetsFormat;
  final Function(String) onSetsFormatChanged;

  const TennisSetsCard({
    super.key,
    required this.selectedSetsFormat,
    required this.onSetsFormatChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveHelper.w(12)),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
                ),
                child: const Icon(
                  Icons.format_list_numbered_rounded,
                  color: AppColors.primaryGreen,
                  size: 24,
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SETS FORMAT',
                      style: AppTypography.labelCaps.copyWith(
                        color: AppColors.primaryGreen,
                        fontSize: context.responsiveFont(12),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.h(4)),
                    Text(
                      'Number of Sets to Play',
                      style: AppTypography.headlineMd.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: context.responsiveFont(16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(16)),
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: _buildOptionButton(
                    context: context,
                    label: 'Best of 1',
                    value: 'BEST_OF_1',
                    isSelected: selectedSetsFormat.value == 'BEST_OF_1',
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(8)),
                Expanded(
                  child: _buildOptionButton(
                    context: context,
                    label: 'Best of 3',
                    value: 'BEST_OF_3',
                    isSelected: selectedSetsFormat.value == 'BEST_OF_3',
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(8)),
                Expanded(
                  child: _buildOptionButton(
                    context: context,
                    label: 'Best of 5',
                    value: 'BEST_OF_5',
                    isSelected: selectedSetsFormat.value == 'BEST_OF_5',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton({
    required BuildContext context,
    required String label,
    required String value,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onSetsFormatChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveHelper.h(14),
          horizontal: ResponsiveHelper.w(6),
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGreen.withValues(alpha: 0.15)
              : AppColors.cardSurface,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: AppTypography.bodySm.copyWith(
                color: isSelected ? AppColors.primaryGreen : AppColors.mutedText,
                fontSize: context.responsiveFont(13),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
