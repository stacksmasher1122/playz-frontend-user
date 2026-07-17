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
import 'package:redesign/theme/responsive_helper.dart';

class VolleyballFinalReviewScreen extends StatefulWidget {
  final VolleyballTeamModel teamA;
  final VolleyballTeamModel teamB;

  VolleyballFinalReviewScreen({super.key, required this.teamA, required this.teamB});

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
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: Color(0xFF111111),
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
            Text('MATCH REVIEW', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: AppColors.muted),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(color: AppColors.outlineVariant, height: 1.0),
        ),
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return Center(child: CircularProgressIndicator(color: AppColors.accent));
        }

        return SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0), vertical: ResponsiveHelper.h(24.0)),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 800),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Final Review', style: AppTypography.headlineLg.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text(
                            'Verify all match configurations before initiating the official clock.',
                            style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
                          ),
                          SizedBox(height: 24),
                          
                          MatchSummaryCard(reviewData: controller.reviewData),
                          SizedBox(height: 24),
                          
                          RegulationSummaryCard(reviewData: controller.reviewData),
                          SizedBox(height: 24),
                          
                          ValidationCard(controller: controller),
                          SizedBox(height: 24),
                          
                          OfficialCard(reviewData: controller.reviewData),
                          SizedBox(height: 24),
                          
                          SystemStatusCard(
                            icon: Icons.bar_chart,
                            title: 'Data Stream',
                            status: SystemStatus.connected,
                          ),
                          SystemStatusCard(
                            icon: Icons.monitor,
                            title: 'Hardware',
                            status: SystemStatus.ready,
                          ),
                          SystemStatusCard(
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
