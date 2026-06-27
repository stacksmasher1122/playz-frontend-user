import 'package:flutter/material.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_state_models.dart';
import 'package:redesign/theme/app_colors.dart';

class BowlerSelectSheet extends StatelessWidget {
  final List<Player> bowlers;
  final Player? currentBowler;
  final ValueChanged<Player> onSelect;

  const BowlerSelectSheet({
    super.key,
    required this.bowlers,
    required this.currentBowler,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Bowler',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          ...bowlers.map(
            (b) => ListTile(
              title: Text(b.name, style: const TextStyle(color: Colors.white)),
              subtitle: Text(
                '${b.oversBowledDisplay} ov - ${b.runsConceded} runs - ${b.wicketsTaken} wkt',
                style: const TextStyle(color: AppColors.muted, fontSize: 12),
              ),
              trailing: b.name == currentBowler?.name
                  ? const Icon(Icons.check_circle, color: AppColors.accent)
                  : null,
              onTap: () => onSelect(b),
            ),
          ),
        ],
      ),
    );
  }
}
