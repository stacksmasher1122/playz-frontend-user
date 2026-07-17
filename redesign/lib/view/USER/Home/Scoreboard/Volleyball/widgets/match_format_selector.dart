import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchFormatSelector extends StatelessWidget {
  final RxString selectedFormat;
  final Function(String) onSelect;

  MatchFormatSelector({
    super.key,
    required this.selectedFormat,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(24)),
      decoration: BoxDecoration(
        color: AppColors.card.withOpacity(0.8),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('MATCH FORMAT', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          SizedBox(height: 16),
          Obx(() => Row(
            children: [
              Expanded(child: _buildFormatCard('B3', 'BEST OF 3')),
              SizedBox(width: 12),
              Expanded(child: _buildFormatCard('B5', 'BEST OF 5')),
              SizedBox(width: 12),
              Expanded(child: _buildFormatCard('C', 'CUSTOM')),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildFormatCard(String id, String label) {
    bool isSelected = selectedFormat.value == id;
    return GestureDetector(
      onTap: () => onSelect(id),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(20)),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
          border: Border.all(color: isSelected ? AppColors.accent : AppColors.outlineVariant),
        ),
        child: Column(
          children: [
            Text(
              id,
              style: AppTypography.headlineMd.copyWith(
                color: isSelected ? AppColors.background : AppColors.accent,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.labelCaps10.copyWith(
                color: isSelected ? AppColors.background.withOpacity(0.7) : AppColors.muted,
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveHelper.sp(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
