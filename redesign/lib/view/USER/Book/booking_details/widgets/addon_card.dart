import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class AddonCard extends StatelessWidget {
  final String title;
  final String price;
  final bool isSelected;
  final VoidCallback onTap;

  const AddonCard({
    super.key,
    required this.title,
    required this.price,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(4),
        vertical: context.heightPct(0.7),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor: AppColors.accent.withValues(alpha: 0.15),
          highlightColor: AppColors.accent.withValues(alpha: 0.08),
          child: Ink(
            padding: EdgeInsets.all(context.widthPct(4)),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
              border: Border.all(
                color: isSelected ? AppColors.accent : AppColors.borderDark,
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: context.responsiveFont(14),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  price,
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.accent,
                    fontSize: context.responsiveFont(14),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: context.widthPct(2)),
                Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: isSelected ? AppColors.accent : AppColors.muted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
