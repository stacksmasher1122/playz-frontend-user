import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TtGamesCard extends StatelessWidget {
  final RxString selectedGamesFormat;
  final Function(String) onGamesFormatChanged;

  const TtGamesCard({
    super.key,
    required this.selectedGamesFormat,
    required this.onGamesFormatChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final formats = [
      {'label': 'Best of 1', 'value': 'BEST_OF_1'},
      {'label': 'Best of 3', 'value': 'BEST_OF_3'},
      {'label': 'Best of 5', 'value': 'BEST_OF_5'},
      {'label': 'Best of 7', 'value': 'BEST_OF_7'},
    ];

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
                  Icons.numbers_rounded,
                  color: AppColors.primaryGreen,
                  size: 20,
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(12)),
              Text(
                'GAMES TO WIN MATCH',
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
            () => GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.8,
              crossAxisSpacing: ResponsiveHelper.w(10),
              mainAxisSpacing: ResponsiveHelper.h(10),
              children: formats.map((item) {
                final isSelected = selectedGamesFormat.value == item['value'];
                return _buildGamesChip(
                  context,
                  label: item['label']!,
                  value: item['value']!,
                  isSelected: isSelected,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGamesChip(
    BuildContext context, {
    required String label,
    required String value,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onGamesFormatChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : AppColors.surface,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.borderDark,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.headlineSm.copyWith(
            color: isSelected ? Colors.black : AppColors.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: context.responsiveFont(13),
          ),
        ),
      ),
    );
  }
}
