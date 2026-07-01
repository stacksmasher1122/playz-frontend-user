import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_initialize_match_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchSummaryCard extends StatelessWidget {
  final VolleyballInitializeMatchController controller;

  MatchSummaryCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(24)),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withOpacity(0.8),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
        border: Border.all(color: AppColors.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('MATCH SUMMARY', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          SizedBox(height: 16),
          Obx(() => Column(
            children: [
              _buildSummaryRow('Format', controller.format.value == 'B3' ? 'Best of 3' : controller.format.value == 'B5' ? 'Best of 5' : 'Custom'),
              _buildSummaryRow('Category', controller.category.value),
              _buildSummaryRow('Points Per Set', '${controller.pointsPerSet.value} pts'),
              _buildSummaryRow('Final Set', '${controller.finalSetPoints.value} pts'),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(8.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMd.copyWith(color: AppColors.muted)),
          Text(value, style: AppTypography.bodyMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
