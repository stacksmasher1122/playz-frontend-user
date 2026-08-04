import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TtFormatCard extends StatelessWidget {
  final RxString selectedFormat;
  final Function(String) onFormatChanged;

  const TtFormatCard({
    super.key,
    required this.selectedFormat,
    required this.onFormatChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
        border: Border.all(color: AppColors.borderDark, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveHelper.w(8)),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
                ),
                child: const Icon(
                  Icons.sports_tennis_rounded,
                  color: AppColors.primaryGreen,
                  size: 20,
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(12)),
              Text(
                'MATCH FORMAT',
                style: AppTypography.labelCaps.copyWith(
                  color: AppColors.mutedText,
                  fontSize: context.responsiveFont(11),
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(14)),
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: _buildFormatButton(
                    context,
                    label: 'SINGLES (1v1)',
                    value: 'SINGLES',
                    isSelected: selectedFormat.value == 'SINGLES',
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(12)),
                Expanded(
                  child: _buildFormatButton(
                    context,
                    label: 'DOUBLES (2v2)',
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

  Widget _buildFormatButton(
    BuildContext context, {
    required String label,
    required String value,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onFormatChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveHelper.h(12),
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGreen
              : AppColors.surface,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.borderDark,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTypography.headlineSm.copyWith(
              color: isSelected ? Colors.black : AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: context.responsiveFont(13),
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
