import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/pickleball_team_management_controller.dart';
import 'widgets/team_management_appbar.dart';
import 'widgets/team_header_widget.dart';
import 'widgets/mode_selector.dart';
import 'widgets/team_section.dart';
import 'widgets/player_actions.dart';
import 'widgets/bottom_next_button.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PickleballTeamManagementScreen extends StatefulWidget {
  PickleballTeamManagementScreen({super.key});

  @override
  State<PickleballTeamManagementScreen> createState() => _PickleballTeamManagementScreenState();
}

class _PickleballTeamManagementScreenState extends State<PickleballTeamManagementScreen> with SingleTickerProviderStateMixin {
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
      backgroundColor: AppColors.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(16))),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(ResponsiveHelper.w(16.0)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: ResponsiveHelper.w(40), height: ResponsiveHelper.h(4), decoration: BoxDecoration(color: AppColors.muted, borderRadius: BorderRadius.circular(ResponsiveHelper.w(2)))),
                SizedBox(height: 16),
                PlayerActions(
                  onCreate: controller.createPlayer,
                  onSelect: () => controller.selectExistingPlayer(team, slot),
                  onImport: controller.importTournamentPlayer,
                ),
              ],
            ),
          ),
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
        child: FadeTransition(
          opacity: _sectionFadeController,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(ResponsiveHelper.w(16.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TeamHeaderWidget(),
                SizedBox(height: 24),
                Center(
                  child: Obx(() => ModeSelector(
                    isSingles: controller.isSingles.value,
                    onChanged: controller.changeMode,
                  )),
                ),
                SizedBox(height: 32),
                Obx(() => TeamSection(
                  isTeamA: true,
                  players: controller.teamAPlayers,
                  maxPlayers: controller.maxPlayersPerTeam,
                  onRemove: (index) => controller.removePlayer(1, index),
                  onEmptySlotTap: (slot) => _showPlayerSelectionSheet(1, slot),
                )),
                SizedBox(height: 24),
                Obx(() => TeamSection(
                  isTeamA: false,
                  players: controller.teamBPlayers,
                  maxPlayers: controller.maxPlayersPerTeam,
                  onRemove: (index) => controller.removePlayer(2, index),
                  onEmptySlotTap: (slot) => _showPlayerSelectionSheet(2, slot),
                )),
                SizedBox(height: 32),
                // These global action buttons trigger selection for the active empty slot or Team B as fallback.
                PlayerActions(
                  onCreate: () {
                    int defaultTeam = controller.teamAPlayers.length < controller.maxPlayersPerTeam ? 1 : 2;
                    controller.selectPlayer(defaultTeam, 0);
                    controller.createPlayer();
                  },
                  onSelect: () {
                    int defaultTeam = controller.teamAPlayers.length < controller.maxPlayersPerTeam ? 1 : 2;
                    _showPlayerSelectionSheet(defaultTeam, 0);
                  },
                  onImport: () {
                    int defaultTeam = controller.teamAPlayers.length < controller.maxPlayersPerTeam ? 1 : 2;
                    controller.selectPlayer(defaultTeam, 0);
                    controller.importTournamentPlayer();
                  },
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNextButton(
        onTap: () => controller.goNext(context),
      ),
    );
  }
}
