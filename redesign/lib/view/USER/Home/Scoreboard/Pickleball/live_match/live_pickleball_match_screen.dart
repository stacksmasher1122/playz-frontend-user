import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/live_pickleball_match_controller.dart';
import 'widgets/live_match_appbar.dart';
import 'widgets/match_header_widget.dart';
import 'widgets/live_scoreboard_card.dart';
import 'widgets/score_button_widget.dart';
import 'widgets/match_controls_widget.dart';
import 'widgets/performance_card.dart';
import 'widgets/bottom_end_match_button.dart';
import 'widgets/live_bottom_navigation.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LivePickleballMatchScreen extends StatefulWidget {
  LivePickleballMatchScreen({super.key});

  @override
  State<LivePickleballMatchScreen> createState() => _LivePickleballMatchScreenState();
}

class _LivePickleballMatchScreenState extends State<LivePickleballMatchScreen> with TickerProviderStateMixin {
  late final LivePickleballMatchController controller;
  late AnimationController _pulseController;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(LivePickleballMatchController());
    controller.initialize();
    
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);
    
    _glowController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    Get.delete<LivePickleballMatchController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: LiveMatchAppbar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0), vertical: ResponsiveHelper.h(8.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MatchHeaderWidget(controller: controller),
              SizedBox(height: 24),
              Obx(() => LiveScoreboardCard(
                scoreA: controller.teamAScore.value,
                scoreB: controller.teamBScore.value,
                isServingTeamA: controller.isServingTeamA.value,
                glowController: _glowController,
                pulseController: _pulseController,
              )),
              SizedBox(height: 20),
              Obx(() => Row(
                children: [
                  Expanded(
                    child: ScoreButtonWidget(
                      teamName: 'TEAM A',
                      isActive: controller.isServingTeamA.value,
                      onTap: controller.increaseTeamAScore,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ScoreButtonWidget(
                      teamName: 'TEAM B',
                      isActive: !controller.isServingTeamA.value,
                      onTap: controller.increaseTeamBScore,
                    ),
                  ),
                ],
              )),
              SizedBox(height: 20),
              Obx(() => MatchControlsWidget(
                onUndo: controller.undoPoint,
                onTimeout: controller.startTimeout,
                onPause: () => controller.isPaused.value ? controller.resumeMatch() : controller.pauseMatch(),
                isPaused: controller.isPaused.value,
              )),
              SizedBox(height: 24),
              PerformanceCard(controller: controller),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomEndMatchButton(
            onTap: () => controller.endMatch(context),
          ),
          Obx(() => LiveBottomNavigation(
            selectedIndex: controller.selectedTabIndex.value,
            onTabSelected: controller.selectTab,
          )),
        ],
      ),
    );
  }
}
