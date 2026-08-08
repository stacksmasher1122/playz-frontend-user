import 'package:flutter/material.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Hockey/hockey_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Hockey/hockey_state_models.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Hockey/live_match/widgets/hockey_select_scorer_sheet.dart';

/// Modal bottom sheet for selecting Goal Type matching the attached design screenshot.
class HockeyGoalTypeSheet extends StatelessWidget {
  final HockeyController controller;
  final String team; // 'sideA' or 'sideB'
  final String teamName;

  const HockeyGoalTypeSheet({
    super.key,
    required this.controller,
    required this.team,
    required this.teamName,
  });

  static void show(
    BuildContext context,
    HockeyController controller,
    String team,
    String teamName,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF10141E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(24.0))),
      ),
      builder: (ctx) => HockeyGoalTypeSheet(
        controller: controller,
        team: team,
        teamName: teamName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final bool isTeamA = team == 'sideA';
    final Color teamAccentColor = isTeamA ? const Color(0xFF00E676) : const Color(0xFF448AFF);
    const Color borderDividerColor = Color(0xFF1D2638);
    const Color cardBgColor = Color(0xFF121724);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(20.0),
        vertical: ResponsiveHelper.h(14.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ─── 1. TOP DRAG HANDLE PILL ───
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

          // ─── 2. HEADER ROW (TARGET ICON + TITLE) ───
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveHelper.w(10.0)),
                decoration: BoxDecoration(
                  color: const Color(0xFF00E676).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF00E676).withValues(alpha: 0.4), width: 1.0),
                ),
                child: Icon(
                  Icons.my_location_rounded,
                  color: const Color(0xFF00E676),
                  size: ResponsiveHelper.w(22.0),
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(12.0)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Goal Type',
                      style: AppTypography.headlineSm.copyWith(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.sp(18.0),
                        fontWeight: FontWeight.w900,
                      ).responsive(context),
                    ),
                    SizedBox(height: ResponsiveHelper.h(2.0)),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Choose the type of goal for ',
                            style: AppTypography.bodySm.copyWith(
                              color: const Color(0xFF7E8B9B),
                              fontSize: ResponsiveHelper.sp(13.0),
                            ).responsive(context),
                          ),
                          TextSpan(
                            text: teamName,
                            style: AppTypography.bodySm.copyWith(
                              color: teamAccentColor,
                              fontSize: ResponsiveHelper.sp(13.0),
                              fontWeight: FontWeight.bold,
                            ).responsive(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: ResponsiveHelper.h(20.0)),

          // ─── 3. GOAL TYPE OPTIONS ───

          // Field Goal (FG)
          _buildGoalOptionTile(
            context,
            title: 'Field Goal (FG)',
            subtitle: 'Award a field goal',
            icon: Icons.sports_hockey,
            iconBgColor: const Color(0xFF193826),
            iconColor: const Color(0xFF00E676),
            onTap: () {
              Navigator.pop(context);
              HockeySelectScorerSheet.show(context, controller, team, teamName, GoalType.fieldGoal);
            },
          ),

          SizedBox(height: ResponsiveHelper.h(12.0)),

          // Penalty Corner (PC)
          _buildGoalOptionTile(
            context,
            title: 'Penalty Corner (PC)',
            subtitle: 'Award a penalty corner',
            icon: Icons.flag_outlined,
            iconBgColor: const Color(0xFF382B14),
            iconColor: const Color(0xFFFFC107),
            onTap: () {
              Navigator.pop(context);
              HockeySelectScorerSheet.show(context, controller, team, teamName, GoalType.penaltyCorner);
            },
          ),

          SizedBox(height: ResponsiveHelper.h(12.0)),

          // Penalty Stroke (PS)
          _buildGoalOptionTile(
            context,
            title: 'Penalty Stroke (PS)',
            subtitle: 'Award a penalty stroke',
            icon: Icons.sports_soccer_outlined,
            iconBgColor: const Color(0xFF142838),
            iconColor: const Color(0xFF448AFF),
            onTap: () {
              Navigator.pop(context);
              HockeySelectScorerSheet.show(context, controller, team, teamName, GoalType.penaltyStroke);
            },
          ),

          SizedBox(height: ResponsiveHelper.h(20.0)),

          // ─── 4. CANCEL BUTTON ───
          SizedBox(
            width: double.infinity,
            height: ResponsiveHelper.h(48.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: cardBgColor,
                foregroundColor: const Color(0xFF7E8B9B),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
                  side: const BorderSide(color: borderDividerColor, width: 1.2),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: AppTypography.headlineSm.copyWith(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(15.0),
                  fontWeight: FontWeight.w700,
                ).responsive(context),
              ),
            ),
          ),

          SizedBox(height: ResponsiveHelper.h(10.0)),
        ],
      ),
    );
  }

  Widget _buildGoalOptionTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
        child: Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(14.0)),
          decoration: BoxDecoration(
            color: const Color(0xFF121724),
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
            border: Border.all(
              color: const Color(0xFF1F2B3E),
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              // Icon Box
              Container(
                width: ResponsiveHelper.w(48.0),
                height: ResponsiveHelper.w(48.0),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(12.0)),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: ResponsiveHelper.w(22.0),
                  ),
                ),
              ),

              SizedBox(width: ResponsiveHelper.w(14.0)),

              // Title & Subtitle Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.headlineSm.copyWith(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.sp(15.5),
                        fontWeight: FontWeight.bold,
                      ).responsive(context),
                    ),
                    SizedBox(height: ResponsiveHelper.h(3.0)),
                    Text(
                      subtitle,
                      style: AppTypography.bodySm.copyWith(
                        color: const Color(0xFF7E8B9B),
                        fontSize: ResponsiveHelper.sp(12.5),
                      ).responsive(context),
                    ),
                  ],
                ),
              ),

              // Chevron Right
              Icon(
                Icons.chevron_right_rounded,
                color: const Color(0xFF7E8B9B),
                size: ResponsiveHelper.w(24.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
