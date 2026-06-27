import 'package:flutter/material.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_state_models.dart';
import 'package:redesign/theme/app_colors.dart';

class AdvancedActionsGrid extends StatelessWidget {
  final Player? striker;
  final Player? nonStriker;
  final VoidCallback onChangeBowler;
  final VoidCallback onVideoRefer;
  final VoidCallback onRetireBatter;
  final VoidCallback onMatchBreak;

  const AdvancedActionsGrid({
    super.key,
    required this.striker,
    required this.nonStriker,
    required this.onChangeBowler,
    required this.onVideoRefer,
    required this.onRetireBatter,
    required this.onMatchBreak,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              _advBtn(
                Icons.swap_horiz,
                'Change Bowler',
                'End of over',
                onChangeBowler,
              ),
              _advBtn(
                Icons.videocam,
                'Video Refer',
                'Third Umpire',
                onVideoRefer,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _advBtn(Icons.person_off, 'Retire Batter', 'Hurt / Out', () {
                if (striker != null || nonStriker != null) {
                  onRetireBatter();
                }
              }),
              const SizedBox(width: 12),
              _advBtn(
                Icons.pause_circle_outline,
                'Match Break',
                'Drinks / Rain',
                onMatchBreak,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _advBtn(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.muted, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(color: AppColors.muted, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
