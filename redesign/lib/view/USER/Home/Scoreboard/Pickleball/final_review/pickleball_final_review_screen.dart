import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/pickleball_final_review_controller.dart';
import 'widgets/final_review_appbar.dart';
import 'widgets/final_review_header.dart';
import 'widgets/teams_vs_card.dart';
import 'widgets/match_stats_grid.dart';
import 'widgets/advanced_settings_card.dart';
import 'widgets/start_match_button.dart';

class PickleballFinalReviewScreen extends StatefulWidget {
  const PickleballFinalReviewScreen({super.key});

  @override
  State<PickleballFinalReviewScreen> createState() => _PickleballFinalReviewScreenState();
}

class _PickleballFinalReviewScreenState extends State<PickleballFinalReviewScreen> with SingleTickerProviderStateMixin {
  late final PickleballFinalReviewController controller;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    controller = Get.put(PickleballFinalReviewController());
    controller.loadReviewData();
    
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    Get.delete<PickleballFinalReviewController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const FinalReviewAppbar(),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FinalReviewHeader(),
                const SizedBox(height: 24),
                Obx(() => TeamsVsCard(
                  reviewData: controller.reviewData.value,
                  onEditTeams: () => controller.editTeams(context),
                )),
                const SizedBox(height: 24),
                Obx(() => MatchStatsGrid(
                  reviewData: controller.reviewData.value,
                )),
                const SizedBox(height: 24),
                Obx(() => AdvancedSettingsCard(
                  reviewData: controller.reviewData.value,
                )),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Obx(() => StartMatchButton(
        isStarting: controller.isStarting.value,
        onTap: () => controller.startMatch(context),
      )),
    );
  }
}
