import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/app_dimensions.dart';
import '../../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Basketball/basketball_state_models.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Basketball/basketball_controller.dart';

class BasketballMatchSummaryCard extends StatelessWidget {
  final BasketballMatchState state;
  final BasketballController controller;

  const BasketballMatchSummaryCard({super.key, required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    final summary = controller.engine.generateMatchSummary();
    final homeScorers = summary['homeScorers'] as List<Map<String, dynamic>>;
    final awayScorers = summary['awayScorers'] as List<Map<String, dynamic>>;
    final quarterScores = summary['quarterScores'] as Map<int, Map<String, int>>;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        child: Column(
          children: [
            Text('MATCH COMPLETED', style: AppTypography.labelCaps.copyWith(color: AppColors.accent, letterSpacing: 2)),
            const SizedBox(height: AppDimensions.paddingSm),
            Text(summary['winner'], style: AppTypography.headlineLg.copyWith(color: Colors.white)),
            const SizedBox(height: AppDimensions.paddingLg),

            // Final Score
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(state.homeTeam.teamName, style: AppTypography.headlineSm),
                    const SizedBox(height: AppDimensions.paddingSm),
                    Text('${summary['homeScore']}', style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingLg),
                  child: Text('-', style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 48, fontWeight: FontWeight.bold, color: Colors.grey)),
                ),
                Column(
                  children: [
                    Text(state.awayTeam.teamName, style: AppTypography.headlineSm),
                    const SizedBox(height: AppDimensions.paddingSm),
                    Text('${summary['awayScore']}', style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingXl),

            // Quarter breakdown
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              ),
              child: Column(
                children: [
                  Text('Quarterly Breakdown', style: AppTypography.headlineSm),
                  const Divider(color: AppColors.surface, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text('Qtr', style: TextStyle(color: Colors.grey)),
                      Text(state.homeTeam.teamName, style: const TextStyle(color: Colors.grey)),
                      Text(state.awayTeam.teamName, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.paddingSm),
                  ...quarterScores.entries.map((e) {
                     String qLabel = e.key > 4 ? 'OT${e.key - 4}' : 'Q${e.key}';
                     return Padding(
                       padding: const EdgeInsets.symmetric(vertical: 4),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                         children: [
                           Text(qLabel, style: AppTypography.bodySm),
                           Text('${e.value['home']}', style: const TextStyle(fontFamily: 'JetBrains Mono', color: Colors.white)),
                           Text('${e.value['away']}', style: const TextStyle(fontFamily: 'JetBrains Mono', color: Colors.white)),
                         ],
                       ),
                     );
                  }),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.paddingXl),

            // Leading Scorers
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildTopScorers(state.homeTeam.teamName, homeScorers),
                ),
                const SizedBox(width: AppDimensions.paddingMd),
                Expanded(
                  child: _buildTopScorers(state.awayTeam.teamName, awayScorers),
                ),
              ],
            ),

            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surface,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Text('Exit Match', style: AppTypography.labelCaps),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopScorers(String teamName, List<Map<String, dynamic>> scorers) {
      return Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
             Text(teamName, style: AppTypography.headlineSm, overflow: TextOverflow.ellipsis),
             const SizedBox(height: AppDimensions.paddingSm),
             ...scorers.take(3).map((s) => Padding(
                 padding: const EdgeInsets.only(bottom: 4),
                 child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                         Expanded(child: Text(s['name'], style: AppTypography.bodySm, overflow: TextOverflow.ellipsis)),
                         Text('${s['points']} pts', style: const TextStyle(fontFamily: 'JetBrains Mono', color: Colors.grey, fontSize: 12)),
                     ],
                 ),
             )),
         ],
      );
  }
}
