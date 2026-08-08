import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

/// Reusable match configuration card for racquet & court sports (Tennis, Table Tennis, Badminton, etc.)
/// Styled using standard AppColors matching ProRulesSwitchCard.
class CommonMatchModeSetsCard extends StatelessWidget {
  final String title;
  final String format; // 'SINGLES' or 'DOUBLES'
  final String setsFormat; // 'BEST_OF_1', 'BEST_OF_3', 'BEST_OF_5'
  final ValueChanged<String> onFormatChanged;
  final ValueChanged<String> onSetsFormatChanged;
  final List<String> availableSets;

  const CommonMatchModeSetsCard({
    super.key,
    this.title = 'MATCH MODE & SETS',
    required this.format,
    required this.setsFormat,
    required this.onFormatChanged,
    required this.onSetsFormatChanged,
    this.availableSets = const ['BEST_OF_1', 'BEST_OF_3', 'BEST_OF_5'],
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(20.0),
        vertical: ResponsiveHelper.h(18.0),
      ),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20.0)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── TITLE HEADER (WITHOUT LOGO) ───
          Text(
            title.toUpperCase(),
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.textPrimary,
              fontSize: ResponsiveHelper.sp(14.0),
              fontWeight: FontWeight.bold,
            ).responsive(context),
          ),

          SizedBox(height: ResponsiveHelper.h(18.0)),

          // ─── 1. SINGLES / DOUBLES TOGGLE ───
          Text(
            'MATCH MODE',
            style: AppTypography.labelCaps.copyWith(
              color: AppColors.mutedText,
              fontSize: ResponsiveHelper.sp(11.0),
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ).responsive(context),
          ),
          SizedBox(height: ResponsiveHelper.h(8.0)),
          Row(
            children: [
              Expanded(
                child: _buildModeOptionTile(
                  context,
                  label: 'SINGLES (1v1)',
                  isSelected: format == 'SINGLES',
                  onTap: () => onFormatChanged('SINGLES'),
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(10.0)),
              Expanded(
                child: _buildModeOptionTile(
                  context,
                  label: 'DOUBLES (2v2)',
                  isSelected: format == 'DOUBLES',
                  onTap: () => onFormatChanged('DOUBLES'),
                ),
              ),
            ],
          ),

          SizedBox(height: ResponsiveHelper.h(16.0)),

          // ─── 2. BEST OF SETS DYNAMIC SELECTOR ───
          Text(
            'MATCH LENGTH (BEST OF SETS)',
            style: AppTypography.labelCaps.copyWith(
              color: AppColors.mutedText,
              fontSize: ResponsiveHelper.sp(11.0),
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ).responsive(context),
          ),
          SizedBox(height: ResponsiveHelper.h(8.0)),
          Row(
            children: availableSets.map((setCode) {
              final isSelected = setsFormat == setCode;
              final displayLabel = setCode
                  .replaceAll('BEST_OF_', 'Best of ')
                  .replaceAll('_', ' ');

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(3.0)),
                  child: _buildModeOptionTile(
                    context,
                    label: displayLabel,
                    isSelected: isSelected,
                    onTap: () => onSetsFormatChanged(setCode),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildModeOptionTile(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12.0)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveHelper.h(12.0),
            horizontal: ResponsiveHelper.w(6.0),
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.accent
                : const Color(0xFF141414),
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(12.0)),
            border: Border.all(
              color: isSelected ? AppColors.accent : Colors.white.withValues(alpha: 0.05),
              width: 1.0,
            ),
          ),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTypography.bodySm.copyWith(
                color: isSelected ? Colors.black : AppColors.textSecondary,
                fontSize: ResponsiveHelper.sp(12.0),
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
              ).responsive(context),
            ),
          ),
        ),
      ),
    );
  }
}
