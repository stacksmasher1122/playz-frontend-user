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
import 'package:redesign/theme/responsive_helper.dart';

class VolleyballLiveScoringScreen extends StatefulWidget {
  final VolleyballReviewModel reviewData;

  VolleyballLiveScoringScreen({super.key, required this.reviewData});

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
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: Color(0xFF111111),
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.accent),
          onPressed: () {
            controller.pauseMatch();
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Icon(Icons.sports_volleyball, color: AppColors.accent),
            SizedBox(width: 8),
            Text('PLAYZ SCOREBOARD', style: AppTypography.headlineMd.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12), vertical: ResponsiveHelper.h(6)),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
            ),
            child: Row(
              children: [
                Container(
                  width: ResponsiveHelper.w(8),
                  height: ResponsiveHelper.h(8),
                  decoration: BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                ),
                SizedBox(width: 8),
                Text('LIVE', style: AppTypography.labelCaps10.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          SizedBox(width: 16),
          Icon(Icons.account_circle, color: AppColors.muted),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0), vertical: ResponsiveHelper.h(24.0)),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 800),
                  child: Column(
                    children: [
                      // Score Cards Area
                      SizedBox(
                        height: ResponsiveHelper.h(280),
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
                                SizedBox(width: 16),
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
                              top: ResponsiveHelper.h(40),
                              child: FloatingSetTimer(controller: controller),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      
                      // Point Buttons Area
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: ResponsiveHelper.h(240),
                              child: PointButton(
                                onPressed: controller.addPointTeamA,
                                isPrimary: true,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: SizedBox(
                              height: ResponsiveHelper.h(240),
                              child: PointButton(
                                onPressed: controller.addPointTeamB,
                                isPrimary: false,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      
                      // Bottom Actions (Undo, Pause)
                      BottomActionBar(controller: controller),
                      SizedBox(height: 24),
                      
                      // Latest Action Log
                      LatestActionCard(controller: controller),
                      SizedBox(height: 48), // Padding before nav
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Fixed Bottom Navigation
          BottomNavigation(selectedIndex: 0),
        ],
      ),
    );
  }
}
