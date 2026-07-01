import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_team_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_final_review_controller.dart';
import 'widgets/match_summary_card.dart';
import 'widgets/regulation_summary_card.dart';
import 'widgets/validation_card.dart';
import 'widgets/official_card.dart';
import 'widgets/system_status_card.dart';
import 'widgets/status_chip.dart';
import 'widgets/action_buttons.dart';

class VolleyballFinalReviewScreen extends StatefulWidget {
  final VolleyballTeamModel teamA;
  final VolleyballTeamModel teamB;

  const VolleyballFinalReviewScreen({super.key, required this.teamA, required this.teamB});

  @override
  State<VolleyballFinalReviewScreen> createState() => _VolleyballFinalReviewScreenState();
}

class _VolleyballFinalReviewScreenState extends State<VolleyballFinalReviewScreen> {
  late VolleyballFinalReviewController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(VolleyballFinalReviewController());
    controller.loadMatchReview(widget.teamA, widget.teamB);
  }

  @override
  void dispose() {
    Get.delete<VolleyballFinalReviewController>();
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
            Text('MATCH REVIEW', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
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
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryContainer));
        }

        return SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Final Review', style: AppTypography.headlineLg.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(
                            'Verify all match configurations before initiating the official clock.',
                            style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
                          ),
                          const SizedBox(height: 24),
                          
                          MatchSummaryCard(reviewData: controller.reviewData),
                          const SizedBox(height: 24),
                          
                          RegulationSummaryCard(reviewData: controller.reviewData),
                          const SizedBox(height: 24),
                          
                          ValidationCard(controller: controller),
                          const SizedBox(height: 24),
                          
                          OfficialCard(reviewData: controller.reviewData),
                          const SizedBox(height: 24),
                          
                          const SystemStatusCard(
                            icon: Icons.bar_chart,
                            title: 'Data Stream',
                            status: SystemStatus.connected,
                          ),
                          const SystemStatusCard(
                            icon: Icons.monitor,
                            title: 'Hardware',
                            status: SystemStatus.ready,
                          ),
                          const SystemStatusCard(
                            icon: Icons.cloud_off,
                            title: 'Cloud Sync',
                            status: SystemStatus.offline,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              ActionButtons(
                onEdit: () => controller.goBack(context),
                onStart: () => controller.startMatch(context),
              ),
            ],
          ),
        );
      }),
    );
  }
}
