import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_live_scoring_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Volleyball/rotation_subs/volleyball_rotation_subs_screen.dart';

class BottomActionBar extends StatelessWidget {
  final VolleyballLiveScoringController controller;

  const BottomActionBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.sync,
            label: 'ROTATION & SUBS',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const VolleyballRotationSubsScreen()));
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildActionButton(
            icon: Icons.undo,
            label: 'UNDO',
            onTap: controller.undoLastPoint,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Obx(() => _buildActionButton(
            icon: controller.isPaused.value ? Icons.play_arrow : Icons.pause,
            label: controller.isPaused.value ? 'RESUME' : 'PAUSE',
            onTap: controller.isPaused.value ? controller.resumeMatch : controller.pauseMatch,
          )),
        ),
      ],
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.surfaceContainerHighest),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primaryContainer, size: 32),
            const SizedBox(height: 12),
            Text(label, style: AppTypography.labelCaps10.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          ],
        ),
      ),
    );
  }
}
