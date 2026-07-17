import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_live_scoring_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Volleyball/rotation_subs/volleyball_rotation_subs_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BottomActionBar extends StatelessWidget {
  final VolleyballLiveScoringController controller;

  BottomActionBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.sync,
            label: 'ROTATION & SUBS',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => VolleyballRotationSubsScreen()));
            },
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _buildActionButton(
            icon: Icons.undo,
            label: 'UNDO',
            onTap: controller.undoLastPoint,
          ),
        ),
        SizedBox(width: 8),
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
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(24)),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.accent, size: 32),
            SizedBox(height: 12),
            Text(label, style: AppTypography.labelCaps10.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          ],
        ),
      ),
    );
  }
}
