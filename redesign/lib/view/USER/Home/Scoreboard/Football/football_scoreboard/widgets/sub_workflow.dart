import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../football_scoreboard_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SubWorkflow extends StatelessWidget {
  final MatchEngine engine;
  SubWorkflow({super.key, required this.engine});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      height: ResponsiveHelper.h(200),
      color: kSurface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction, color: kTextMuted, size: 48),
          SizedBox(height: 16),
          Text(
            "Substitution Workflow\nComing Soon",
            textAlign: TextAlign.center,
            style: TextStyle(color: kTextMuted),
          ),
          SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("CLOSE", style: TextStyle(color: kAccent)),
          ),
        ],
      ),
    );
  }
}
