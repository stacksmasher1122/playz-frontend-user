import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/common/app_back_button.dart';

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
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: ResponsiveHelper.w(8.0)),
          child: const AppBackButton(),
        ),
        title: Text(
          "Create Tournament",
          style: AppTypography.headlineMd.copyWith(
            color: AppColors.primary,
            fontSize: ResponsiveHelper.sp(18.0),
            fontWeight: FontWeight.w900,
          ).responsive(context),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: ResponsiveHelper.w(12.0)),
            child: InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(20.0)),
              child: Container(
                width: ResponsiveHelper.w(36.0),
                height: ResponsiveHelper.w(36.0),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.card,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.close_rounded,
                  color: AppColors.primaryGreen,
                  size: ResponsiveHelper.w(20.0),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable Form Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(16.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: ResponsiveHelper.h(8.0)),

                      // Progress Header (Step 3 of 5)
                      const ProgressHeader(
                        currentStep: 3,
                        totalSteps: 5,
                        title: "Step 3 of 5: Format Setup",
                      ),
                      SizedBox(height: ResponsiveHelper.h(20.0)),

                      // Section 1: Team Composition & Squad Rules
                      Text(
                        "Team Composition",
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: ResponsiveHelper.sp(16.0),
                          fontWeight: FontWeight.w900,
                        ).responsive(context),
                      ),
                      SizedBox(height: ResponsiveHelper.h(12.0)),
                      TeamCompositionWidget(controller: controller),
                      SizedBox(height: ResponsiveHelper.h(24.0)),

                      // Section 2: Match Format Type
                      Text(
                        "Match Format",
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: ResponsiveHelper.sp(16.0),
                          fontWeight: FontWeight.w900,
                        ).responsive(context),
                      ),
                      SizedBox(height: ResponsiveHelper.h(12.0)),
                      Obx(() => Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: FormatCardWidget(
                                      title: "Knockout",
                                      description: "Single elimination bracket",
                                      icon: Icons.account_tree_rounded,
                                      isSelected:
                                          controller.matchType.value == "knockout",
                                      onTap: () =>
                                          controller.selectMatchType("knockout"),
                                    ),
                                  ),
                                  SizedBox(width: ResponsiveHelper.w(12.0)),
                                  Expanded(
                                    child: FormatCardWidget(
                                      title: "Round Robin (Single)",
                                      description: "Every team plays each other once",
                                      icon: Icons.table_chart_rounded,
                                      isSelected: controller.matchType.value ==
                                          "roundRobinSingle",
                                      onTap: () => controller
                                          .selectMatchType("roundRobinSingle"),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: ResponsiveHelper.h(12.0)),
                              Row(
                                children: [
                                  Expanded(
                                    child: FormatCardWidget(
                                      title: "Round Robin (Double)",
                                      description: "Home & away fixture rounds",
                                      icon: Icons.cached_rounded,
                                      isSelected: controller.matchType.value ==
                                          "roundRobinDouble",
                                      onTap: () => controller
                                          .selectMatchType("roundRobinDouble"),
                                    ),
                                  ),
                                  SizedBox(width: ResponsiveHelper.w(12.0)),
                                  Expanded(
                                    child: FormatCardWidget(
                                      title: "Groups to Knockout",
                                      description: "Group matches then playoffs",
                                      icon: Icons.grid_view_rounded,
                                      isSelected: controller.matchType.value ==
                                          "groupToKnockout",
                                      onTap: () => controller
                                          .selectMatchType("groupToKnockout"),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      SizedBox(height: ResponsiveHelper.h(24.0)),

                      // Section 3: Max No. of Teams Card (Unified single card)
                      Text(
                        "Registration Cap",
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: ResponsiveHelper.sp(16.0),
                          fontWeight: FontWeight.w900,
                        ).responsive(context),
                      ),
                      SizedBox(height: ResponsiveHelper.h(12.0)),
                      Obx(() => ParticipantCounterWidget(
                            title: "MAX NO. OF TEAMS",
                            subtitle: controller.matchType.value == 'knockout'
                                ? "Powers of 2 (4, 8, 16, 32) make clean knockout brackets."
                                : "Registration will lock automatically when limit is reached.",
                            count: controller.maxTeams.value,
                            onIncrement: controller.incrementMaxTeams,
                            onDecrement: controller.decrementMaxTeams,
                            onPresetSelected: controller.setMaxTeams,
                          )),
                      SizedBox(height: ResponsiveHelper.h(24.0)),

                      // Section 4: Match Rules
                      RichText(
                        text: TextSpan(
                          text: "Match Rules ",
                          style: AppTypography.headlineSm.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: ResponsiveHelper.sp(16.0),
                            fontWeight: FontWeight.w900,
                          ).responsive(context),
                          children: [
                            TextSpan(
                              text: "(${controller.selectedSport})",
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.primary,
                                fontSize: ResponsiveHelper.sp(13.0),
                                fontWeight: FontWeight.bold,
                              ).responsive(context),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.h(12.0)),
                      DynamicMatchRulesWidget(controller: controller),
                      SizedBox(height: ResponsiveHelper.h(28.0)),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Navigation (Back & Next Buttons)
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
