import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_dimensions.dart';
import '../../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Basketball/basketball_state_models.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Basketball/basketball_controller.dart';

class ScoreClockDisplay extends StatelessWidget {
  final BasketballMatchState state;
  final BasketballController controller;

  const ScoreClockDisplay({super.key, required this.state, required this.controller});

  String _formatTime(int seconds) {
    int m = seconds ~/ 60;
    int s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    bool isGameClockUrgent = state.gameClockSeconds < 60 && state.gameClockSeconds > 0;
    bool isShotClockUrgent = state.shotClockSeconds <= 5 && state.shotClockSeconds > 0;

    return Column(
      children: [
        // Score Display Zone
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${state.homeTeam.score}',
              style: const TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingLg),
              child: Text(
                '-',
                style: TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            Text(
              '${state.awayTeam.score}',
              style: const TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppDimensions.paddingMd),

        // Clock Zone
        GestureDetector(
          onTap: controller.toggleClock,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingLg, vertical: AppDimensions.paddingSm),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              border: Border.all(color: state.isClockRunning ? AppColors.accent : AppColors.card),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  _formatTime(state.gameClockSeconds),
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: isGameClockUrgent ? AppColors.error : Colors.white,
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingLg),
                Text(
                  '${state.shotClockSeconds}',
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: isShotClockUrgent ? AppColors.warning : Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
