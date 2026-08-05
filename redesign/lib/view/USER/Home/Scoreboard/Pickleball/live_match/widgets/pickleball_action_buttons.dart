import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/pickleball_controller.dart';

class PickleballActionButtons extends StatelessWidget {
  const PickleballActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<PickleballController>();

    return Obx(() {
      final isReadOnly = controller.isReadOnly.value;
      final state = controller.liveState.value;

      final homeName = controller.currentMatch.value?.homeTeam ?? 'Side A';
      final awayName = controller.currentMatch.value?.awayTeam ?? 'Side B';

      final servingTeamName = state?.servingSide == 'sideA' ? homeName : awayName;

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
            // 1. PRIMARY SCORING BUTTONS (+1 POINT FOR SIDE A & SIDE B)
            Row(
              children: [
                // Side A Point
                Expanded(
                  child: _buildActionButton(
                    context,
                    label: '+1 POINT ($homeName)',
                    accentColor: AppColors.accent,
                    isEnabled: !isReadOnly,
                    onTap: () => controller.scorePoint('sideA'),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(12)),
                // Side B Point
                Expanded(
                  child: _buildActionButton(
                    context,
                    label: '+1 POINT ($awayName)',
                    accentColor: const Color(0xFF4D96FF),
                    isEnabled: !isReadOnly,
                    onTap: () => controller.scorePoint('sideB'),
                  ),
                ),
              ],
            ),

            SizedBox(height: ResponsiveHelper.h(12)),

            // 2. SECONDARY CONTROLS (FAULT / SIDEOUT & UNDO)
            Row(
              children: [
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.error_outline,
                    label: 'FAULT / SIDEOUT ($servingTeamName)',
                    color: Colors.amber,
                    onTap: () => controller.registerFault(),
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

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required Color accentColor,
    required bool isEnabled,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled ? accentColor : Colors.white10,
        foregroundColor: isEnabled ? AppColors.background : AppColors.mutedText,
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
          fontSize: ResponsiveHelper.sp(12),
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
}
