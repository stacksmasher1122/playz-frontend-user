import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/pickleball_match_history_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/live_pickleball_match_model.dart';

class PickleballMatchHistoryScreen extends StatelessWidget {
  PickleballMatchHistoryScreen({super.key});

  final controller = Get.put(PickleballMatchHistoryController());

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'MATCH HISTORY',
          style: AppTypography.headlineSm.copyWith(color: AppColors.textPrimary),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: AppColors.accent));
        }

        if (controller.matches.isEmpty) {
          return Center(
            child: Text(
              "No match history found.",
              style: AppTypography.bodyLg.copyWith(color: AppColors.muted),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(ResponsiveHelper.w(16)),
          itemCount: controller.matches.length,
          itemBuilder: (context, index) {
            final match = controller.matches[index];
            return _buildMatchCard(match);
          },
        );
      }),
    );
  }

  Widget _buildMatchCard(LivePickleballMatchModel match) {
    bool isLive = match.status == "LIVE";

    return GestureDetector(
      onTap: () => controller.resumeMatch(match),
      child: Container(
        margin: EdgeInsets.only(bottom: ResponsiveHelper.h(16)),
        padding: EdgeInsets.all(ResponsiveHelper.w(16)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  match.game,
                  style: AppTypography.labelCaps10.copyWith(color: AppColors.muted),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isLive ? AppColors.accent.withOpacity(0.1) : AppColors.card,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isLive ? "RESUME" : "COMPLETED",
                    style: AppTypography.labelCaps10.copyWith(
                      color: isLive ? AppColors.accent : AppColors.muted,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.h(16)),
            Row(
              children: [
                Expanded(
                  child: Text(
                    match.teamA,
                    style: AppTypography.bodyLg,
                  ),
                ),
                Text(
                  "\${match.scoreA}",
                  style: AppTypography.headlineSm.copyWith(color: AppColors.accent),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
                  child: Text("-", style: AppTypography.bodyLg),
                ),
                Text(
                  "\${match.scoreB}",
                  style: AppTypography.headlineSm.copyWith(color: AppColors.accent),
                ),
                Expanded(
                  child: Text(
                    match.teamB,
                    textAlign: TextAlign.right,
                    style: AppTypography.bodyLg,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
