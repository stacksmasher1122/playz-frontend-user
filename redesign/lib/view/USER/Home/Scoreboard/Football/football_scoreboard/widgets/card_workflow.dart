import 'package:flutter/material.dart';
import 'package:redesign/score_engine/footballMatchEngine/football_match_engine.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_controller.dart';

class CardWorkflow extends StatefulWidget {
  final MatchEngine engine;

  CardWorkflow({super.key, required this.engine});

  @override
  State<CardWorkflow> createState() => _CardWorkflowState();
}

class _CardWorkflowState extends State<CardWorkflow> {
  TeamSide? selectedSide;
  MatchPlayer? selectedPlayer;
  EventType? cardType;

  int step = 0; // 0: Side, 1: Player, 2: Card Type

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
            "Issue Card",
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
    if (step == 1) return _buildPlayerSelection();
    return _buildCardSelection();
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
            "Select Player",
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
                onTap: () => setState(() {
                  selectedPlayer = p;
                  step = 2;
                }),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCardSelection() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _confirm(EventType.yellowCard),
            child: Container(
              margin: EdgeInsets.all(ResponsiveHelper.w(16)),
              color: AppColors.warning,
              child: Center(
                child: Text(
                  "YELLOW",
                  style: TextStyle(
                    color: AppColors.background,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => _confirm(EventType.redCard),
            child: Container(
              margin: EdgeInsets.all(ResponsiveHelper.w(16)),
              color: AppColors.error,
              child: Center(
                child: Text(
                  "RED",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _confirm(EventType type) {
    final controller = Get.find<FootballController>();
    controller.processCard(selectedSide!, selectedPlayer!, type, "Foul");
    Navigator.pop(context);
  }
}
