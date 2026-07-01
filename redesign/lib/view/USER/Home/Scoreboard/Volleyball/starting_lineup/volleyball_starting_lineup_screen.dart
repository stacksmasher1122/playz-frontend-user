import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_team_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_starting_lineup_controller.dart';
import 'widgets/court_widget.dart';
import 'widgets/available_players_list.dart';
import 'widgets/role_assignment_buttons.dart';
import 'widgets/lineup_status_widget.dart';
import 'widgets/confirm_lineup_button.dart';
import 'package:redesign/theme/responsive_helper.dart';

class VolleyballStartingLineupScreen extends StatefulWidget {
  final VolleyballTeamModel teamA;
  final VolleyballTeamModel teamB;

  VolleyballStartingLineupScreen({super.key, required this.teamA, required this.teamB});

  @override
  State<VolleyballStartingLineupScreen> createState() => _VolleyballStartingLineupScreenState();
}

class _VolleyballStartingLineupScreenState extends State<VolleyballStartingLineupScreen> {
  late VolleyballStartingLineupController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(VolleyballStartingLineupController());
    controller.initializeWithTeams(widget.teamA, widget.teamB);
  }

  @override
  void dispose() {
    Get.delete<VolleyballStartingLineupController>();
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
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Icon(Icons.sports_volleyball, color: AppColors.primaryContainer),
            SizedBox(width: 8),
            Text('MATCH CENTER', style: AppTypography.headlineMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: AppColors.muted),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(color: AppColors.surfaceContainerHighest, height: 1.0),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Team Toggle
            Container(
              color: AppColors.surfaceContainerLowest,
              padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(8), horizontal: ResponsiveHelper.w(16)),
              child: Obx(() {
                return Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.toggleTeam(true),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
                          decoration: BoxDecoration(
                            color: controller.isTeamAActive.value ? AppColors.primaryContainer : Colors.transparent,
                            borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                          ),
                          child: Center(
                            child: Text(
                              widget.teamA.teamName,
                              style: AppTypography.bodyMd.copyWith(
                                color: controller.isTeamAActive.value ? AppColors.onPrimaryContainer : AppColors.muted,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.toggleTeam(false),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
                          decoration: BoxDecoration(
                            color: !controller.isTeamAActive.value ? AppColors.primaryContainer : Colors.transparent,
                            borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                          ),
                          child: Center(
                            child: Text(
                              widget.teamB.teamName,
                              style: AppTypography.bodyMd.copyWith(
                                color: !controller.isTeamAActive.value ? AppColors.onPrimaryContainer : AppColors.muted,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0), vertical: ResponsiveHelper.h(16.0)),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 800),
                    child: Obx(() {
                      final currentTeam = controller.currentTeam;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Starting Lineup - ${currentTeam.teamName}', style: AppTypography.headlineLg.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text(
                            'MATCH ID: #FIVB-2024-0812 | ${currentTeam.coachName}',
                            style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold),
                          ),
                          
                          CourtWidget(controller: controller),
                          
                          AvailablePlayersList(controller: controller),
                          SizedBox(height: 24),
                          
                          RoleAssignmentButtons(
                            onAssignCaptain: () {
                              Get.snackbar("Assign Captain", "Tap a player below to assign them as Captain.", 
                                backgroundColor: AppColors.surfaceContainerHigh, colorText: AppColors.primary);
                            },
                            onAssignLibero: () {
                              Get.snackbar("Assign Libero", "Tap a player below to assign them as Libero.", 
                                backgroundColor: AppColors.surfaceContainerHigh, colorText: AppColors.primary);
                            },
                          ),
                          SizedBox(height: 24),
                          
                          LineupStatusWidget(controller: controller),
                          
                          ConfirmLineupButton(
                            onPressed: () => controller.confirmLineup(context),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
