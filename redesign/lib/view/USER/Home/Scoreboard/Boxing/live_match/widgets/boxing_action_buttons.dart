import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Boxing/boxing_controller.dart';

class BoxingActionButtons extends StatelessWidget {
  const BoxingActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<BoxingController>();

    return Obx(() {
      final isReadOnly = controller.isReadOnly.value;
      final state = controller.liveState.value;

      final fAName = controller.currentMatch.value?.fighterA ?? 'Red Corner';
      final fBName = controller.currentMatch.value?.fighterB ?? 'Blue Corner';

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
            // 1. PRIMARY SCORING BUTTONS (+1 POINT FOR RED CORNER / BLUE CORNER)
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    label: '+1 POINT ($fAName)',
                    accentColor: const Color(0xFFFF4D4D),
                    isEnabled: !isReadOnly,
                    onTap: () => controller.addPoint('fighterA'),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(12)),
                Expanded(
                  child: _buildActionButton(
                    context,
                    label: '+1 POINT ($fBName)',
                    accentColor: const Color(0xFF4D96FF),
                    isEnabled: !isReadOnly,
                    onTap: () => controller.addPoint('fighterB'),
                  ),
                ),
              ],
            ),

            SizedBox(height: ResponsiveHelper.h(10)),

            // 2. KNOCKDOWN & FOUL DEDUCTION BUTTONS
            Row(
              children: [
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.sports_mma,
                    label: 'KD RED (+2)',
                    color: const Color(0xFFFF4D4D),
                    onTap: () => controller.recordKnockdown('fighterB'),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(6)),
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.sports_mma,
                    label: 'KD BLUE (+2)',
                    color: const Color(0xFF4D96FF),
                    onTap: () => controller.recordKnockdown('fighterA'),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(6)),
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.warning_amber_rounded,
                    label: 'FOUL RED (-1)',
                    color: Colors.orangeAccent,
                    onTap: () => controller.recordFoul('fighterA'),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(6)),
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.warning_amber_rounded,
                    label: 'FOUL BLUE (-1)',
                    color: Colors.orangeAccent,
                    onTap: () => controller.recordFoul('fighterB'),
                  ),
                ),
              ],
            ),

            SizedBox(height: ResponsiveHelper.h(8)),

            // 3. END ROUND, STOPPAGE & UNDO CONTROLS
            Row(
              children: [
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.timer,
                    label: 'END ROUND ${state != null ? state.currentRoundIndex + 1 : 1}',
                    color: AppColors.accent,
                    onTap: () => controller.completeRound(),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(6)),
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.report_problem,
                    label: 'STOPPAGE (KO/TKO)',
                    color: Colors.redAccent,
                    onTap: () => _showStoppageDialog(context, controller, fAName, fBName),
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

  void _showStoppageDialog(BuildContext context, BoxingController controller, String nameA, String nameB) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        backgroundColor: AppColors.cardSurface,
        title: Text(
          'Select Stoppage Outcome',
          style: AppTypography.headlineMd.copyWith(color: AppColors.textPrimary, fontSize: 18).responsive(context),
        ),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(ctx);
              controller.stopMatch('KO (Knockout)', 'fighterA');
            },
            child: Text('KO Winner: $nameA', style: const TextStyle(color: Color(0xFFFF4D4D), fontWeight: FontWeight.bold)),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(ctx);
              controller.stopMatch('KO (Knockout)', 'fighterB');
            },
            child: Text('KO Winner: $nameB', style: const TextStyle(color: Color(0xFF4D96FF), fontWeight: FontWeight.bold)),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(ctx);
              controller.stopMatch('TKO (Technical Knockout)', 'fighterA');
            },
            child: Text('TKO Winner: $nameA', style: const TextStyle(color: Color(0xFFFF4D4D), fontWeight: FontWeight.bold)),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(ctx);
              controller.stopMatch('TKO (Technical Knockout)', 'fighterB');
            },
            child: Text('TKO Winner: $nameB', style: const TextStyle(color: Color(0xFF4D96FF), fontWeight: FontWeight.bold)),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(ctx);
              controller.stopMatch('Disqualification (DQ)', 'fighterA');
            },
            child: const Text('DQ Winner: Red Corner', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
