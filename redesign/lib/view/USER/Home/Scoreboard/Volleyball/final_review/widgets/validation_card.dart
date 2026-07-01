import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_final_review_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ValidationCard extends StatelessWidget {
  final VolleyballFinalReviewController controller;

  ValidationCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: AppColors.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.checklist, color: AppColors.muted, size: 16),
              SizedBox(width: 8),
              Text('STATUS CHECK', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, letterSpacing: 1.5)),
            ],
          ),
          SizedBox(height: 16),
          Obx(() => _buildCheckItem('Team A Lineup Validated', controller.teamAReady.value)),
          SizedBox(height: 12),
          Obx(() => _buildCheckItem('Team B Lineup Validated', controller.teamBReady.value)),
          SizedBox(height: 12),
          Obx(() => _buildCheckItem('Official Table Ready', controller.officialReady.value)),
          SizedBox(height: 12),
          Obx(() => _buildCheckItem('Match Configuration Valid', controller.configurationValid.value)),
          SizedBox(height: 12),
          Obx(() => _buildCheckItem('Rotation Verified', controller.rotationReady.value)),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String label, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle_outline : Icons.error_outline,
          color: isValid ? AppColors.primaryContainer : AppColors.error,
          size: 20,
        ),
        SizedBox(width: 12),
        Text(
          label,
          style: AppTypography.bodyMd.copyWith(
            color: isValid ? AppColors.primary : AppColors.error,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
