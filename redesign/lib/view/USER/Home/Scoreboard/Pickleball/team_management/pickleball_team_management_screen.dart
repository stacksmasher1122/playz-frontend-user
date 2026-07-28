import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/pickleball_team_management_controller.dart';
import 'widgets/team_management_appbar.dart';
import 'widgets/mode_selector.dart';
import 'widgets/interactive_match_arena.dart';
import 'widgets/player_creation_sheet.dart';
import 'widgets/head_to_head_card.dart';
import 'widgets/sticky_bottom_action_panel.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PickleballTeamManagementScreen extends StatefulWidget {
  PickleballTeamManagementScreen({super.key});

  @override
  State<PickleballTeamManagementScreen> createState() =>
      _PickleballTeamManagementScreenState();
}

class _PickleballTeamManagementScreenState
    extends State<PickleballTeamManagementScreen>
    with SingleTickerProviderStateMixin {
  late final PickleballTeamManagementController controller;
  late AnimationController _sectionFadeController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(PickleballTeamManagementController());
    controller.initialize();

    _sectionFadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _sectionFadeController.forward();
  }

  @override
  void dispose() {
    _sectionFadeController.dispose();
    Get.delete<PickleballTeamManagementController>();
    super.dispose();
  }

  void _showPlayerSelectionSheet(int team, int slot) {
    controller.selectPlayer(team, slot);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return PlayerCreationSheet(
          teamIndex: team,
          controller: controller,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: TeamManagementAppbar(),
      body: SafeArea(
        child: Stack(
          children: [
            FadeTransition(
              opacity: _sectionFadeController,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  ResponsiveHelper.w(16.0),
                  ResponsiveHelper.w(16.0),
                  ResponsiveHelper.w(16.0),
                  ResponsiveHelper.h(200), // padding for sticky bottom panel
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    Center(
                      child: Obx(
                        () => ModeSelector(
                          isSingles: controller.isSingles.value,
                          onChanged: controller.changeMode,
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    InteractiveMatchArena(
                      controller: controller,
                      onSlotTap: _showPlayerSelectionSheet,
                    ),
                    SizedBox(height: 48),
                    HeadToHeadCard(controller: controller),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: StickyBottomActionPanel(controller: controller),
            ),
          ],
        ),
      ),
    );
  }
}
