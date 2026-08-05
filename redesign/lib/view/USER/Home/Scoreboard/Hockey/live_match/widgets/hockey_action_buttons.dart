import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Hockey/hockey_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Hockey/hockey_state_models.dart';

class HockeyActionButtons extends StatelessWidget {
  const HockeyActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<HockeyController>();

    return Obx(() {
      final homeName = controller.currentMatch.value?.homeTeam ?? 'Side A';
      final awayName = controller.currentMatch.value?.awayTeam ?? 'Side B';
      final isReadOnly = controller.isReadOnly.value;

      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.w(16),
          vertical: ResponsiveHelper.h(12),
        ),
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. PRIMARY SCORING BUTTONS (+1 GOAL)
            Row(
              children: [
                // Side A +1 Goal
                Expanded(
                  child: _buildGoalButton(
                    context,
                    label: '+1 GOAL ($homeName)',
                    accentColor: AppColors.accent,
                    isEnabled: !isReadOnly,
                    onTap: () => _openGoalTypeDialog(context, controller, 'sideA', homeName),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(12)),
                // Side B +1 Goal
                Expanded(
                  child: _buildGoalButton(
                    context,
                    label: '+1 GOAL ($awayName)',
                    accentColor: const Color(0xFF4D96FF),
                    isEnabled: !isReadOnly,
                    onTap: () => _openGoalTypeDialog(context, controller, 'sideB', awayName),
                  ),
                ),
              ],
            ),

            SizedBox(height: ResponsiveHelper.h(12)),

            // 2. SECONDARY CONTROLS (PENALTY CORNER, NEXT PERIOD, UNDO)
            Row(
              children: [
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.sports_hockey,
                    label: 'PENALTY CORNER',
                    color: Colors.amber,
                    onTap: () => _openPCDialog(context, controller, homeName, awayName),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(6)),
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.timer_outlined,
                    label: 'NEXT PERIOD',
                    color: AppColors.accent,
                    onTap: () => controller.advancePeriod(),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(6)),
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.undo,
                    label: 'UNDO',
                    color: AppColors.textSecondary,
                    onTap: () => controller.undoLastAction(),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildGoalButton(
    BuildContext context, {
    required String label,
    required Color accentColor,
    required bool isEnabled,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled ? accentColor : Colors.white10,
        foregroundColor: isEnabled ? Colors.black : AppColors.mutedText,
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(14)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
        ),
      ),
      onPressed: isEnabled ? onTap : null,
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.headlineSm.copyWith(
          fontSize: ResponsiveHelper.sp(13),
          fontWeight: FontWeight.w900,
        ).responsive(context),
      ),
    );
  }

  Widget _buildActionChip({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.w(6),
          vertical: ResponsiveHelper.h(8),
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16),
            SizedBox(width: ResponsiveHelper.w(4)),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.labelCaps.copyWith(
                  color: color,
                  fontSize: ResponsiveHelper.sp(10),
                  fontWeight: FontWeight.bold,
                ).responsive(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openGoalTypeDialog(BuildContext context, HockeyController controller, String team, String teamName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Select Goal Type ($teamName)',
          style: AppTypography.headlineMd.copyWith(color: AppColors.textPrimary, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Field Goal (FG)', style: AppTypography.bodyMd.copyWith(color: AppColors.textPrimary)),
              onTap: () {
                Navigator.pop(ctx);
                controller.scoreGoal(team, goalType: GoalType.fieldGoal);
              },
            ),
            ListTile(
              title: Text('Penalty Corner (PC)', style: AppTypography.bodyMd.copyWith(color: AppColors.textPrimary)),
              onTap: () {
                Navigator.pop(ctx);
                controller.scoreGoal(team, goalType: GoalType.penaltyCorner);
              },
            ),
            ListTile(
              title: Text('Penalty Stroke (PS)', style: AppTypography.bodyMd.copyWith(color: AppColors.textPrimary)),
              onTap: () {
                Navigator.pop(ctx);
                controller.scoreGoal(team, goalType: GoalType.penaltyStroke);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openPCDialog(BuildContext context, HockeyController controller, String homeName, String awayName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Award Penalty Corner',
          style: AppTypography.headlineMd.copyWith(color: AppColors.textPrimary, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Penalty Corner for $homeName', style: AppTypography.bodyMd.copyWith(color: AppColors.textPrimary)),
              onTap: () {
                Navigator.pop(ctx);
                controller.addPenaltyCorner('sideA');
              },
            ),
            ListTile(
              title: Text('Penalty Corner for $awayName', style: AppTypography.bodyMd.copyWith(color: AppColors.textPrimary)),
              onTap: () {
                Navigator.pop(ctx);
                controller.addPenaltyCorner('sideB');
              },
            ),
          ],
        ),
      ),
    );
  }
}
