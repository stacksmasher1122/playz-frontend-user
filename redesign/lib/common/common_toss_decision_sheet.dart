import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

/// A reusable, app-themed Toss Decision bottom sheet where the toss-winning team
/// selects what they will do first (e.g. Bat / Bowl, Serve / Receive, Raid / Defend).
class CommonTossDecisionSheet extends StatelessWidget {
  final String winingTeamName;
  final String sport;
  final String? customOptionA;
  final String? customOptionB;
  final ValueChanged<String> onDecisionSelected;

  const CommonTossDecisionSheet({
    super.key,
    required this.winingTeamName,
    this.sport = 'cricket',
    this.customOptionA,
    this.customOptionB,
    required this.onDecisionSelected,
  });

  static Future<String?> show(
    BuildContext context, {
    required String winingTeamName,
    String sport = 'cricket',
    String? customOptionA,
    String? customOptionB,
    required ValueChanged<String> onDecisionSelected,
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
        child: CommonTossDecisionSheet(
          winingTeamName: winingTeamName,
          sport: sport,
          customOptionA: customOptionA,
          customOptionB: customOptionB,
          onDecisionSelected: (decision) {
            onDecisionSelected(decision);
            Navigator.of(ctx).pop(decision);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final options = _getSportOptions();
    final String optionA = customOptionA ?? options[0];
    final String optionB = customOptionB ?? options[1];

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

          // Subtitle Title
          Text(
            'TOSS WON BY',
            style: AppTypography.labelCaps.copyWith(
              color: AppColors.mutedText,
              fontSize: ResponsiveHelper.sp(13.0),
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ).responsive(context),
          ),
          SizedBox(height: ResponsiveHelper.h(6.0)),

          // Winner Team Name
          Text(
            winingTeamName,
            textAlign: TextAlign.center,
            style: AppTypography.displayScoreSora.copyWith(
              color: AppColors.accent,
              fontSize: ResponsiveHelper.sp(26.0),
              fontWeight: FontWeight.w800,
            ).responsive(context),
          ),
          SizedBox(height: ResponsiveHelper.h(8.0)),

          Text(
            'Decision:',
            style: AppTypography.headlineSm.copyWith(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(16.0),
              fontWeight: FontWeight.w700,
            ).responsive(context),
          ),
          SizedBox(height: ResponsiveHelper.h(20.0)),

          // Decision Action Buttons
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  label: optionA.toUpperCase(),
                  backgroundColor: AppColors.accent,
                  textColor: AppColors.background,
                  onPressed: () => onDecisionSelected(optionA.toLowerCase()),
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(16.0)),
              Expanded(
                child: _buildActionButton(
                  context,
                  label: optionB.toUpperCase(),
                  backgroundColor: AppColors.accent,
                  textColor: AppColors.background,
                  onPressed: () => onDecisionSelected(optionB.toLowerCase()),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(16.0)),
        ],
      ),
    );
  }

  List<String> _getSportOptions() {
    final s = sport.toLowerCase().trim();
    if (s == 'tennis' || s == 'volleyball' || s == 'badminton') {
      return ['SERVE', 'CHOOSE SIDE'];
    } else if (s == 'table_tennis' || s == 'squash') {
      return ['SERVE', 'RECEIVE'];
    } else if (s == 'hockey') {
      return ['FIRST CENTER', 'CHOOSE SIDE'];
    } else if (s == 'kho_kho' || s == 'khokho') {
      return ['CHASE', 'DEFEND'];
    } else if (s == 'football' || s == 'soccer' || s == 'basketball') {
      return ['KICKOFF', 'CHOOSE SIDE'];
    }
    // Default to Cricket
    return ['BAT', 'BOWL'];
  }

  Widget _buildActionButton(
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
