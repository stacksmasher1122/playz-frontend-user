import 'package:flutter/material.dart';
import '../football_scoreboard_screen.dart';

class CardWorkflow extends StatefulWidget {
  final MatchEngine engine;
  const CardWorkflow({super.key, required this.engine});
  @override
  State<CardWorkflow> createState() => _CardWorkflowState();
}

class _CardWorkflowState extends State<CardWorkflow> {
  TeamSide? selectedSide;
  MatchPlayer? selectedPlayer;

  @override // Simplify for brevity: Team -> Player -> Type (Yellow/Red)
  Widget build(BuildContext context) {
    if (selectedSide == null) {
      return Container(
        height: 300,
        color: kSurface,
        child: Row(
          children: [
            _btn(widget.engine.homeTeam, TeamSide.home),
            _btn(widget.engine.awayTeam, TeamSide.away),
          ],
        ),
      );
    }
    if (selectedPlayer == null) {
      final team = selectedSide == TeamSide.home
          ? widget.engine.homeTeam
          : widget.engine.awayTeam;
      return Container(
        height: 500,
        color: kSurface,
        child: ListView(
          children: team.pitchPlayers
              .map(
                (p) => ListTile(
                  title: Text(
                    p.name,
                    style: const TextStyle(color: kTextPrimary),
                  ),
                  onTap: () => setState(() => selectedPlayer = p),
                ),
              )
              .toList(),
        ),
      );
    }
    return Container(
      height: 300,
      color: kSurface,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                widget.engine.processCard(
                  selectedSide!,
                  selectedPlayer!,
                  EventType.yellowCard,
                  "Foul",
                );
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.all(16),
                color: kYellow,
                child: const Center(
                  child: Text(
                    "YELLOW",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                widget.engine.processCard(
                  selectedSide!,
                  selectedPlayer!,
                  EventType.redCard,
                  "Serious Foul",
                );
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.all(16),
                color: kRed,
                child: const Center(
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
      ),
    );
  }

  Widget _btn(MatchTeam t, TeamSide s) => Expanded(
    child: GestureDetector(
      onTap: () => setState(() => selectedSide = s),
      child: Container(
        color: kSurface,
        child: Center(
          child: Text(t.name, style: const TextStyle(color: kTextPrimary)),
        ),
      ),
    ),
  );
}
