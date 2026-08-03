import 'package:flutter/material.dart';
import 'package:redesign/score_engine/footballMatchEngine/football_match_engine.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_controller.dart';

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

  int step = 0; // 0: Type & Side, 1: Scorer, 2: Assist/Confirm

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      height: ResponsiveHelper.h(520),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveHelper.w(24)),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.outlineVariant)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isOwnGoal ? "Log Own Goal" : "Log Goal",
            style: TextStyle(
              color: AppColors.onPrimary,
              fontSize: ResponsiveHelper.sp(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: AppColors.muted),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (step == 0) return _buildSideSelection();
    if (step == 1) return _buildPlayerSelection(isOwnGoal ? "Select Player (Scored Own Goal)" : "Select Scorer", true);
    return _buildPlayerSelection("Select Assist (Optional)", false);
  }

  Widget _buildSideSelection() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilterChip(
                selected: !isOwnGoal,
                label: Text("Regular Goal", style: TextStyle(color: !isOwnGoal ? AppColors.background : AppColors.onPrimary)),
                selectedColor: AppColors.success,
                onSelected: (val) => setState(() => isOwnGoal = false),
              ),
              SizedBox(width: ResponsiveHelper.w(12)),
              FilterChip(
                selected: isOwnGoal,
                label: Text("Own Goal", style: TextStyle(color: isOwnGoal ? AppColors.background : AppColors.onPrimary)),
                selectedColor: AppColors.error,
                onSelected: (val) => setState(() => isOwnGoal = true),
              ),
            ],
          ),
        ),
        Text(
          isOwnGoal ? "Select Conceding Team:" : "Select Scoring Team:",
          style: TextStyle(color: AppColors.muted, fontSize: ResponsiveHelper.sp(14)),
        ),
        SizedBox(height: ResponsiveHelper.h(12)),
        Expanded(
          child: Row(
            children: [
              _buildTeamBtn(widget.engine.state.homeTeam, TeamSide.home),
              _buildTeamBtn(widget.engine.state.awayTeam, TeamSide.away),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTeamBtn(MatchTeam team, TeamSide side) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedSide = side;
            step = 1;
          });
        },
        child: Container(
          margin: EdgeInsets.all(ResponsiveHelper.w(12)),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Center(
            child: Text(
              team.name,
              style: TextStyle(
                color: isOwnGoal ? AppColors.error : AppColors.success,
                fontSize: ResponsiveHelper.sp(18),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerSelection(String title, bool isScorer) {
    MatchTeam team = selectedSide == TeamSide.home
        ? widget.engine.state.homeTeam
        : widget.engine.state.awayTeam;

    List<MatchPlayer> pitchPlayers = team.squad
        .where((p) => p.isOnPitch && !p.isSentOff)
        .toList();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(ResponsiveHelper.w(16)),
          child: Text(title, style: TextStyle(color: AppColors.muted)),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: pitchPlayers.length,
            itemBuilder: (ctx, i) {
              final p = pitchPlayers[i];
              if (!isScorer && p.id == scorer?.id) return const SizedBox();

              final isSelectedAssist = !isScorer && assist?.id == p.id;

              return Container(
                margin: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.w(12),
                  vertical: ResponsiveHelper.h(4),
                ),
                decoration: BoxDecoration(
                  color: isSelectedAssist
                      ? AppColors.accent.withValues(alpha: 0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                  border: isSelectedAssist
                      ? Border.all(color: AppColors.accent, width: 1)
                      : null,
                ),
                child: ListTile(
                  title: Text(
                    p.name,
                    style: TextStyle(
                      color: isSelectedAssist ? AppColors.accent : AppColors.onPrimary,
                      fontWeight: isSelectedAssist ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: Text(
                    "#${p.number}",
                    style: TextStyle(color: isSelectedAssist ? AppColors.accent : AppColors.muted),
                  ),
                  onTap: () {
                    setState(() {
                      if (isScorer) {
                        scorer = p;
                        if (isOwnGoal) {
                          _confirm();
                        } else {
                          step = 2;
                        }
                      } else {
                        // Toggle assist selection
                        if (assist?.id == p.id) {
                          assist = null;
                        } else {
                          assist = p;
                        }
                      }
                    });
                  },
                ),
              );
            },
          ),
        ),
        if (!isScorer && !isOwnGoal)
          Padding(
            padding: EdgeInsets.all(ResponsiveHelper.w(16)),
            child: Row(
              children: [
                if (assist != null) ...[
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFF3A3A3A)),
                        backgroundColor: Color(0xFF1E1E1E),
                        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(14)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          assist = null;
                        });
                        _confirm();
                      },
                      child: Text(
                        "NO ASSIST",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.w(12)),
                ],
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: assist != null ? AppColors.accent : Color(0xFF262626),
                      foregroundColor: assist != null ? Colors.black : Colors.white,
                      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(14)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                        side: BorderSide(
                          color: assist != null ? AppColors.accent : Color(0xFF3A3A3A),
                        ),
                      ),
                    ),
                    onPressed: _confirm,
                    child: Text(
                      assist != null ? "SAVE GOAL (WITH ASSIST)" : "NO ASSIST (SAVE GOAL)",
                      style: TextStyle(
                        color: assist != null ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: ResponsiveHelper.sp(13),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _confirm() {
    final controller = Get.find<FootballController>();
    if (isOwnGoal) {
      controller.processOwnGoal(selectedSide!, scorer!);
    } else {
      controller.processGoal(selectedSide!, scorer, assist);
    }
    Navigator.pop(context);
  }
}
