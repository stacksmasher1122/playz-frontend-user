import 'package:flutter/material.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Hockey/hockey_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Hockey/hockey_state_models.dart';

/// Modal bottom sheet for assigning the goal scorer matching the design aesthetic.
class HockeySelectScorerSheet extends StatelessWidget {
  final HockeyController controller;
  final String team; // 'sideA' or 'sideB'
  final String teamName;
  final GoalType goalType;

  const HockeySelectScorerSheet({
    super.key,
    required this.controller,
    required this.team,
    required this.teamName,
    required this.goalType,
  });

  static void show(
    BuildContext context,
    HockeyController controller,
    String team,
    String teamName,
    GoalType goalType,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF10141E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(24.0))),
      ),
      builder: (ctx) => HockeySelectScorerSheet(
        controller: controller,
        team: team,
        teamName: teamName,
        goalType: goalType,
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

    final state = controller.liveState.value;
    final players = isTeamA ? (state?.teamA ?? []) : (state?.teamB ?? []);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
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

          // ─── 2. HEADER ROW (JERSEY ICON + TITLE) ───
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveHelper.w(10.0)),
                decoration: BoxDecoration(
                  color: teamAccentColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: teamAccentColor.withValues(alpha: 0.4), width: 1.0),
                ),
                child: Icon(
                  Icons.checkroom_rounded,
                  color: teamAccentColor,
                  size: ResponsiveHelper.w(22.0),
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(12.0)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Goal Scorer',
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
                            text: 'Who scored the goal for ',
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

          SizedBox(height: ResponsiveHelper.h(16.0)),

          Container(
            width: double.infinity,
            height: 1.0,
            color: borderDividerColor,
          ),

          SizedBox(height: ResponsiveHelper.h(12.0)),

          // ─── 3. PLAYERS LIST ───
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Unassigned / Team Goal Tile
                  _buildPlayerTile(
                    context,
                    playerName: 'Unassigned Goal',
                    subtitle: 'Record goal without specific player',
                    accentColor: const Color(0xFFFFC107),
                    icon: Icons.sports_soccer_outlined,
                    onTap: () {
                      Navigator.pop(context);
                      controller.scoreGoal(team, scorerName: 'Team Goal', goalType: goalType);
                    },
                  ),

                  SizedBox(height: ResponsiveHelper.h(10.0)),

                  // Roster Player Tiles
                  if (players.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(20.0)),
                      child: Text(
                        'No players registered in roster',
                        style: AppTypography.bodySm.copyWith(
                          color: const Color(0xFF7E8B9B),
                          fontSize: ResponsiveHelper.sp(13.0),
                        ).responsive(context),
                      ),
                    )
                  else
                    ...players.map(
                      (player) => Padding(
                        padding: EdgeInsets.only(bottom: ResponsiveHelper.h(10.0)),
                        child: _buildPlayerTile(
                          context,
                          playerName: player.name.isNotEmpty ? player.name : player.id,
                          subtitle: 'Goals this match: ${player.goals}',
                          accentColor: teamAccentColor,
                          icon: Icons.person_outline_rounded,
                          onTap: () {
                            Navigator.pop(context);
                            controller.scoreGoal(
                              team,
                              scorerName: player.name.isNotEmpty ? player.name : player.id,
                              goalType: goalType,
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          SizedBox(height: ResponsiveHelper.h(16.0)),

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

  Widget _buildPlayerTile(
    BuildContext context, {
    required String playerName,
    required String subtitle,
    required Color accentColor,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
        child: Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(12.0)),
          decoration: BoxDecoration(
            color: const Color(0xFF121724),
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
            border: Border.all(
              color: const Color(0xFF1F2B3E),
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              // Avatar Icon Box
              Container(
                width: ResponsiveHelper.w(42.0),
                height: ResponsiveHelper.w(42.0),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: accentColor.withValues(alpha: 0.4), width: 1.0),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: accentColor,
                    size: ResponsiveHelper.w(20.0),
                  ),
                ),
              ),

              SizedBox(width: ResponsiveHelper.w(14.0)),

              // Player Name & Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playerName,
                      style: AppTypography.headlineSm.copyWith(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.sp(15.0),
                        fontWeight: FontWeight.bold,
                      ).responsive(context),
                    ),
                    SizedBox(height: ResponsiveHelper.h(2.0)),
                    Text(
                      subtitle,
                      style: AppTypography.bodySm.copyWith(
                        color: const Color(0xFF7E8B9B),
                        fontSize: ResponsiveHelper.sp(12.0),
                      ).responsive(context),
                    ),
                  ],
                ),
              ),

              // Confirm Arrow
              Icon(
                Icons.chevron_right_rounded,
                color: accentColor,
                size: ResponsiveHelper.w(22.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
