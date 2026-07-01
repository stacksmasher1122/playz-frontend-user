import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_initialize_match_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ValidationChecklistCard extends StatelessWidget {
  final VolleyballInitializeMatchController controller;

  ValidationChecklistCard({super.key, required this.controller});

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
          Text('VALIDATION CHECKLIST', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          SizedBox(height: 16),
          Obx(() => Column(
            children: [
              _buildCheckItem('Match Name & Venue', controller.matchName.value.isNotEmpty && controller.venue.value.isNotEmpty),
              SizedBox(height: 12),
              _buildCheckItem('Date & Time Set', controller.date.value.isNotEmpty && controller.time.value.isNotEmpty),
              SizedBox(height: 12),
              _buildCheckItem('Officials Assigned', controller.referee.value.isNotEmpty),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String label, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.circle_outlined,
          color: isValid ? AppColors.primaryContainer : AppColors.muted,
          size: 20,
        ),
        SizedBox(width: 12),
        Text(
          label,
          style: AppTypography.bodyMd.copyWith(
            color: isValid ? AppColors.primary : AppColors.muted,
            decoration: isValid ? TextDecoration.none : TextDecoration.lineThrough,
          ),
        ),
      ],
    );
  }
}
