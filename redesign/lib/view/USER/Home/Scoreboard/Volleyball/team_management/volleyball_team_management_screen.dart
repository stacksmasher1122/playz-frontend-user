import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_team_management_controller.dart';
import 'widgets/player_roster_card.dart';
import 'widgets/bulk_action_buttons.dart';
import 'widgets/next_button.dart';
import 'widgets/loading_widget.dart';
import 'package:redesign/theme/responsive_helper.dart';

class VolleyballTeamManagementScreen extends StatefulWidget {
  const VolleyballTeamManagementScreen({super.key});

  @override
  State<VolleyballTeamManagementScreen> createState() =>
      _VolleyballTeamManagementScreenState();
}

class _VolleyballTeamManagementScreenState
    extends State<VolleyballTeamManagementScreen> {
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
      backgroundColor: AppColors.background,
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
            Text(
              'MATCH CENTER',
              style: AppTypography.headlineMd.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(color: AppColors.outlineVariant, height: 1.0),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(16.0),
                vertical: ResponsiveHelper.h(24.0),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ROSTER MANAGEMENT',
                        style: AppTypography.headlineLg.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Configure competing teams, manage player rotations, and assign primary coaches before the match begins.',
                        style: AppTypography.bodyMd.copyWith(
                          color: AppColors.muted,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextButton.icon(
                        onPressed: () => controller.importPreviousTeam(),
                        icon: Icon(
                          Icons.history,
                          color: AppColors.muted,
                          size: 20,
                        ),
                        label: Text(
                          'Import Previous Team',
                          style: AppTypography.bodyMd.copyWith(
                            color: AppColors.muted,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: ResponsiveHelper.h(8),
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                      SizedBox(height: 24),
                      Container(
                        padding: EdgeInsets.all(ResponsiveHelper.w(16)),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.w(16),
                          ),
                          border: Border.all(
                            color: AppColors.outlineVariant.withValues(
                              alpha: 0.4,
                            ),
                          ),
                        ),
                        child: Obx(
                          () => Row(
                            children: [
                              Expanded(
                                child: _buildSummaryTile(
                                  'TEAM A',
                                  '${controller.teamAPlayers.length} players',
                                  controller.teamAReady.value,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: _buildSummaryTile(
                                  'TEAM B',
                                  '${controller.teamBPlayers.length} players',
                                  controller.teamBReady.value,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24),

                      Obx(
                        () => PlayerRosterCard(
                          isTeamA: true,
                          team: controller.teamA.value,
                          controller: controller,
                        ),
                      ),
                      SizedBox(height: 24),

                      Obx(
                        () => PlayerRosterCard(
                          isTeamA: false,
                          team: controller.teamB.value,
                          controller: controller,
                        ),
                      ),
                      SizedBox(height: 24),

                      BulkActionButtons(controller: controller),
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

  Widget _buildSummaryTile(String label, String value, bool ready) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(12),
        vertical: ResponsiveHelper.h(12),
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        border: Border.all(
          color: ready ? AppColors.accent : AppColors.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.labelCaps10.copyWith(
              color: AppColors.muted,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 6),
          Text(
            value,
            style: AppTypography.bodyMd.copyWith(
              color: ready ? AppColors.accent : AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
