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
    return Container(
      padding: EdgeInsets.only(
        top: ResponsiveHelper.h(16),
        bottom: ResponsiveHelper.h(32),
        left: ResponsiveHelper.w(16),
        right: ResponsiveHelper.w(16),
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
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
              width: ResponsiveHelper.w(120),
              height: ResponsiveHelper.h(48),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chevron_left, color: AppColors.onPrimary, size: ResponsiveHelper.w(20)),
                  SizedBox(width: ResponsiveHelper.w(8)),
                  Text(
                    "Back",
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.onPrimary,
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
              width: ResponsiveHelper.w(160),
              height: ResponsiveHelper.h(48),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.w(8)),
                  Icon(Icons.chevron_right, color: AppColors.background, size: ResponsiveHelper.w(20)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
