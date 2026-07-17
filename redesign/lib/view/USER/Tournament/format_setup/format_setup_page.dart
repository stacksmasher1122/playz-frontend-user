import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

import '../../../../controller/User_Controller/Tournament_Controller/format_setup_controller.dart';
import '../venue_selection/widgets/bottom_navigation.dart';
import '../venue_selection/widgets/progress_header.dart';
import 'widgets/format_card_widget.dart';
import 'widgets/match_rules_widget.dart';
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
                        totalSteps: 6,
                        title: "Step 3 of 6: Format Setup",
                      ),
                      SizedBox(height: ResponsiveHelper.h(32)),

                      // Section 1: Number of Teams
                      Text(
                        "Number of Teams",
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.onPrimary,
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.h(12)),
                      Obx(() => ParticipantCounterWidget(
                        count: controller.participantCount.value,
                        onIncrement: controller.incrementParticipants,
                        onDecrement: controller.decrementParticipants,
                      )),
                      SizedBox(height: ResponsiveHelper.h(32)),

                      // Section 2: Format Cards
                      Text(
                        "Tournament Format",
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.onPrimary,
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.h(12)),
                      Obx(() => Row(
                        children: [
                          Expanded(
                            child: FormatCardWidget(
                              title: "Knockout",
                              description: "Single elimination bracket. Loser goes home.",
                              icon: Icons.account_tree,
                              isSelected: controller.selectedFormat.value == "Knockout",
                              onTap: () => controller.selectFormat("Knockout"),
                            ),
                          ),
                          SizedBox(width: ResponsiveHelper.w(16)),
                          Expanded(
                            child: FormatCardWidget(
                              title: "League",
                              description: "Round-robin format. Everyone plays everyone.",
                              icon: Icons.table_chart,
                              isSelected: controller.selectedFormat.value == "League",
                              onTap: () => controller.selectFormat("League"),
                            ),
                          ),
                        ],
                      )),
                      SizedBox(height: ResponsiveHelper.h(16)),
                      Obx(() => FormatCardWidget(
                        title: "Groups to Knockout",
                        description: "World Cup style. Group stage followed by playoffs.",
                        icon: Icons.grid_view,
                        isSelected: controller.selectedFormat.value == "Groups",
                        onTap: () => controller.selectFormat("Groups"),
                        isFullWidth: true,
                      )),
                      SizedBox(height: ResponsiveHelper.h(32)),

                      // Section 3: Match Rules
                      RichText(
                        text: TextSpan(
                          text: "Match Rules ",
                          style: AppTypography.headlineSm.copyWith(
                            color: AppColors.onPrimary,
                          ),
                          children: [
                            TextSpan(
                              text: "(Football)",
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.muted,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.h(12)),
                      Obx(() => MatchRulesWidget(
                        halfLengthOptions: controller.halfLengthOptions,
                        selectedHalfLength: controller.halfLength.value,
                        onHalfLengthChanged: controller.updateHalfLength,
                        extraTimeEnabled: controller.extraTime.value,
                        onExtraTimeChanged: controller.toggleExtraTime,
                        penaltiesEnabled: controller.penalties.value,
                        onPenaltiesChanged: controller.togglePenalties,
                      )),
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
