import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SquashFormatCard extends StatelessWidget {
  final RxString selectedFormat;
  final Function(String) onFormatChanged;

  const SquashFormatCard({
    super.key,
    required this.selectedFormat,
    required this.onFormatChanged,
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
            'MATCH FORMAT',
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
                  child: _buildFormatOption(
                    context: context,
                    title: 'Singles (1v1)',
                    icon: Icons.person_rounded,
                    isSelected: selectedFormat.value == 'Singles',
                    onTap: () => onFormatChanged('Singles'),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(12)),
                Expanded(
                  child: _buildFormatOption(
                    context: context,
                    title: 'Doubles (2v2)',
                    icon: Icons.people_rounded,
                    isSelected: selectedFormat.value == 'Doubles',
                    onTap: () => onFormatChanged('Doubles'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatOption({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveHelper.h(14),
          horizontal: ResponsiveHelper.w(12),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? AppColors.primaryGreen : AppColors.mutedText,
            ),
            SizedBox(width: ResponsiveHelper.w(8)),
            Flexible(
              child: Text(
                title,
                style: AppTypography.bodyMd.copyWith(
                  color: isSelected ? AppColors.primaryGreen : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: context.responsiveFont(13),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
