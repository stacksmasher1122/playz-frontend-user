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

class VolleyballTeamManagementScreen extends StatefulWidget {
  const VolleyballTeamManagementScreen({super.key});

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
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const Icon(Icons.sports_volleyball, color: AppColors.primaryContainer),
            const SizedBox(width: 8),
            Text('MATCH CENTER', style: AppTypography.headlineMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: AppColors.muted),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.surfaceContainerHighest, height: 1.0),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ROSTER MANAGEMENT', style: AppTypography.headlineLg.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        'Configure competing teams, manage player rotations, and assign primary coaches before the match begins.',
                        style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
                      ),
                      const SizedBox(height: 16),
                      TextButton.icon(
                        onPressed: () => controller.importPreviousTeam(),
                        icon: const Icon(Icons.history, color: AppColors.muted, size: 20),
                        label: Text('Import Previous Team', style: AppTypography.bodyMd.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold)),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      Obx(() => PlayerRosterCard(
                        isTeamA: true,
                        team: controller.teamA.value,
                        controller: controller,
                      )),
                      const SizedBox(height: 24),
                      
                      Obx(() => PlayerRosterCard(
                        isTeamA: false,
                        team: controller.teamB.value,
                        controller: controller,
                      )),
                      const SizedBox(height: 24),

                      const BulkActionButtons(),
                      const SizedBox(height: 24),

                      TeamValidationCard(controller: controller),
                      const SizedBox(height: 24),

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
              return const Positioned.fill(child: LoadingWidget());
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
