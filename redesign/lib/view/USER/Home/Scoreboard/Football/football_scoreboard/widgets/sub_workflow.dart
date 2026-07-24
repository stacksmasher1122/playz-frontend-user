import 'package:flutter/material.dart';
import 'package:redesign/score_engine/footballMatchEngine/football_match_engine.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_controller.dart';

class SubWorkflow extends StatefulWidget {
  final MatchEngine engine;

  SubWorkflow({super.key, required this.engine});

  @override
  State<SubWorkflow> createState() => _SubWorkflowState();
}

class _SubWorkflowState extends State<SubWorkflow> {
  TeamSide? selectedSide;
  MatchPlayer? subOut;
  MatchPlayer? subIn;

  int step = 0; // 0: Side, 1: Sub Out, 2: Sub In

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
            "Substitution",
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
    if (step == 1)
      return _buildPlayerSelection("Select Player to SUB OUT", true);
    return _buildPlayerSelection("Select Player to SUB IN", false);
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
        onTap: () => setState(() {
          selectedSide = side;
          step = 1;
        }),
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: Text(
              team.name,
              style: TextStyle(
                color: AppColors.onPrimary,
                fontSize: ResponsiveHelper.sp(20),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerSelection(String title, bool isSubOut) {
    MatchTeam team = selectedSide == TeamSide.home
        ? widget.engine.state.homeTeam
        : widget.engine.state.awayTeam;

    // Sub Out: Players on pitch. Sub In: Players NOT on pitch and NOT substituted out already
    List<MatchPlayer> availablePlayers = isSubOut
        ? team.squad.where((p) => p.isOnPitch).toList()
        : team.squad
              .where((p) => !p.isOnPitch && !p.isSubstitutedOut && !p.isSentOff)
              .toList();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(ResponsiveHelper.w(16)),
          child: Text(title, style: TextStyle(color: AppColors.muted)),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: availablePlayers.length,
            itemBuilder: (ctx, i) {
              final p = availablePlayers[i];
              return ListTile(
                title: Text(
                  p.name,
                  style: TextStyle(color: AppColors.onPrimary),
                ),
                trailing: Text(
                  "#\${p.number}",
                  style: TextStyle(color: AppColors.muted),
                ),
                onTap: () => setState(() {
                  if (isSubOut) {
                    subOut = p;
                    step = 2;
                  } else {
                    subIn = p;
                    _confirm();
                  }
                }),
              );
            },
          ),
        ),
      ],
    );
  }

  void _confirm() {
    final controller = Get.find<FootballController>();
    controller.processSubstitution(selectedSide!, subOut!, subIn!);
    Navigator.pop(context);
  }
}
