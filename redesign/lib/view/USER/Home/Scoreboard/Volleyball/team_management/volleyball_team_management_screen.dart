import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_team_management_controller.dart';
import 'widgets/player_roster_card.dart';
import 'widgets/bulk_action_buttons.dart';
import 'widgets/team_validation_card.dart';
import 'widgets/next_button.dart';
import 'widgets/loading_widget.dart';
import 'package:redesign/theme/responsive_helper.dart';

class VolleyballTeamManagementScreen extends StatefulWidget {
  VolleyballTeamManagementScreen({super.key});

  @override
  State<VolleyballTeamManagementScreen> createState() => _VolleyballTeamManagementScreenState();
}

class _VolleyballTeamManagementScreenState extends State<VolleyballTeamManagementScreen> {
  late VolleyballTeamManagementController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(VolleyballTeamManagementController());
  }

  @override
  void dispose() {
    Get.delete<VolleyballTeamManagementController>();
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
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Icon(Icons.sports_volleyball, color: AppColors.accent),
            SizedBox(width: 8),
            Text('MATCH CENTER', style: AppTypography.headlineMd.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
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
          child: Container(color: AppColors.outlineVariant, height: 1.0),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0), vertical: ResponsiveHelper.h(24.0)),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ROSTER MANAGEMENT', style: AppTypography.headlineLg.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text(
                        'Configure competing teams, manage player rotations, and assign primary coaches before the match begins.',
                        style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
                      ),
                      SizedBox(height: 16),
                      TextButton.icon(
                        onPressed: () => controller.importPreviousTeam(),
                        icon: Icon(Icons.history, color: AppColors.muted, size: 20),
                        label: Text('Import Previous Team', style: AppTypography.bodyMd.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold)),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(8)),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                      SizedBox(height: 32),
                      
                      Obx(() => PlayerRosterCard(
                        isTeamA: true,
                        team: controller.teamA.value,
                        controller: controller,
                      )),
                      SizedBox(height: 24),
                      
                      Obx(() => PlayerRosterCard(
                        isTeamA: false,
                        team: controller.teamB.value,
                        controller: controller,
                      )),
                      SizedBox(height: 24),

                      BulkActionButtons(),
                      SizedBox(height: 24),

                      TeamValidationCard(controller: controller),
                      SizedBox(height: 24),

                      NextButton(
                        onPressed: () => controller.goToNextScreen(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Obx(() {
            if (controller.loading.value) {
              return Positioned.fill(child: LoadingWidget());
            }
            return SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
