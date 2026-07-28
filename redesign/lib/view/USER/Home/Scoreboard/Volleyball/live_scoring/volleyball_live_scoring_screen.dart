import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_review_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_live_scoring_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Volleyball/rotation_subs/volleyball_rotation_subs_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Volleyball/rotation_subs/widgets/rotation_court_widget.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_rotation_subs_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Volleyball/stats/widgets/team_statistics_card.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Volleyball/stats/widgets/match_insight_card.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_stats_controller.dart';

import 'widgets/team_score_card.dart';
import 'widgets/floating_set_timer.dart';
import 'widgets/latest_action_card.dart';
import 'widgets/point_attribution_bottom_sheet.dart';
import 'widgets/penalty_bottom_sheet.dart';

class VolleyballLiveScoringScreen extends StatefulWidget {
  final VolleyballReviewModel reviewData;

  const VolleyballLiveScoringScreen({super.key, required this.reviewData});

  @override
  State<VolleyballLiveScoringScreen> createState() => _VolleyballLiveScoringScreenState();
}

class _VolleyballLiveScoringScreenState extends State<VolleyballLiveScoringScreen> with SingleTickerProviderStateMixin {
  late VolleyballLiveScoringController controller;
  late VolleyballRotationSubsController subsController;
  late VolleyballStatsController statsController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(VolleyballLiveScoringController());
    try {
      controller.initialData;
    } catch (_) {
      // Initialize if it wasn't already initialized by the previous screen
      controller.initializeMatch(widget.reviewData, true);
    }
    subsController = Get.put(VolleyballRotationSubsController());
    statsController = Get.put(VolleyballStatsController());
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text('Exit Match?', style: AppTypography.headlineSm.copyWith(color: AppColors.accent)),
        content: Text('Are you sure you want to exit the live match?', style: AppTypography.bodyMd.copyWith(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('CANCEL', style: AppTypography.labelCaps.copyWith(color: AppColors.muted)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text('EXIT', style: AppTypography.labelCaps.copyWith(color: Colors.white)),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.accent),
            onPressed: () async {
              if (await _onWillPop()) {
                if (context.mounted) Navigator.pop(context);
              }
            },
          ),
          title: Row(
          children: [
            Icon(Icons.sports_volleyball, color: AppColors.accent, size: ResponsiveHelper.w(24)),
            SizedBox(width: 8),
            Text('PLAYZ SCOREBOARD', style: AppTypography.headlineMd.copyWith(color: AppColors.accent)),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: ResponsiveHelper.w(16)),
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12), vertical: ResponsiveHelper.h(6)),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(100)),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.5)),
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
        ],
      ),
      body: Column(
        children: [
          // Fixed Top Scoreboard
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Row(
                  children: [
                    Expanded(child: Obx(() => TeamScoreCard(
                      teamName: widget.reviewData.teamA.teamName,
                      score: controller.teamAScore.value,
                      setsWon: controller.teamASets.value,
                      isServing: controller.isTeamAServing.value,
                    ))),
                    SizedBox(width: 8),
                    Expanded(child: Obx(() => TeamScoreCard(
                      teamName: widget.reviewData.teamB.teamName,
                      score: controller.teamBScore.value,
                      setsWon: controller.teamBSets.value,
                      isServing: !controller.isTeamAServing.value,
                    ))),
                  ],
                ),
                Positioned(
                  top: ResponsiveHelper.h(30),
                  child: FloatingSetTimer(controller: controller),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 16),
          
          // Tab Bar for Middle Section
          Spacer(),
          
          // Fixed Bottom Action Panel (Cricket-Style)
          _buildCricketStyleActionPanel(context),
        ],
      ),
    ));
  }

  Widget _buildCricketStyleActionPanel(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: AppColors.outlineVariant, width: 1)),
      ),
      padding: EdgeInsets.only(
        left: 16, 
        right: 16, 
        top: 24, 
        bottom: MediaQuery.of(context).padding.bottom + 16
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Primary Actions: Add Points
          Row(
            children: [
              Expanded(
                child: _buildPointButton(
                  teamName: widget.reviewData.teamA.teamName,
                  isTeamA: true,
                  onPressed: () => _openPointBottomSheet(isTeamA: true),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildPointButton(
                  teamName: widget.reviewData.teamB.teamName,
                  isTeamA: false,
                  onPressed: () => _openPointBottomSheet(isTeamA: false),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          
          // Secondary Actions Grid
          Row(
            children: [
              Expanded(child: _buildSecondaryButton(Icons.undo, 'UNDO', controller.undoLastPoint)),
              SizedBox(width: 8),
              Expanded(child: _buildSecondaryButton(Icons.sync, 'SUBS', () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => VolleyballRotationSubsScreen()));
              })),
              SizedBox(width: 8),
              Expanded(child: _buildSecondaryButton(Icons.warning_amber, 'PENALTY', () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => PenaltyBottomSheet(
                    teamAName: controller.initialData.teamA.teamName,
                    teamBName: controller.initialData.teamB.teamName,
                    onPenaltyIssued: (team, cardType, reason) {
                      controller.issuePenalty(team, cardType, reason);
                    },
                  ),
                );
              }, color: AppColors.error)),
              SizedBox(width: 8),
              Expanded(child: Obx(() => _buildSecondaryButton(
                controller.isPaused.value ? Icons.play_arrow : Icons.pause, 
                controller.isPaused.value ? 'RESUME' : 'PAUSE', 
                controller.isPaused.value ? controller.resumeMatch : controller.pauseMatch,
                color: Colors.amber
              ))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPointButton({required String teamName, required bool isTeamA, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.card,
        padding: EdgeInsets.symmetric(vertical: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.accent.withValues(alpha: 0.3), width: 1),
        ),
      ),
      child: Column(
        children: [
          Text(teamName.toUpperCase(), style: AppTypography.labelCaps10.copyWith(color: AppColors.muted), maxLines: 1, overflow: TextOverflow.ellipsis),
          SizedBox(height: 8),
          Text('+1 POINT', style: AppTypography.headlineLg.copyWith(color: AppColors.accent)),
        ],
      ),
    );
  }

  Widget _buildSecondaryButton(IconData icon, String label, VoidCallback onPressed, {Color? color}) {
    Color effectiveColor = color ?? Colors.white;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.card,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: effectiveColor, size: 24),
          SizedBox(height: 4),
          Text(label, style: AppTypography.labelCaps10.copyWith(color: effectiveColor)),
        ],
      ),
    );
  }

  void _openPointBottomSheet({required bool isTeamA}) {
    if (controller.matchFinished.value || controller.isPaused.value) {
      if (isTeamA) {
        controller.addPointTeamA();
      } else {
        controller.addPointTeamB();
      }
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PointAttributionBottomSheet(
        scoringTeamName: isTeamA ? widget.reviewData.teamA.teamName : widget.reviewData.teamB.teamName,
        onPointAwarded: (reason) {
          if (isTeamA) {
            controller.addPointTeamA(reason: reason);
          } else {
            controller.addPointTeamB(reason: reason);
          }
        },
      ),
    );
  }
}
