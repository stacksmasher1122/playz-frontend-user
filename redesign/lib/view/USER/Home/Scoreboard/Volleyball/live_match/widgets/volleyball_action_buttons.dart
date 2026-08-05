import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_controller.dart';

class VolleyballActionButtons extends StatelessWidget {
  const VolleyballActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<VolleyballController>();

    return Obx(() {
      final isStarted = controller.isMatchStarted.value;
      final homeName = controller.currentMatch.value?.homeTeam ?? 'Side A';
      final awayName = controller.currentMatch.value?.awayTeam ?? 'Side B';

      return Column(
        children: [
          // 1. START MATCH NOW BUTTON
          if (!isStarted)
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(16),
                vertical: ResponsiveHelper.h(8),
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
                  ),
                  elevation: 6,
                ),
                onPressed: () => controller.startMatch(),
                icon: const Icon(Icons.play_arrow_rounded, size: 24, color: Colors.black),
                label: Text(
                  'START MATCH NOW',
                  style: AppTypography.headlineSm.copyWith(
                    fontSize: ResponsiveHelper.sp(15),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ).responsive(context),
                ),
              ),
            ),

          SizedBox(height: ResponsiveHelper.h(10)),

          // 2. PRIMARY RALLY SCORING BUTTONS (+1 POINT)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
            child: Row(
              children: [
                // Side A +1 Point
                Expanded(
                  child: _buildPointButton(
                    context,
                    label: '+1 POINT ($homeName)',
                    accentColor: AppColors.accent,
                    isEnabled: isStarted && !controller.isReadOnly.value,
                    onTap: () => controller.scorePoint('sideA'),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(12)),
                // Side B +1 Point
                Expanded(
                  child: _buildPointButton(
                    context,
                    label: '+1 POINT ($awayName)',
                    accentColor: const Color(0xFF4D96FF),
                    isEnabled: isStarted && !controller.isReadOnly.value,
                    onTap: () => controller.scorePoint('sideB'),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: ResponsiveHelper.h(16)),

          // 3. SECONDARY CONTROLS (SERVE TOGGLE, TIMEOUT, UNDO)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
            child: Row(
              children: [
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.sports_volleyball,
                    label: 'SERVE ⇄',
                    color: Colors.amber,
                    onTap: () => controller.toggleServingTeam(),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(6)),
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.timer_outlined,
                    label: 'TIMEOUT',
                    color: AppColors.warning,
                    onTap: () => _showTimeoutDialog(context, controller, homeName, awayName),
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
          ),

          SizedBox(height: ResponsiveHelper.h(16)),
        ],
      );
    });
  }

  Widget _buildPointButton(
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

  void _showTimeoutDialog(BuildContext context, VolleyballController controller, String homeName, String awayName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Call 30s Timeout',
          style: AppTypography.headlineMd.copyWith(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              tileColor: Colors.white.withValues(alpha: 0.05),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              leading: const Icon(Icons.timer_outlined, color: AppColors.accent),
              title: Text(
                'Timeout for $homeName',
                style: AppTypography.bodyMd.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(ctx);
                controller.useTimeout('sideA');
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              tileColor: Colors.white.withValues(alpha: 0.05),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              leading: const Icon(Icons.timer_outlined, color: Color(0xFF4D96FF)),
              title: Text(
                'Timeout for $awayName',
                style: AppTypography.bodyMd.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(ctx);
                controller.useTimeout('sideB');
              },
            ),
          ],
        ),
      ),
    );
  }
}
