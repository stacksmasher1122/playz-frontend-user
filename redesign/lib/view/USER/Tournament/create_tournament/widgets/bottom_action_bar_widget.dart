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
    ResponsiveHelper.init(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(4),
        vertical: context.heightPct(1.8),
      ),
      color: AppColors.background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          GestureDetector(
            onTap: widget.onBack,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.widthPct(3.5),
                vertical: context.heightPct(1.2),
              ),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
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
          
          // Save Draft
          GestureDetector(
            onTap: widget.onSaveDraft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.widthPct(2)),
              child: Text(
                "Save Draft",
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.accent,
                  fontSize: context.responsiveFont(14),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          // Next Button
          GestureDetector(
            onTap: widget.onNext,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.widthPct(4.5),
                vertical: context.heightPct(1.2),
              ),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(context.minDimensionPct(7)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
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
