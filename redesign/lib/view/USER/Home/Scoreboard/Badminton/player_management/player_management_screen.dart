import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Badminton/player_management_controller.dart';
import 'widgets/player_management_appbar.dart';
import 'widgets/match_summary_card.dart';
import 'widgets/match_rules_header.dart';
import 'widgets/games_slider_widget.dart';
import 'widgets/points_stepper_widget.dart';
import 'widgets/rule_info_card.dart';
import 'widgets/warmup_slider_widget.dart';
import 'widgets/start_match_button_widget.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PlayerManagementScreen extends StatefulWidget {
  PlayerManagementScreen({super.key});

  @override
  State<PlayerManagementScreen> createState() => _PlayerManagementScreenState();
}

class _PlayerManagementScreenState extends State<PlayerManagementScreen> {
  late final PlayerManagementController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(PlayerManagementController());
    controller.loadPlayers();
    controller.loadRules();
  }

  @override
  void dispose() {
    Get.delete<PlayerManagementController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: Colors.black, // fallback if AppColors.background is not used
      appBar: PlayerManagementAppbar(),
      body: SingleChildScrollView(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(ResponsiveHelper.w(32.0)),
                child: CircularProgressIndicator(color: Color(0xFFC6FF00)),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MatchSummaryCard(
                playerOne: controller.playerOne.value,
                playerTwo: controller.playerTwo.value,
                totalGames: controller.totalGames.value,
              ),
              MatchRulesHeader(),
              GamesSliderWidget(
                totalGames: controller.totalGames.value,
                onChanged: controller.updateNumberOfGames,
              ),
              PointsStepperWidget(
                points: controller.pointsPerGame.value,
                onIncrement: controller.incrementPoints,
                onDecrement: controller.decrementPoints,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(24.0), vertical: ResponsiveHelper.h(12.0)),
                child: Row(
                  children: [
                    Expanded(
                      child: RuleInfoCard(
                        label: 'SIDE CHANGE',
                        value: controller.sideChangePoint.value,
                        subtitle: 'At Mid-Game',
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: RuleInfoCard(
                        label: 'INTERVALS',
                        value: controller.intervalDuration.value,
                        subtitle: 'Auto-Pause',
                      ),
                    ),
                  ],
                ),
              ),
              WarmupSliderWidget(
                warmupDuration: controller.warmupDuration.value,
                onChanged: controller.updateWarmupDuration,
              ),
              SizedBox(height: 24), // Space before sticky bottom
            ],
          );
        }),
      ),
      bottomNavigationBar: SafeArea(
        child: StartMatchButtonWidget(
          onTap: () => controller.startMatch(context),
        ),
      ),
    );
  }
}
