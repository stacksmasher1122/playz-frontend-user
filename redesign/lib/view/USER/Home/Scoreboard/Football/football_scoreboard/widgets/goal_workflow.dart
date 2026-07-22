import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../football_scoreboard_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

class GoalWorkflow extends StatefulWidget {
  final MatchEngine engine;
  GoalWorkflow({super.key, required this.engine});
  @override
  State<GoalWorkflow> createState() => _GoalWorkflowState();
}

class _GoalWorkflowState extends State<GoalWorkflow> {
  int step = 0; // 0=Team, 1=Scorer, 2=Assist
  TeamSide? selectedSide;
  MatchPlayer? scorer;

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(24))),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildStepContent()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    String title = "SELECT TEAM";
    if (step == 1) title = "SELECT SCORER";
    if (step == 2) title = "SELECT ASSIST (Optional)";

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: kDivider)),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: kTextPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    if (step == 0) {
      return Row(
        children: [
          _teamBtn(widget.engine.homeTeam, TeamSide.home),
          _teamBtn(widget.engine.awayTeam, TeamSide.away),
        ],
      );
    }

    final team = selectedSide == TeamSide.home
        ? widget.engine.homeTeam
        : widget.engine.awayTeam;
    // Show players on pitch + bench (sometimes subs score immediately or records are messy)
    // Ideally only pitch players.
    final players = team.pitchPlayers;

    return ListView.builder(
      itemCount: players.length + 1, // +1 for "None/Own Goal"
      itemBuilder: (ctx, i) {
        if (i == players.length) {
          return ListTile(
            title: Text(
              step == 2 ? "No Assist" : "Own Goal / Unknown",
              style: TextStyle(color: kTextMuted),
            ),
            onTap: () => _finish(null),
          );
        }
        final p = players[i];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: kSurfaceHighlight,
            child: Text(
              "${p.number}",
              style: TextStyle(color: kTextPrimary),
            ),
          ),
          title: Text(p.name, style: TextStyle(color: kTextPrimary)),
          onTap: () {
            if (step == 1) {
              setState(() {
                scorer = p;
                step = 2;
              });
            } else {
              _finish(p);
            }
          },
        );
      },
    );
  }

  Widget _teamBtn(MatchTeam team, TeamSide side) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          selectedSide = side;
          step = 1;
        }),
        child: Container(
          margin: EdgeInsets.all(ResponsiveHelper.w(16)),
          decoration: BoxDecoration(
            color: team.color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
            border: Border.all(color: team.color),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shield, color: team.color, size: 48),
              SizedBox(height: 12),
              Text(
                team.name,
                style: TextStyle(
                  color: kTextPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveHelper.sp(18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _finish(MatchPlayer? p) {
    if (step == 1 && p == null) {
      // Unknown Scorer / Own Goal
      setState(() {
        scorer = null;
        step = 2;
      });
      return;
    }

    if (step == 2) {
      widget.engine.processGoal(selectedSide!, scorer, p); // p is assist
      Navigator.pop(context);
    }
  }
}
