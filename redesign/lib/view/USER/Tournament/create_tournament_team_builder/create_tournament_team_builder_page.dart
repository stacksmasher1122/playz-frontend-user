import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

import '../../../../controller/User_Controller/Tournament_Controller/team_builder_controller.dart';
import '../venue_selection/widgets/bottom_navigation.dart';
import '../venue_selection/widgets/progress_header.dart';
import 'widget/add_team_bottom_sheet.dart';
import 'widget/add_team_button.dart';
import 'widget/team_card_widget.dart';

class CreateTournamentTeamBuilderPage extends StatefulWidget {
  const CreateTournamentTeamBuilderPage({super.key});

  @override
  State<CreateTournamentTeamBuilderPage> createState() => _CreateTournamentTeamBuilderPageState();
}

class _CreateTournamentTeamBuilderPageState extends State<CreateTournamentTeamBuilderPage> {
  late final TeamBuilderController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(TeamBuilderController());
  }

  @override
  void dispose() {
    Get.delete<TeamBuilderController>();
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
          icon: Icon(Icons.arrow_back, color: AppColors.muted, size: ResponsiveHelper.w(24)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Create Tournament",
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.accent,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: AppColors.muted, size: ResponsiveHelper.w(24)),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: AppColors.card,
            height: 1.0,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: ResponsiveHelper.h(16)),
                      const ProgressHeader(
                        currentStep: 5,
                        totalSteps: 6,
                        title: "STEP 5 OF 6: TEAM & SQUAD BUILDER",
                      ),
                      SizedBox(height: ResponsiveHelper.h(32)),

                      // Top Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() => Text(
                                "Teams (${controller.teams.length}/${controller.maxTeams})",
                                style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary),
                              )),
                            AddTeamButton(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => AddTeamBottomSheet(
                                    onAdd: controller.addTeam,
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                      SizedBox(height: ResponsiveHelper.h(12)),

                      // Dynamic Team List
                      Obx(() {
                        return Column(
                          children: controller.teams.map((team) {
                            return TeamCardWidget(
                              team: team,
                              controller: controller,
                            );
                          }).toList(),
                        );
                      }),
                      SizedBox(height: ResponsiveHelper.h(32)),
                    ],
                  ),
                ),
              ),
            ),
            BottomNavigation(
              onBack: () => controller.goBack(context),
              onNext: () => controller.goNext(context),
            ),
          ],
        ),
      ),
    );
  }
}
