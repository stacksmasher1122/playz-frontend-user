import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SportsSelectionBottom extends StatelessWidget {
  final int selectedCount;
  final bool canProceed;
  final VoidCallback onNext;

  const SportsSelectionBottom({
    super.key,
    required this.selectedCount,
    required this.canProceed,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      padding: EdgeInsets.fromLTRB(
        context.widthPct(5),
        context.heightPct(2),
        context.widthPct(5),
        context.heightPct(4),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            AppColors.background,
            AppColors.background.withValues(alpha: 0.0),
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            '$selectedCount of 4 sports selected',
            style: AppTypography.bodySm.copyWith(
              color: canProceed ? AppColors.textPrimary : AppColors.muted,
              fontSize: context.responsiveFont(13),
            ),
          ),
          SizedBox(height: context.heightPct(2)),
          SizedBox(
            width: double.infinity,
            height: context.heightPct(6).clamp(48.0, 56.0),
            child: ElevatedButton(
              onPressed: canProceed ? onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canProceed ? AppColors.accent : AppColors.surfaceElevated,
                disabledBackgroundColor: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.minDimensionPct(7)),
                ),
                elevation: 0,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Next',
                  style: AppTypography.labelCaps10.copyWith(
                    fontSize: context.responsiveFont(16),
                    fontWeight: FontWeight.w700,
                    color: canProceed ? AppColors.background : AppColors.muted,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
