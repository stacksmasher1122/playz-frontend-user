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
  TeamSide? selectedSide;
  MatchPlayer? scorer;
  MatchPlayer? assist;

  int step = 0; // 0: Side, 1: Scorer, 2: Assist/Confirm

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      height: ResponsiveHelper.h(500),
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
            "Log Goal",
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
    if (step == 1) return _buildPlayerSelection("Select Scorer", true);
    return _buildPlayerSelection("Select Assist (Optional)", false);
  }

  Widget _buildSideSelection() {
    return Row(
      children: [
        _buildTeamBtn(widget.engine.state.homeTeam, TeamSide.home),
        _buildTeamBtn(widget.engine.state.awayTeam, TeamSide.away),
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
          color: Colors.transparent,
          child: Center(
            child: Text(
              team.name,
              style: TextStyle(
                color: AppColors.success, // Assuming it's a goal color
                fontSize: ResponsiveHelper.sp(20),
                fontWeight: FontWeight.bold,
              ),
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

    // Only show players on pitch
    List<MatchPlayer> pitchPlayers = team.squad
        .where((p) => p.isOnPitch)
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
              // Don't show scorer as an option for assist
              if (!isScorer && p.id == scorer?.id) return SizedBox();

              return ListTile(
                title: Text(
                  p.name,
                  style: TextStyle(color: AppColors.onPrimary),
                ),
                trailing: Text(
                  "#\${p.number}",
                  style: TextStyle(color: AppColors.muted),
                ),
                onTap: () {
                  setState(() {
                    if (isScorer) {
                      scorer = p;
                      step = 2;
                    } else {
                      assist = p;
                      _confirm();
                    }
                  });
                },
              );
            },
          ),
        ),
        if (!isScorer)
          Padding(
            padding: EdgeInsets.all(ResponsiveHelper.w(16)),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.outlineVariant,
                minimumSize: Size(double.infinity, ResponsiveHelper.h(50)),
              ),
              onPressed: _confirm,
              child: Text(
                "NO ASSIST",
                style: TextStyle(color: AppColors.onPrimary),
              ),
            ),
          ),
      ],
    );
  }

  void _confirm() {
    final controller = Get.find<FootballController>();
    controller.processGoal(selectedSide!, scorer, assist);
    Navigator.pop(context);
  }
}
