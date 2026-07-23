import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/app_dimensions.dart';
import '../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Basketball/basketball_state_models.dart';
import '../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Basketball/basketball_controller.dart';

import 'widgets/basketball_scoreboard_header.dart';
import 'widgets/score_clock_display.dart';
import 'widgets/foul_indicator_strip.dart';
import 'widgets/scoring_console.dart';
import 'widgets/secondary_match_controls.dart';
import 'widgets/match_summary_card.dart';

class BasketballScoreboardScreen extends StatelessWidget {
  const BasketballScoreboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BasketballController controller = Get.find<BasketballController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => _showExitDialog(context, controller),
        ),
        actions: [
          Obx(() {
             final state = controller.liveState.value;
             if (state == null || state.phase == MatchPhase.completed) return const SizedBox.shrink();

             if (state.phase == MatchPhase.quarterBreak || state.phase == MatchPhase.halfTime) {
                return TextButton(
                   onPressed: controller.startNextQuarter,
                   child: Text('Start Next Qtr', style: AppTypography.labelCaps.copyWith(color: AppColors.accent)),
                );
             }
             return const SizedBox.shrink();
          }),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          final state = controller.liveState.value;

          if (state == null) {
             return const Center(child: CircularProgressIndicator(color: AppColors.accent));
          }

          if (state.phase == MatchPhase.completed) {
             return BasketballMatchSummaryCard(state: state, controller: controller);
          }

          return Column(
            children: [
              BasketballScoreboardHeader(state: state, controller: controller),
              const SizedBox(height: AppDimensions.paddingMd),
              ScoreClockDisplay(state: state, controller: controller),
              const SizedBox(height: AppDimensions.paddingSm),
              FoulIndicatorStrip(state: state),
              const SizedBox(height: AppDimensions.paddingLg),

              if (state.phase == MatchPhase.live || state.phase == MatchPhase.overtime) ...[
                ScoringConsole(state: state, controller: controller),
                const SizedBox(height: AppDimensions.paddingLg),
                SecondaryMatchControls(state: state, controller: controller),
              ] else if (state.phase == MatchPhase.quarterBreak || state.phase == MatchPhase.halfTime) ...[
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.phase == MatchPhase.halfTime ? 'HALF TIME' : 'QUARTER BREAK', style: AppTypography.headlineLg.copyWith(color: Colors.grey)),
                        const SizedBox(height: AppDimensions.paddingLg),
                        ElevatedButton(
                          onPressed: controller.startNextQuarter,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: AppColors.background,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: Text('Start Next Quarter', style: AppTypography.labelCaps),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          );
        }),
      ),
    );
  }

  void _showExitDialog(BuildContext context, BasketballController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text('Exit Match?', style: AppTypography.headlineMd.copyWith(color: Colors.white)),
        content: Text(
            'The match state will be saved. You can resume later or mark it as completed now.',
            style: AppTypography.bodyLg.copyWith(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Get.back(); // Just exit to previous matches/live screen
            },
            child: Text('Exit', style: AppTypography.labelCaps.copyWith(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.completeMatchManual('WALKOVER');
            },
            child: Text('End Match', style: AppTypography.labelCaps.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
