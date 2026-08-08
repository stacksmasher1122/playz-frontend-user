import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_controller.dart';
import 'package:redesign/score_engine/footballMatchEngine/football_match_engine.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

/// Improved Goal Assignment Modal Bottom Sheet matching the attached 4-panel UI workflow.
class GoalWorkflow extends StatefulWidget {
  final MatchEngine engine;

  const GoalWorkflow({super.key, required this.engine});

  @override
  State<GoalWorkflow> createState() => _GoalWorkflowState();
}

class _GoalWorkflowState extends State<GoalWorkflow> {
  bool isOwnGoal = false;
  TeamSide? selectedSide;
  MatchPlayer? scorer;
  MatchPlayer? assist;

  int step = 0; // 0: Type & Scoring Team, 1: Scorer, 2: Assist & Confirm

  String _getTeamInitials(String name) {
    final cleanName = name.trim().replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '');
    final words = cleanName.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.length >= 3) {
      return (words[0][0] + words[1][0] + words[2][0]).toUpperCase();
    } else if (cleanName.length >= 3) {
      return cleanName.substring(0, 3).toUpperCase();
    } else {
      return cleanName.toUpperCase();
    }
  }

  String _getPlayerInitial(String name) {
    if (name.trim().isEmpty) return '?';
    return name.trim()[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.72,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(20.0),
        vertical: ResponsiveHelper.h(12.0),
      ),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveHelper.w(24.0)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Drag Handle Pill
          Center(
            child: Container(
              width: ResponsiveHelper.w(44.0),
              height: ResponsiveHelper.h(4.5),
              margin: EdgeInsets.only(bottom: ResponsiveHelper.h(14.0)),
              decoration: BoxDecoration(
                color: AppColors.mutedText.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(10.0)),
              ),
            ),
          ),

          // Header Row (Title & Close Icon)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isOwnGoal ? 'Log Own Goal' : 'Log Goal',
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: ResponsiveHelper.sp(20.0),
                  fontWeight: FontWeight.bold,
                ).responsive(context),
              ),
              IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: AppColors.mutedText,
                  size: ResponsiveHelper.w(22.0),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(12.0)),

          // Body Content Based on Step
          Expanded(child: _buildBody(context)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (step == 0) return _buildTypeAndSideSelection(context);
    if (step == 1) return _buildScorerSelection(context);
    return _buildAssistSelection(context);
  }

  // ─── STEP 0: GOAL TYPE & TEAM SELECTION (PANEL 1) ───
  Widget _buildTypeAndSideSelection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Goal Type Switch Chips
        Row(
          children: [
            Expanded(
              child: _buildGoalTypeChip(
                context,
                label: 'Regular Goal',
                isSelected: !isOwnGoal,
                onTap: () => setState(() => isOwnGoal = false),
              ),
            ),
            SizedBox(width: ResponsiveHelper.w(12.0)),
            Expanded(
              child: _buildGoalTypeChip(
                context,
                label: 'Own Goal',
                isSelected: isOwnGoal,
                onTap: () => setState(() => isOwnGoal = true),
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveHelper.h(24.0)),

        // Section Sub-heading
        Center(
          child: Text(
            isOwnGoal ? 'Select Conceding Team' : 'Select Scoring Team',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.mutedText,
              fontSize: ResponsiveHelper.sp(14.0),
              fontWeight: FontWeight.w600,
            ).responsive(context),
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(16.0)),

        // Team Selection Cards (2 Side-by-Side Cards)
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: _buildTeamSelectCard(
                  context,
                  team: widget.engine.state.homeTeam,
                  side: TeamSide.home,
                  isSelected: selectedSide == TeamSide.home,
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(14.0)),
              Expanded(
                child: _buildTeamSelectCard(
                  context,
                  team: widget.engine.state.awayTeam,
                  side: TeamSide.away,
                  isSelected: selectedSide == TeamSide.away,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(16.0)),
      ],
    );
  }

  Widget _buildGoalTypeChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12.0)),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12.0)),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.accent.withValues(alpha: 0.15)
                : AppColors.background,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(12.0)),
            border: Border.all(
              color: isSelected ? AppColors.accent : AppColors.borderDark,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSelected) ...[
                Icon(
                  Icons.check_rounded,
                  color: AppColors.accent,
                  size: ResponsiveHelper.w(18.0),
                ),
                SizedBox(width: ResponsiveHelper.w(6.0)),
              ],
              Text(
                label,
                style: AppTypography.bodySm.copyWith(
                  color: isSelected ? AppColors.accent : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  fontSize: ResponsiveHelper.sp(13.0),
                ).responsive(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamSelectCard(
    BuildContext context, {
    required MatchTeam team,
    required TeamSide side,
    required bool isSelected,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            selectedSide = side;
            step = 1;
          });
        },
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(18.0)),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(18.0)),
            border: Border.all(
              color: isSelected ? AppColors.accent : AppColors.borderDark,
              width: isSelected ? 2.0 : 1.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circle Avatar with Initials
              Container(
                width: ResponsiveHelper.w(64.0),
                height: ResponsiveHelper.w(64.0),
                decoration: const BoxDecoration(
                  color: AppColors.card,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    _getTeamInitials(team.name),
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.accent,
                      fontSize: ResponsiveHelper.sp(18.0),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ).responsive(context),
                  ),
                ),
              ),
              SizedBox(height: ResponsiveHelper.h(14.0)),

              // Team Name
              Text(
                team.name,
                textAlign: TextAlign.center,
                style: AppTypography.headlineSm.copyWith(
                  color: isSelected ? AppColors.accent : AppColors.textPrimary,
                  fontSize: ResponsiveHelper.sp(15.0),
                  fontWeight: FontWeight.bold,
                ).responsive(context),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── STEP 1: SELECT SCORER (PANEL 2) ───
  Widget _buildScorerSelection(BuildContext context) {
    final MatchTeam team = selectedSide == TeamSide.home
        ? widget.engine.state.homeTeam
        : widget.engine.state.awayTeam;

    final List<MatchPlayer> pitchPlayers = team.squad
        .where((p) => p.isOnPitch && !p.isSentOff)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selected Scoring Team Summary Card
        _buildSummaryCard(
          context,
          headerLabel: 'Scoring Team',
          title: team.name,
          initials: _getTeamInitials(team.name),
          onChange: () => setState(() => step = 0),
        ),
        SizedBox(height: ResponsiveHelper.h(20.0)),

        // Sub-heading
        Text(
          'Select Scorer',
          style: AppTypography.labelCaps.copyWith(
            color: AppColors.mutedText,
            fontSize: ResponsiveHelper.sp(12.0),
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ).responsive(context),
        ),
        SizedBox(height: ResponsiveHelper.h(10.0)),

        // Pitch Players Scorer List
        Expanded(
          child: ListView.builder(
            itemCount: pitchPlayers.length,
            itemBuilder: (ctx, i) {
              final player = pitchPlayers[i];
              return _buildPlayerListItem(
                context,
                player: player,
                isSelected: false,
                onTap: () {
                  setState(() {
                    scorer = player;
                    if (isOwnGoal) {
                      _confirmGoal();
                    } else {
                      step = 2;
                    }
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // ─── STEP 2: SELECT ASSIST & CONFIRM (PANEL 3 & PANEL 4) ───
  Widget _buildAssistSelection(BuildContext context) {
    final MatchTeam team = selectedSide == TeamSide.home
        ? widget.engine.state.homeTeam
        : widget.engine.state.awayTeam;

    final List<MatchPlayer> pitchPlayers = team.squad
        .where((p) => p.isOnPitch && !p.isSentOff && p.id != scorer?.id)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selected Scorer Summary Card
        _buildSummaryCard(
          context,
          headerLabel: 'Scorer',
          title: scorer?.name ?? 'Unknown',
          initials: _getPlayerInitial(scorer?.name ?? ''),
          onChange: () => setState(() => step = 1),
        ),
        SizedBox(height: ResponsiveHelper.h(20.0)),

        // Sub-heading
        Text(
          assist != null ? 'Assist (Optional)' : 'Select Assist (Optional)',
          style: AppTypography.labelCaps.copyWith(
            color: AppColors.mutedText,
            fontSize: ResponsiveHelper.sp(12.0),
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ).responsive(context),
        ),
        SizedBox(height: ResponsiveHelper.h(10.0)),

        // Assist Players List
        Expanded(
          child: ListView.builder(
            itemCount: pitchPlayers.length,
            itemBuilder: (ctx, i) {
              final player = pitchPlayers[i];
              final bool isSelectedAssist = (assist?.id == player.id);
              return _buildPlayerListItem(
                context,
                player: player,
                isSelected: isSelectedAssist,
                onTap: () {
                  setState(() {
                    if (assist?.id == player.id) {
                      assist = null;
                    } else {
                      assist = player;
                    }
                  });
                },
              );
            },
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(12.0)),

        // Bottom Action Buttons
        _buildBottomActionButtons(context),
      ],
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required String headerLabel,
    required String title,
    required String initials,
    required VoidCallback onChange,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headerLabel,
          style: AppTypography.labelCaps.copyWith(
            color: AppColors.mutedText,
            fontSize: ResponsiveHelper.sp(11.0),
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ).responsive(context),
        ),
        SizedBox(height: ResponsiveHelper.h(6.0)),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.w(14.0),
            vertical: ResponsiveHelper.h(10.0),
          ),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: Row(
            children: [
              // Circle Avatar Initial
              Container(
                width: ResponsiveHelper.w(36.0),
                height: ResponsiveHelper.w(36.0),
                decoration: const BoxDecoration(
                  color: AppColors.card,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w900,
                      fontSize: ResponsiveHelper.sp(13.0),
                    ).responsive(context),
                  ),
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(12.0)),

              // Title Name
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveHelper.sp(15.0),
                  ).responsive(context),
                ),
              ),

              // Change Action Text Button
              GestureDetector(
                onTap: onChange,
                child: Text(
                  'Change',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveHelper.sp(13.0),
                  ).responsive(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerListItem(
    BuildContext context, {
    required MatchPlayer player,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.h(8.0)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.w(14.0),
              vertical: ResponsiveHelper.h(12.0),
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.accent.withValues(alpha: 0.12)
                  : AppColors.background,
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
              border: Border.all(
                color: isSelected ? AppColors.accent : AppColors.borderDark,
                width: isSelected ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              children: [
                // Circle Avatar with First Letter
                Container(
                  width: ResponsiveHelper.w(36.0),
                  height: ResponsiveHelper.w(36.0),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.accent
                        : AppColors.accent.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      _getPlayerInitial(player.name),
                      style: AppTypography.bodySm.copyWith(
                        color: isSelected
                            ? AppColors.background
                            : AppColors.accent,
                        fontWeight: FontWeight.w900,
                        fontSize: ResponsiveHelper.sp(14.0),
                      ).responsive(context),
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(12.0)),

                // Player Full Name
                Expanded(
                  child: Text(
                    player.name,
                    style: AppTypography.bodySm.copyWith(
                      color: isSelected ? AppColors.accent : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      fontSize: ResponsiveHelper.sp(14.0),
                    ).responsive(context),
                  ),
                ),

                // Shirt Number & Optional Checkmark Badge
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '#${player.number}',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.mutedText,
                        fontSize: ResponsiveHelper.sp(13.0),
                        fontFamily: 'JetBrains Mono',
                      ).responsive(context),
                    ),
                    if (isSelected) ...[
                      SizedBox(width: ResponsiveHelper.w(8.0)),
                      Container(
                        width: ResponsiveHelper.w(22.0),
                        height: ResponsiveHelper.w(22.0),
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          color: AppColors.background,
                          size: ResponsiveHelper.w(15.0),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionButtons(BuildContext context) {
    if (assist == null) {
      // Panel 3 Single Full-Width Button: NO ASSIST (SAVE GOAL)
      return SizedBox(
        width: double.infinity,
        height: ResponsiveHelper.h(48.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
            side: const BorderSide(color: AppColors.borderDark, width: 1.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
            ),
          ),
          onPressed: () {
            assist = null;
            _confirmGoal();
          },
          child: Text(
            'NO ASSIST (SAVE GOAL)',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveHelper.sp(13.0),
              letterSpacing: 0.5,
            ).responsive(context),
          ),
        ),
      );
    }

    // Panel 4 Two Buttons Side-by-Side: NO ASSIST | SAVE GOAL (WITH ASSIST)
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: ResponsiveHelper.h(48.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.background,
                foregroundColor: AppColors.textPrimary,
                elevation: 0,
                side: const BorderSide(color: AppColors.borderDark, width: 1.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
                ),
              ),
              onPressed: () {
                assist = null;
                _confirmGoal();
              },
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'NO ASSIST',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveHelper.sp(13.0),
                  ).responsive(context),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: ResponsiveHelper.w(12.0)),
        Expanded(
          flex: 2,
          child: SizedBox(
            height: ResponsiveHelper.h(48.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.background,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
                ),
              ),
              onPressed: _confirmGoal,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'SAVE GOAL (WITH ASSIST)',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.background,
                    fontWeight: FontWeight.w900,
                    fontSize: ResponsiveHelper.sp(13.0),
                    letterSpacing: 0.5,
                  ).responsive(context),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _confirmGoal() {
    final controller = Get.find<FootballController>();
    if (isOwnGoal) {
      controller.processOwnGoal(selectedSide!, scorer!);
    } else {
      controller.processGoal(selectedSide!, scorer, assist);
    }
    Navigator.pop(context);
  }
}
