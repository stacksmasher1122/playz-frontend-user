import 'package:flutter/material.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_state_models.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BowlerSelectSheet extends StatelessWidget {
  final List<Player> bowlers;
  final Player? currentBowler;
  final ValueChanged<Player> onSelect;

  BowlerSelectSheet({
    super.key,
    required this.bowlers,
    required this.currentBowler,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Bowler',
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(18),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16),
          ...bowlers.map(
            (b) => ListTile(
              title: Text(b.name, style: TextStyle(color: Colors.white)),
              subtitle: Text(
                '${b.oversBowledDisplay} ov - ${b.runsConceded} runs - ${b.wicketsTaken} wkt',
                style: TextStyle(color: AppColors.muted, fontSize: 12),
              ),
              trailing: b.name == currentBowler?.name
                  ? Icon(Icons.check_circle, color: AppColors.accent)
                  : null,
              onTap: () => onSelect(b),
            ),
          ),
        ],
      ),
    );
  }
}
