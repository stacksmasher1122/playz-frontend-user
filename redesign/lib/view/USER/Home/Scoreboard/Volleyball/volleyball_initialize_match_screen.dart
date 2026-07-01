import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_initialize_match_controller.dart';
import 'widgets/match_information_card.dart';
import 'widgets/match_category_selector.dart';
import 'widgets/match_format_selector.dart';
import 'widgets/rule_configuration_card.dart';
import 'widgets/match_summary_card.dart';
import 'widgets/validation_checklist_card.dart';
import 'widgets/initialize_match_button.dart';
import 'widgets/loading_widget.dart';
import 'package:redesign/theme/responsive_helper.dart';

class VolleyballInitializeMatchScreen extends StatefulWidget {
  VolleyballInitializeMatchScreen({super.key});

  @override
  State<VolleyballInitializeMatchScreen> createState() => _VolleyballInitializeMatchScreenState();
}

class _VolleyballInitializeMatchScreenState extends State<VolleyballInitializeMatchScreen> {
  late VolleyballInitializeMatchController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(VolleyballInitializeMatchController());
  }

  @override
  void dispose() {
    Get.delete<VolleyballInitializeMatchController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: Color(0xFF111111), // As requested background
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: Icon(Icons.sports_volleyball, color: AppColors.primaryContainer),
        title: Text('PlayZ', style: AppTypography.headlineMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: AppColors.muted),
            onPressed: () {},
          ),
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
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0), vertical: ResponsiveHelper.h(24.0)),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 800), // Max width for tablet/web
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Create Match', style: AppTypography.headlineLg.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text(
                        'Configure match parameters and officiating rules for the upcoming session.',
                        style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
                      ),
                      SizedBox(height: 32),
                      
                      MatchInformationCard(controller: controller),
                      SizedBox(height: 24),
                      
                      MatchCategorySelector(
                        selectedCategory: controller.category,
                        onSelect: controller.selectCategory,
                      ),
                      SizedBox(height: 24),
                      
                      MatchFormatSelector(
                        selectedFormat: controller.format,
                        onSelect: controller.selectMatchFormat,
                      ),
                      SizedBox(height: 24),
                      
                      RuleConfigurationCard(controller: controller),
                      SizedBox(height: 24),

                      MatchSummaryCard(controller: controller),
                      SizedBox(height: 24),

                      ValidationChecklistCard(controller: controller),
                      SizedBox(height: 24),

                      InitializeMatchButton(
                        onPressed: () => controller.initializeMatch(context),
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
