import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/live_scoring_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LsQuickActionGridWidget extends StatelessWidget {
  LsQuickActionGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<LiveScoringController>();

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildActionBtn('ACE', Icons.bolt, AppColors.accent, controller.recordAce)),
            SizedBox(width: 16),
            Expanded(child: _buildActionBtn('WINNER', Icons.star_border, AppColors.accent, controller.recordWinner)),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildActionBtn('FAULT', Icons.warning_amber_rounded, AppColors.error, controller.recordFault)),
            SizedBox(width: 16),
            Expanded(child: _buildActionBtn('UNFORCED', Icons.close, AppColors.error, controller.recordUnforcedError)),
          ],
        ),
      ],
    );
  }

  Widget _buildActionBtn(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(24)),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            SizedBox(height: 12),
            Text(label, style: AppTypography.labelCaps.copyWith(color: AppColors.accent, letterSpacing: 2.0)),
          ],
        ),
      ),
    );
  }
}
