import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/live_scoring_controller.dart';

class LsQuickActionGridWidget extends StatelessWidget {
  const LsQuickActionGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LiveScoringController>();

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildActionBtn('ACE', Icons.bolt, AppColors.primaryContainer, controller.recordAce)),
            const SizedBox(width: 16),
            Expanded(child: _buildActionBtn('WINNER', Icons.star_border, AppColors.primaryContainer, controller.recordWinner)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildActionBtn('FAULT', Icons.warning_amber_rounded, AppColors.error, controller.recordFault)),
            const SizedBox(width: 16),
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
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(label, style: AppTypography.labelCaps.copyWith(color: AppColors.primary, letterSpacing: 2.0)),
          ],
        ),
      ),
    );
  }
}
