import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_review_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_live_scoring_controller.dart';
import 'widgets/team_score_card.dart';
import 'widgets/floating_set_timer.dart';
import 'widgets/point_button.dart';
import 'widgets/bottom_action_bar.dart';
import 'widgets/latest_action_card.dart';
import 'widgets/bottom_navigation.dart';

class VolleyballLiveScoringScreen extends StatefulWidget {
  final VolleyballReviewModel reviewData;

  const VolleyballLiveScoringScreen({super.key, required this.reviewData});

  @override
  State<VolleyballLiveScoringScreen> createState() => _VolleyballLiveScoringScreenState();
}

class _VolleyballLiveScoringScreenState extends State<VolleyballLiveScoringScreen> {
  late VolleyballLiveScoringController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(VolleyballLiveScoringController());
    controller.initializeMatch(widget.reviewData);
  }

  @override
  void dispose() {
    Get.delete<VolleyballLiveScoringController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () {
            controller.pauseMatch();
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            const Icon(Icons.sports_volleyball, color: AppColors.primaryContainer),
            const SizedBox(width: 8),
            Text('PLAYZ SCOREBOARD', style: AppTypography.headlineMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: AppColors.primaryContainer, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text('LIVE', style: AppTypography.labelCaps10.copyWith(color: AppColors.primaryContainer, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.account_circle, color: AppColors.muted),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    children: [
                      // Score Cards Area
                      SizedBox(
                        height: 280,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Obx(() => TeamScoreCard(
                                    teamName: widget.reviewData.teamA.teamName,
                                    setsWon: controller.teamASets.value,
                                    score: controller.teamAScore.value,
                                    isServing: controller.isTeamAServing.value,
                                  )),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Obx(() => TeamScoreCard(
                                    teamName: widget.reviewData.teamB.teamName,
                                    setsWon: controller.teamBSets.value,
                                    score: controller.teamBScore.value,
                                    isServing: !controller.isTeamAServing.value,
                                  )),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 40,
                              child: FloatingSetTimer(controller: controller),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Point Buttons Area
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 240,
                              child: PointButton(
                                onPressed: controller.addPointTeamA,
                                isPrimary: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: SizedBox(
                              height: 240,
                              child: PointButton(
                                onPressed: controller.addPointTeamB,
                                isPrimary: false,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Bottom Actions (Undo, Pause)
                      BottomActionBar(controller: controller),
                      const SizedBox(height: 24),
                      
                      // Latest Action Log
                      LatestActionCard(controller: controller),
                      const SizedBox(height: 48), // Padding before nav
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Fixed Bottom Navigation
          const BottomNavigation(selectedIndex: 0),
        ],
      ),
    );
  }
}
