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
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
            size: context.responsiveFont(20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "Create Tournament",
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.accent,
              fontSize: context.responsiveFont(18),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.close_rounded,
              color: AppColors.textPrimary,
              size: context.responsiveFont(22),
            ),
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
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: context.heightPct(2)),
                      const ProgressHeader(
                        currentStep: 3,
                        totalSteps: 5,
                        title: "Step 3 of 5: Format Setup",
                      ),
                      SizedBox(height: context.heightPct(3)),

                      // Section 1: Team Composition
                      Text(
                        "Team Composition",
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: context.responsiveFont(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: context.heightPct(1.5)),
                      TeamCompositionWidget(controller: controller),
                      SizedBox(height: context.heightPct(3)),

                      // Section 2: Match Type
                      Text(
                        "Match Type",
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: context.responsiveFont(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: context.heightPct(1.5)),
                      Obx(() => Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: FormatCardWidget(
                                  title: "Knockout",
                                  description: "Single elimination.",
                                  icon: Icons.account_tree_rounded,
                                  isSelected: controller.matchType.value == "knockout",
                                  onTap: () => controller.selectMatchType("knockout"),
                                ),
                              ),
                              SizedBox(width: context.widthPct(3)),
                              Expanded(
                                child: FormatCardWidget(
                                  title: "Round Robin (Single)",
                                  description: "Play everyone once.",
                                  icon: Icons.table_chart_rounded,
                                  isSelected: controller.matchType.value == "roundRobinSingle",
                                  onTap: () => controller.selectMatchType("roundRobinSingle"),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: context.heightPct(1.5)),
                          Row(
                            children: [
                              Expanded(
                                child: FormatCardWidget(
                                  title: "Round Robin (Double)",
                                  description: "Play everyone twice.",
                                  icon: Icons.cached_rounded,
                                  isSelected: controller.matchType.value == "roundRobinDouble",
                                  onTap: () => controller.selectMatchType("roundRobinDouble"),
                                ),
                              ),
                              SizedBox(width: context.widthPct(3)),
                              Expanded(
                                child: FormatCardWidget(
                                  title: "Groups to Knockout",
                                  description: "Group stage then playoffs.",
                                  icon: Icons.grid_view_rounded,
                                  isSelected: controller.matchType.value == "groupToKnockout",
                                  onTap: () => controller.selectMatchType("groupToKnockout"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                      SizedBox(height: context.heightPct(3)),

                      // Section 3: Number of Participants/Teams
                      Text(
                        "Expected Number of Participants/Teams",
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: context.responsiveFont(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: context.heightPct(1.5)),
                      Obx(() => ParticipantCounterWidget(
                        title: "Expected Participants",
                        subtitle: "Will be used to estimate schedule",
                        count: controller.participantCount.value,
                        onIncrement: controller.incrementParticipants,
                        onDecrement: controller.decrementParticipants,
                      )),
                      SizedBox(height: context.heightPct(2)),
                      Text(
                        "Registration Cap (Max Teams)",
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: context.responsiveFont(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: context.heightPct(1.5)),
                      Obx(() => ParticipantCounterWidget(
                        title: "Max Teams Allowed",
                        subtitle: controller.matchType.value == 'knockout'
                            ? "Hint: Powers of 2 (4, 8, 16) make clean knockout brackets."
                            : "Registration will lock automatically when this is reached.",
                        count: controller.maxTeams.value,
                        onIncrement: controller.incrementMaxTeams,
                        onDecrement: controller.decrementMaxTeams,
                      )),
                      SizedBox(height: context.heightPct(3)),

                      // Section 4: Match Rules
                      RichText(
                        text: TextSpan(
                          text: "Match Rules ",
                          style: AppTypography.headlineSm.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: context.responsiveFont(16),
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: "(${controller.selectedSport})",
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.muted,
                                fontSize: context.responsiveFont(13),
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: context.heightPct(1.5)),
                      DynamicMatchRulesWidget(controller: controller),
                      SizedBox(height: context.heightPct(3)),
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
