import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/live_pickleball_match_controller.dart';
import 'widgets/live_match_appbar.dart';
import 'widgets/match_header_widget.dart';
import 'widgets/live_scoreboard_card.dart';
import 'widgets/score_button_widget.dart';
import 'widgets/point_classification_bottom_sheet.dart';
import 'widgets/match_controls_widget.dart';
import 'widgets/match_actions_bottom_sheet.dart';
import 'widgets/more_bottom_sheet.dart';
import 'widgets/bottom_end_match_button.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LivePickleballMatchScreen extends StatefulWidget {
  LivePickleballMatchScreen({super.key});

  @override
  State<LivePickleballMatchScreen> createState() =>
      _LivePickleballMatchScreenState();
}

class _LivePickleballMatchScreenState extends State<LivePickleballMatchScreen>
    with TickerProviderStateMixin {
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
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.w(16.0),
            vertical: ResponsiveHelper.h(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MatchHeaderWidget(controller: controller),
              SizedBox(height: 24),
              LiveScoreboardCard(
                controller: controller,
                glowController: _glowController,
                pulseController: _pulseController,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => ScoreButtonWidget(
                        teamName: controller.teamAName.value.toUpperCase(),
                        isActive: controller.isServingTeamA.value,
                        onTap: () => _showPointClassification(
                          context,
                          controller.teamAName.value,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Obx(
                      () => ScoreButtonWidget(
                        teamName: controller.teamBName.value.toUpperCase(),
                        isActive: !controller.isServingTeamA.value,
                        onTap: () => _showPointClassification(
                          context,
                          controller.teamBName.value,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              MatchControlsWidget(
                onUndo: controller.undoPoint,
                onMatchActions: () => _showMatchActions(context),
                onMore: () => _showMore(context),
              ),
              SizedBox(height: 16),
              BottomEndMatchButton(onTap: () => controller.endMatch(context)),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showPointClassification(BuildContext context, String teamName) {
    Get.bottomSheet(
      PointClassificationBottomSheet(
        controller: controller,
        teamName: teamName,
      ),
      isScrollControlled: true,
    );
  }

  void _showMatchActions(BuildContext context) {
    Get.bottomSheet(
      MatchActionsBottomSheet(controller: controller),
      isScrollControlled: true,
    );
  }

  void _showMore(BuildContext context) {
    Get.bottomSheet(
      MoreBottomSheet(controller: controller),
      isScrollControlled: true,
    );
  }
}
