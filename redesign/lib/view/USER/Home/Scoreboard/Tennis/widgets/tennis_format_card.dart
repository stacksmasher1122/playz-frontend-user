import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TennisFormatCard extends StatelessWidget {
  final RxString selectedFormat;
  final Function(String) onFormatChanged;

  const TennisFormatCard({
    super.key,
    required this.selectedFormat,
    required this.onFormatChanged,
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
                  Icons.sports_tennis,
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
                      'MATCH FORMAT',
                      style: AppTypography.labelCaps.copyWith(
                        color: AppColors.primaryGreen,
                        fontSize: context.responsiveFont(12),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.h(4)),
                    Text(
                      'Singles or Doubles',
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
                    label: 'Singles (1v1)',
                    value: 'SINGLES',
                    isSelected: selectedFormat.value == 'SINGLES',
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(12)),
                Expanded(
                  child: _buildOptionButton(
                    context: context,
                    label: 'Doubles (2v2)',
                    value: 'DOUBLES',
                    isSelected: selectedFormat.value == 'DOUBLES',
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
      onTap: () => onFormatChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveHelper.h(14),
          horizontal: ResponsiveHelper.w(8),
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
              style: AppTypography.bodyMd.copyWith(
                color: isSelected ? AppColors.primaryGreen : AppColors.mutedText,
                fontSize: context.responsiveFont(14),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
