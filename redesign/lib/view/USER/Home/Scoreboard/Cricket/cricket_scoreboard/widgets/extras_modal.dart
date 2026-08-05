import 'package:flutter/material.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_state_models.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

/// A modern, app-themed bottom sheet for selecting and recording cricket Extras (Wide, No Ball, Bye, Leg Bye, Penalty).
class ExtrasModal extends StatefulWidget {
  final Function(ExtraType type, int additionalRuns) onSelect;

  const ExtrasModal({
    super.key,
    required this.onSelect,
  });

  @override
  State<ExtrasModal> createState() => _ExtrasModalState();
}

class _ExtrasModalState extends State<ExtrasModal> {
  ExtraType? selectedType;
  int additionalRuns = 0;

  String _formatExtraTitle(ExtraType type) {
    switch (type) {
      case ExtraType.wide:
        return 'WIDE (WD)';
      case ExtraType.noBall:
        return 'NO BALL (NB)';
      case ExtraType.bye:
        return 'BYE (B)';
      case ExtraType.legBye:
        return 'LEG BYE (LB)';
      case ExtraType.penalty:
        return 'PENALTY (PEN)';
    }
  }

  String _formatExtraSubtitle(ExtraType type) {
    switch (type) {
      case ExtraType.wide:
        return '+1 Run • Bowler re-bowls';
      case ExtraType.noBall:
        return '+1 Run • Free Hit Next Ball';
      case ExtraType.bye:
        return 'Runs without bat contact';
      case ExtraType.legBye:
        return 'Runs off body or pad';
      case ExtraType.penalty:
        return '+5 Penalty Runs';
    }
  }

  IconData _getExtraIcon(ExtraType type) {
    switch (type) {
      case ExtraType.wide:
        return Icons.straighten_rounded;
      case ExtraType.noBall:
        return Icons.block_rounded;
      case ExtraType.bye:
        return Icons.directions_run_rounded;
      case ExtraType.legBye:
        return Icons.accessibility_new_rounded;
      case ExtraType.penalty:
        return Icons.gavel_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(20.0),
        vertical: ResponsiveHelper.h(16.0),
      ),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveHelper.w(24.0)),
        ),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Drag Handle Pill
            Center(
              child: Container(
                width: ResponsiveHelper.w(44.0),
                height: ResponsiveHelper.h(4.5),
                margin: EdgeInsets.only(bottom: ResponsiveHelper.h(16.0)),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(10.0)),
                ),
              ),
            ),

            // Header Row
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveHelper.w(10.0)),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(12.0)),
                  ),
                  child: Icon(
                    Icons.electric_bolt_rounded,
                    color: AppColors.accent,
                    size: ResponsiveHelper.w(22.0),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(12.0)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RECORD EXTRAS',
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: ResponsiveHelper.sp(18.0),
                          fontWeight: FontWeight.bold,
                        ).responsive(context),
                      ),
                      SizedBox(height: ResponsiveHelper.h(2.0)),
                      Text(
                        'Select extra run category and additional runs scored.',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.mutedText,
                          fontSize: ResponsiveHelper.sp(12.0),
                        ).responsive(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.h(20.0)),

            // Extra Types List
            Column(
              children: ExtraType.values.map((t) {
                final isSel = selectedType == t;

                return Padding(
                  padding: EdgeInsets.only(bottom: ResponsiveHelper.h(8.0)),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => setState(() => selectedType = t),
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.w(16.0),
                          vertical: ResponsiveHelper.h(12.0),
                        ),
                        decoration: BoxDecoration(
                          color: isSel
                              ? AppColors.accent.withValues(alpha: 0.15)
                              : const Color(0xFF131313),
                          borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
                          border: Border.all(
                            color: isSel ? AppColors.accent : Colors.white.withValues(alpha: 0.08),
                            width: isSel ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _getExtraIcon(t),
                              color: isSel ? AppColors.accent : AppColors.mutedText,
                              size: ResponsiveHelper.w(20.0),
                            ),
                            SizedBox(width: ResponsiveHelper.w(12.0)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _formatExtraTitle(t),
                                    style: AppTypography.bodyMd.copyWith(
                                      color: isSel ? AppColors.accent : AppColors.textPrimary,
                                      fontSize: ResponsiveHelper.sp(14.0),
                                      fontWeight: isSel ? FontWeight.bold : FontWeight.w600,
                                    ).responsive(context),
                                  ),
                                  Text(
                                    _formatExtraSubtitle(t),
                                    style: AppTypography.bodySm.copyWith(
                                      color: AppColors.mutedText,
                                      fontSize: ResponsiveHelper.sp(11.0),
                                    ).responsive(context),
                                  ),
                                ],
                              ),
                            ),
                            if (isSel)
                              Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.accent,
                                size: ResponsiveHelper.w(20.0),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: ResponsiveHelper.h(16.0)),

            // Additional Runs Section
            Text(
              'ADDITIONAL BYE / BOUNDARY RUNS',
              style: AppTypography.labelCaps.copyWith(
                color: AppColors.mutedText,
                fontSize: ResponsiveHelper.sp(11.0),
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ).responsive(context),
            ),
            SizedBox(height: ResponsiveHelper.h(10.0)),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [0, 1, 2, 3, 4, 6].map((r) {
                  final isSel = additionalRuns == r;

                  return Padding(
                    padding: EdgeInsets.only(right: ResponsiveHelper.w(8.0)),
                    child: GestureDetector(
                      onTap: () => setState(() => additionalRuns = r),
                      child: Container(
                        width: ResponsiveHelper.w(46.0),
                        height: ResponsiveHelper.h(46.0),
                        decoration: BoxDecoration(
                          color: isSel ? AppColors.accent : const Color(0xFF131313),
                          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12.0)),
                          border: Border.all(
                            color: isSel ? AppColors.accent : Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '+$r',
                          style: AppTypography.headlineSm.copyWith(
                            color: isSel ? AppColors.background : AppColors.textPrimary,
                            fontSize: ResponsiveHelper.sp(15.0),
                            fontWeight: FontWeight.bold,
                          ).responsive(context),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(24.0)),

            // Confirm Action Button
            SizedBox(
              width: double.infinity,
              height: ResponsiveHelper.h(54.0),
              child: ElevatedButton(
                onPressed: selectedType != null
                    ? () {
                        widget.onSelect(selectedType!, additionalRuns);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.background,
                  disabledBackgroundColor: AppColors.accent.withValues(alpha: 0.3),
                  disabledForegroundColor: Colors.white38,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
                  ),
                ),
                child: Text(
                  'CONFIRM EXTRAS',
                  style: AppTypography.headlineSm.copyWith(
                    color: selectedType != null ? AppColors.background : Colors.white38,
                    fontSize: ResponsiveHelper.sp(16.0),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ).responsive(context),
                ),
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(10.0)),
          ],
        ),
      ),
    );
  }
}
