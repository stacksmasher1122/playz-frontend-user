import 'package:flutter/material.dart';
import 'package:redesign/score_engine/footballMatchEngine/football_match_engine.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_controller.dart';

class ProfessionalRulesWorkflow extends StatefulWidget {
  final MatchEngine engine;

  ProfessionalRulesWorkflow({super.key, required this.engine});

  @override
  State<ProfessionalRulesWorkflow> createState() =>
      _ProfessionalRulesWorkflowState();
}

class _ProfessionalRulesWorkflowState extends State<ProfessionalRulesWorkflow> {
  TeamSide? selectedSide;
  MatchPlayer? selectedPlayer;
  EventType? selectedRule;

  int step =
      0; // 0: Rule Type, 1: Side, 2: Player (for offside/freekick/penalty)

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
            "Pro Rules",
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
    if (step == 0) return _buildRuleSelection();
    if (step == 1) return _buildSideSelection();
    return _buildPlayerSelection();
  }

  Widget _buildRuleSelection() {
    return ListView(
      children: [
        if (widget.engine.state.phase != MatchPhase.penalties) ...[
          _buildRuleTile(
            "Offside",
            EventType.offside,
            Icons.flag,
            Colors.orange,
          ),
          _buildRuleTile(
            "Free Kick",
            EventType.freeKick,
            Icons.sports_kabaddi,
            Colors.blue,
          ),
        ],
        if (widget.engine.state.phase == MatchPhase.penalties ||
            widget.engine.penaltiesEnabled) ...[
          _buildRuleTile(
            "Penalty Goal",
            EventType.penaltyGoal,
            Icons.sports_soccer,
            Colors.green,
          ),
          _buildRuleTile(
            "Penalty Miss",
            EventType.penaltyMiss,
            Icons.close,
            Colors.red,
          ),
        ],
      ],
    );
  }

  Widget _buildRuleTile(
    String title,
    EventType type,
    IconData icon,
    Color color,
  ) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: AppColors.onPrimary)),
      onTap: () => setState(() {
        selectedRule = type;
        step = 1;
      }),
    );
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
          step = 2;
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

  Widget _buildPlayerSelection() {
    MatchTeam team = selectedSide == TeamSide.home
        ? widget.engine.state.homeTeam
        : widget.engine.state.awayTeam;
    List<MatchPlayer> pitchPlayers = team.squad
        .where((p) => p.isOnPitch)
        .toList();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(ResponsiveHelper.w(16)),
          child: Text(
            "Select Player (Optional)",
            style: TextStyle(color: AppColors.muted),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: pitchPlayers.length,
            itemBuilder: (ctx, i) {
              final p = pitchPlayers[i];
              return ListTile(
                title: Text(
                  p.name,
                  style: TextStyle(color: AppColors.onPrimary),
                ),
                trailing: Text(
                  "#\${p.number}",
                  style: TextStyle(color: AppColors.muted),
                ),
                onTap: () => _confirm(p),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(ResponsiveHelper.w(16)),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.outlineVariant,
              minimumSize: Size(double.infinity, ResponsiveHelper.h(50)),
            ),
            onPressed: () => _confirm(null),
            child: Text(
              "SKIP PLAYER",
              style: TextStyle(color: AppColors.onPrimary),
            ),
          ),
        ),
      ],
    );
  }

  void _confirm(MatchPlayer? player) {
    final controller = Get.find<FootballController>();
    if (selectedRule == EventType.offside) {
      controller.processOffside(selectedSide!, player);
    } else if (selectedRule == EventType.freeKick) {
      controller.processFreeKick(selectedSide!, player);
    } else if (selectedRule == EventType.penaltyGoal) {
      controller.processPenalty(selectedSide!, player, true);
    } else if (selectedRule == EventType.penaltyMiss) {
      controller.processPenalty(selectedSide!, player, false);
    }
    Navigator.pop(context);
  }
}
