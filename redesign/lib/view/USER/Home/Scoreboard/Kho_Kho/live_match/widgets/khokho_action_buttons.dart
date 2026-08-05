import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Kho_Kho/khokho_controller.dart';

class KhoKhoActionButtons extends StatelessWidget {
  const KhoKhoActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<KhoKhoController>();

    return Obx(() {
      final isReadOnly = controller.isReadOnly.value;
      final state = controller.liveState.value;

      final chasingTeamName = state?.activeChasingTeam == 'sideA'
          ? (controller.currentMatch.value?.homeTeam ?? 'Side A')
          : (controller.currentMatch.value?.awayTeam ?? 'Side B');

      final defendingTeamName = state?.activeChasingTeam == 'sideA'
          ? (controller.currentMatch.value?.awayTeam ?? 'Side B')
          : (controller.currentMatch.value?.homeTeam ?? 'Side A');

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
            // 1. PRIMARY SCORING BUTTONS (+1 OUT & POLE DIVE +2)
            Row(
              children: [
                // Standard Defender Out (+1 pt)
                Expanded(
                  flex: 3,
                  child: _buildActionButton(
                    context,
                    label: '+1 OUT ($chasingTeamName)',
                    accentColor: AppColors.accent,
                    isEnabled: !isReadOnly,
                    onTap: () => controller.scoreOut(isPoleDive: false),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(8)),
                // Pole Dive / Sky Dive (+2 pts)
                Expanded(
                  flex: 2,
                  child: _buildActionButton(
                    context,
                    label: 'POLE DIVE (+2)',
                    accentColor: const Color(0xFFFF6B6B),
                    isEnabled: !isReadOnly,
                    onTap: () => controller.scoreOut(isPoleDive: true),
                  ),
                ),
              ],
            ),

            SizedBox(height: ResponsiveHelper.h(12)),

            // 2. SECONDARY CONTROLS (DREAM RUN +1, NEXT TURN, UNDO)
            Row(
              children: [
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.shield_outlined,
                    label: 'DREAM RUN (+1 $defendingTeamName)',
                    color: Colors.amber,
                    onTap: () => controller.awardDreamRun(),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(6)),
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.timer_outlined,
                    label: 'NEXT TURN',
                    color: AppColors.accent,
                    onTap: () => controller.advanceTurn(),
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
