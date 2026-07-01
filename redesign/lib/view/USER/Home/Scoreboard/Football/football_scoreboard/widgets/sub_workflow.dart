import 'package:flutter/material.dart';
import '../football_scoreboard_screen.dart';

class SubWorkflow extends StatelessWidget {
  final MatchEngine engine;
  const SubWorkflow({super.key, required this.engine});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: kSurface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.construction, color: kTextMuted, size: 48),
          const SizedBox(height: 16),
          const Text(
            "Substitution Workflow\nComing Soon",
            textAlign: TextAlign.center,
            style: TextStyle(color: kTextMuted),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CLOSE", style: TextStyle(color: kAccent)),
          ),
        ],
      ),
    );
  }
}
