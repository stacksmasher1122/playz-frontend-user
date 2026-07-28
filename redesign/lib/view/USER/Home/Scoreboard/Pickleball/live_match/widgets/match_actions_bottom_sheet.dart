import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/live_pickleball_match_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchActionsBottomSheet extends StatelessWidget {
  final LivePickleballMatchController controller;

  MatchActionsBottomSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    bool isPro = controller.rules.profileName == "Professional Tournament";

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
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
                  'Match Actions',
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
            child: ListView(
              padding: EdgeInsets.all(ResponsiveHelper.w(16)),
              children: [
                _buildAction(
                  icon: Icons.timer,
                  title: 'Standard Timeout',
                  subtitle: 'Team A: \${controller.teamATimeoutsUsed} | Team B: \${controller.teamBTimeoutsUsed}',
                  onTap: () {
                    controller.startTimeout();
                    Get.back();
                  },
                ),
                if (isPro || controller.rules.medicalTimeoutEnabled)
                  _buildAction(
                    icon: Icons.medical_services,
                    title: 'Medical Timeout',
                    onTap: () {
                      controller.startTimeout();
                      Get.back();
                    },
                  ),
                if (isPro || controller.rules.equipmentTimeoutEnabled)
                  _buildAction(
                    icon: Icons.build,
                    title: 'Equipment Timeout',
                    onTap: () {
                      controller.startTimeout();
                      Get.back();
                    },
                  ),
                _buildAction(
                  icon: Icons.swap_horiz,
                  title: 'Manual Side Change',
                  onTap: () {
                    // Logic to swap sides
                    Get.back();
                  },
                ),
                _buildAction(
                  icon: controller.isPaused.value ? Icons.play_arrow : Icons.pause,
                  title: controller.isPaused.value ? 'Resume Match' : 'Suspend Match',
                  onTap: () {
                    controller.isPaused.value ? controller.resumeMatch() : controller.pauseMatch();
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAction({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveHelper.h(16),
          horizontal: ResponsiveHelper.w(12),
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.outlineVariant, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.accent, size: ResponsiveHelper.w(24)),
            SizedBox(width: ResponsiveHelper.w(16)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.bodyMd),
                if (subtitle != null)
                  Text(subtitle, style: AppTypography.labelCaps10.copyWith(color: AppColors.muted)),
              ],
            ),
            Spacer(),
            Icon(Icons.chevron_right, color: AppColors.muted),
          ],
        ),
      ),
    );
  }
}
