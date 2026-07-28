import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/live_pickleball_match_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'statistics_bottom_sheet.dart';

class MoreBottomSheet extends StatelessWidget {
  final LivePickleballMatchController controller;

  MoreBottomSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
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
                  'More',
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
                  icon: Icons.bar_chart,
                  title: 'Statistics',
                  subtitle: 'Live match statistics & analytics',
                  onTap: () {
                    Get.back();
                    Get.bottomSheet(
                      StatisticsBottomSheet(controller: controller),
                      isScrollControlled: true,
                    );
                  },
                ),
                _buildAction(
                  icon: Icons.history,
                  title: 'Timeline',
                  subtitle: 'Point-by-point history log',
                  onTap: () {
                    // Open Timeline
                    Get.back();
                  },
                ),
                _buildAction(
                  icon: Icons.gavel,
                  title: 'Rule Details',
                  subtitle: 'View current active rules profile',
                  onTap: () {
                    Get.back();
                  },
                ),
                _buildAction(
                  icon: Icons.note_alt,
                  title: 'Match Notes',
                  subtitle: 'Add a custom note to the match log',
                  onTap: () {
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
