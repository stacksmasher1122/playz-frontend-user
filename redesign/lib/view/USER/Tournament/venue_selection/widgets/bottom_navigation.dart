import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BottomNavigation extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onNext;

  const BottomNavigation({
    super.key,
    required this.onBack,
    required this.onNext,
  });

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(4),
        vertical: context.heightPct(1.8),
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.background.withValues(alpha: 0.2),
            offset: const Offset(0, -4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          GestureDetector(
            onTap: widget.onBack,
            child: Container(
              width: context.widthPct(28).clamp(90.0, 120.0),
              height: context.heightPct(6).clamp(48.0, 56.0),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chevron_left_rounded,
                    color: AppColors.textPrimary,
                    size: context.responsiveFont(20),
                  ),
                  SizedBox(width: context.widthPct(1)),
                  Text(
                    "Back",
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: context.responsiveFont(14),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Next Button
          GestureDetector(
            onTap: widget.onNext,
            child: Container(
              width: context.widthPct(38).clamp(130.0, 160.0),
              height: context.heightPct(6).clamp(48.0, 56.0),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Next",
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.background,
                      fontSize: context.responsiveFont(14),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: context.widthPct(1)),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.background,
                    size: context.responsiveFont(20),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
