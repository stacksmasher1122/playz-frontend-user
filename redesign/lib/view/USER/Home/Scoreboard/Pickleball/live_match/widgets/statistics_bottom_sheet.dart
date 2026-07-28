import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/live_pickleball_match_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class StatisticsBottomSheet extends StatelessWidget {
  final LivePickleballMatchController controller;

  StatisticsBottomSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveHelper.w(24)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(ResponsiveHelper.w(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Live Statistics',
                  style: AppTypography.headlineSm.copyWith(color: AppColors.accent),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: AppColors.muted),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
          Divider(color: AppColors.outlineVariant),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(ResponsiveHelper.w(16)),
              child: Obx(
                () => Column(
                  children: [
                    _buildStatRow('Points', controller.teamAScore.value.toString(), controller.teamBScore.value.toString(), isHighlight: true),
                    _buildStatRow('Winners', controller.winnersA.value.toString(), controller.winnersB.value.toString()),
                    _buildStatRow('Forced Errors', controller.forcedErrorsA.value.toString(), controller.forcedErrorsB.value.toString()),
                    _buildStatRow('Unforced Errors', controller.unforcedErrorsA.value.toString(), controller.unforcedErrorsB.value.toString()),
                    _buildStatRow('Aces', controller.acesA.value.toString(), controller.acesB.value.toString()),
                    _buildStatRow('Faults', controller.faultsA.value.toString(), controller.faultsB.value.toString()),
                    SizedBox(height: 24),
                    Text('RALLY STATS', style: AppTypography.labelCaps.copyWith(color: AppColors.muted)),
                    SizedBox(height: 12),
                    _buildStatRow('Average Rally', '${controller.rallyLengthAvg.value} shots', '${controller.rallyLengthAvg.value} shots', isSingle: true),
                    _buildStatRow('Longest Rally', '${controller.longestRally.value} shots', '${controller.longestRally.value} shots', isSingle: true),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String valA, String valB, {bool isHighlight = false, bool isSingle = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!isSingle)
            Expanded(
              flex: 2,
              child: Text(
                valA,
                textAlign: TextAlign.left,
                style: isHighlight ? AppTypography.headlineSm.copyWith(color: AppColors.accent) : AppTypography.bodyLg,
              ),
            ),
          Expanded(
            flex: 3,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTypography.labelCaps.copyWith(color: AppColors.muted),
            ),
          ),
          if (!isSingle)
            Expanded(
              flex: 2,
              child: Text(
                valB,
                textAlign: TextAlign.right,
                style: isHighlight ? AppTypography.headlineSm.copyWith(color: AppColors.accent) : AppTypography.bodyLg,
              ),
            ),
          if (isSingle)
            Expanded(
              flex: 4,
              child: Text(
                valA,
                textAlign: TextAlign.right,
                style: isHighlight ? AppTypography.headlineSm.copyWith(color: AppColors.accent) : AppTypography.bodyLg,
              ),
            ),
        ],
      ),
    );
  }
}
