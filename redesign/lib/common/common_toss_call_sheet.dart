import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

/// A reusable, app-themed Toss Call bottom sheet (Heads / Tails selection).
class CommonTossCallSheet extends StatelessWidget {
  final String callerTeamName;
  final ValueChanged<String> onCallSelected;

  const CommonTossCallSheet({
    super.key,
    required this.callerTeamName,
    required this.onCallSelected,
  });

  static Future<String?> show(
    BuildContext context, {
    required String callerTeamName,
    required ValueChanged<String> onCallSelected,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: AppColors.cardSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveHelper.w(24.0)),
        ),
      ),
      builder: (ctx) => PopScope(
        canPop: false,
        child: CommonTossCallSheet(
          callerTeamName: callerTeamName,
          onCallSelected: (choice) {
            onCallSelected(choice);
            Navigator.of(ctx).pop(choice);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(24.0),
        vertical: ResponsiveHelper.h(16.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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

          // Header Text
          Text(
            'TOSS TIME',
            style: AppTypography.labelCaps.copyWith(
              color: AppColors.mutedText,
              fontSize: ResponsiveHelper.sp(13.0),
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ).responsive(context),
          ),
          SizedBox(height: ResponsiveHelper.h(6.0)),
          Text(
            "$callerTeamName's Call",
            textAlign: TextAlign.center,
            style: AppTypography.headlineLg.copyWith(
              color: AppColors.textPrimary,
              fontSize: ResponsiveHelper.sp(24.0),
              fontWeight: FontWeight.bold,
            ).responsive(context),
          ),
          SizedBox(height: ResponsiveHelper.h(24.0)),

          // Choice Action Buttons (HEADS / TAILS)
          Row(
            children: [
              Expanded(
                child: _buildChoiceButton(
                  context,
                  label: 'HEADS',
                  backgroundColor: AppColors.accent,
                  textColor: AppColors.background,
                  onPressed: () => onCallSelected('HEADS'),
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(16.0)),
              Expanded(
                child: _buildChoiceButton(
                  context,
                  label: 'TAILS',
                  backgroundColor: AppColors.accent,
                  textColor: AppColors.background,
                  onPressed: () => onCallSelected('TAILS'),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(16.0)),
        ],
      ),
    );
  }

  Widget _buildChoiceButton(
    BuildContext context, {
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16.0)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: AppTypography.headlineSm.copyWith(
          color: textColor,
          fontSize: ResponsiveHelper.sp(18.0),
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ).responsive(context),
      ),
    );
  }
}
