import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_rotation_subs_controller.dart';
import 'substitution_bottom_sheet.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ActionButtonsRow extends StatelessWidget {
  final VolleyballRotationSubsController controller;

  ActionButtonsRow({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildButton(context, Icons.sync, 'SIDE-OUT', AppColors.accent, Colors.black, controller.performSideOut)),
            SizedBox(width: 16),
            Expanded(child: _buildButton(context, Icons.person_add_alt, 'SUBSTITUTE', AppColors.card, AppColors.accent, () => _openSubsSheet(context))),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildButton(context, Icons.timer_outlined, 'TIMEOUT', AppColors.card, AppColors.accent, controller.requestTimeout)),
            SizedBox(width: 16),
            Expanded(child: _buildButton(context, Icons.undo, 'UNDO', AppColors.error, Colors.white, controller.undoLastAction)),
          ],
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context, IconData icon, String label, Color bgColor, Color textColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      child: Container(
        height: ResponsiveHelper.h(64),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
          border: Border.all(color: bgColor == AppColors.accent ? Colors.transparent : AppColors.outlineVariant),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 20),
            SizedBox(width: 8),
            Text(label, style: AppTypography.labelCaps10.copyWith(color: textColor, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          ],
        ),
      ),
    );
  }

  void _openSubsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: SubstitutionBottomSheet(controller: controller),
      ),
    );
  }
}
