import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BottomActionBarWidget extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onSaveDraft;
  final VoidCallback onNext;

  const BottomActionBarWidget({
    super.key,
    required this.onBack,
    required this.onSaveDraft,
    required this.onNext,
  });

  
  @override
  State<BottomActionBarWidget> createState() => _BottomActionBarWidgetState();
}

class _BottomActionBarWidgetState extends State<BottomActionBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: ResponsiveHelper.h(16),
        bottom: ResponsiveHelper.h(32), // accounts for safe area usually
        left: ResponsiveHelper.w(16),
        right: ResponsiveHelper.w(16),
      ),
      color: AppColors.background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          GestureDetector(
            onTap: widget.onBack,
            child: Container(
              width: ResponsiveHelper.w(80),
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
                  SizedBox(width: ResponsiveHelper.w(4)),
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
          
          // Save Draft
          GestureDetector(
            onTap: widget.onSaveDraft,
            child: Text(
              "Save Draft",
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Next Button
          GestureDetector(
            onTap: widget.onNext,
            child: Container(
              width: ResponsiveHelper.w(100),
              height: ResponsiveHelper.h(48),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Next",
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.background, // Dark text on green background
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.w(4)),
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
