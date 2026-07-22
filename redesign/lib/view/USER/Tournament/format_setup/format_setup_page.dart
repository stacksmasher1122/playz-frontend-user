import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

import '../../../../controller/User_Controller/Tournament_Controller/format_setup_controller.dart';
import '../venue_selection/widgets/bottom_navigation.dart';
import '../venue_selection/widgets/progress_header.dart';
import 'widgets/format_card_widget.dart';
import 'widgets/dynamic_match_rules_widget.dart';
import 'widgets/team_composition_widget.dart';
import 'widgets/participant_counter_widget.dart';

class FormatSetupPage extends StatefulWidget {
  const FormatSetupPage({super.key});

  @override
  State<FormatSetupPage> createState() => _FormatSetupPageState();
}

class _FormatSetupPageState extends State<FormatSetupPage> {
  late final FormatSetupController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(FormatSetupController());
  }

  @override
  void dispose() {
    Get.delete<FormatSetupController>();
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
          icon: Icon(Icons.arrow_back, color: AppColors.onPrimary, size: ResponsiveHelper.w(24)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Create Tournament",
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.accent,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: AppColors.onPrimary, size: ResponsiveHelper.w(24)),
            onPressed: () => Navigator.pop(context), // Should typically close flow
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
            // Scrollable Content
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
                        currentStep: 3,
                        totalSteps: 5,
                        title: "Step 3 of 5: Format Setup",
                      ),
                      SizedBox(height: ResponsiveHelper.h(32)),

                      // Section 1: Team Composition
                      Text(
                        "Team Composition",
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.onPrimary,
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.h(12)),
                      TeamCompositionWidget(controller: controller),
                      SizedBox(height: ResponsiveHelper.h(32)),

                      // Section 2: Match Type
                      Text(
                        "Match Type",
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.onPrimary,
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.h(12)),
                      Obx(() => Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: FormatCardWidget(
                                  title: "Knockout",
                                  description: "Single elimination.",
                                  icon: Icons.account_tree,
                                  isSelected: controller.matchType.value == "knockout",
                                  onTap: () => controller.selectMatchType("knockout"),
                                ),
                              ),
                              SizedBox(width: ResponsiveHelper.w(16)),
                              Expanded(
                                child: FormatCardWidget(
                                  title: "Round Robin (Single)",
                                  description: "Play everyone once.",
                                  icon: Icons.table_chart,
                                  isSelected: controller.matchType.value == "roundRobinSingle",
                                  onTap: () => controller.selectMatchType("roundRobinSingle"),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: ResponsiveHelper.h(16)),
                          Row(
                            children: [
                              Expanded(
                                child: FormatCardWidget(
                                  title: "Round Robin (Double)",
                                  description: "Play everyone twice.",
                                  icon: Icons.cached,
                                  isSelected: controller.matchType.value == "roundRobinDouble",
                                  onTap: () => controller.selectMatchType("roundRobinDouble"),
                                ),
                              ),
                              SizedBox(width: ResponsiveHelper.w(16)),
                              Expanded(
                                child: FormatCardWidget(
                                  title: "Groups to Knockout",
                                  description: "Group stage then playoffs.",
                                  icon: Icons.grid_view,
                                  isSelected: controller.matchType.value == "groupToKnockout",
                                  onTap: () => controller.selectMatchType("groupToKnockout"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                      SizedBox(height: ResponsiveHelper.h(32)),

                      // Section 3: Number of Participants/Teams
                      Text(
                        "Expected Number of Participants/Teams",
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.onPrimary,
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.h(12)),
                      Obx(() => ParticipantCounterWidget(
                        title: "Expected Participants",
                        subtitle: "Will be used to estimate schedule",
                        count: controller.participantCount.value,
                        onIncrement: controller.incrementParticipants,
                        onDecrement: controller.decrementParticipants,
                      )),
                      SizedBox(height: ResponsiveHelper.h(24)),
                      Text(
                        "Registration Cap (Max Teams)",
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.onPrimary,
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.h(12)),
                      Obx(() => ParticipantCounterWidget(
                        title: "Max Teams Allowed",
                        subtitle: controller.matchType.value == 'knockout'
                            ? "Hint: Powers of 2 (4, 8, 16) make clean knockout brackets."
                            : "Registration will lock automatically when this is reached.",
                        count: controller.maxTeams.value,
                        onIncrement: controller.incrementMaxTeams,
                        onDecrement: controller.decrementMaxTeams,
                      )),
                      SizedBox(height: ResponsiveHelper.h(32)),

                      // Section 4: Match Rules
                      RichText(
                        text: TextSpan(
                          text: "Match Rules ",
                          style: AppTypography.headlineSm.copyWith(
                            color: AppColors.onPrimary,
                          ),
                          children: [
                            TextSpan(
                              text: "(${controller.selectedSport})",
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.muted,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.h(12)),
                      DynamicMatchRulesWidget(controller: controller),
                      SizedBox(height: ResponsiveHelper.h(32)),
                    ],
                  ),
                ),
              ),
            ),
            
            // Bottom Navigation
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
