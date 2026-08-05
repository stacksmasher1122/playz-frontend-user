import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Taekwondo/taekwondo_controller.dart';

class TaekwondoActionButtons extends StatelessWidget {
  const TaekwondoActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<TaekwondoController>();

    return Obx(() {
      final isReadOnly = controller.isReadOnly.value;

      final hongName = controller.currentMatch.value?.hongFighter ?? 'HONG (Red)';
      final chongName = controller.currentMatch.value?.chongFighter ?? 'CHONG (Blue)';

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
            // 1. HONG (RED) SCORING ROW (+1 PUNCH, +2 BODY, +3 HEAD, +4 TURN BODY, +5 TURN HEAD)
            Text(
              'HONG (RED CORNER) SCORING',
              style: const TextStyle(color: Color(0xFFFF4D4D), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.0),
            ),
            SizedBox(height: ResponsiveHelper.h(4)),
            Row(
              children: [
                Expanded(child: _buildBtn(context, label: '+1 PUNCH', color: const Color(0xFFFF4D4D), onTap: () => controller.scorePoints('hong', 1))),
                SizedBox(width: ResponsiveHelper.w(3)),
                Expanded(child: _buildBtn(context, label: '+2 BODY', color: const Color(0xFFFF4D4D), onTap: () => controller.scorePoints('hong', 2))),
                SizedBox(width: ResponsiveHelper.w(3)),
                Expanded(child: _buildBtn(context, label: '+3 HEAD', color: const Color(0xFFFF4D4D), onTap: () => controller.scorePoints('hong', 3))),
                SizedBox(width: ResponsiveHelper.w(3)),
                Expanded(child: _buildBtn(context, label: '+4 TURN B', color: const Color(0xFFFF4D4D), onTap: () => controller.scorePoints('hong', 4))),
                SizedBox(width: ResponsiveHelper.w(3)),
                Expanded(child: _buildBtn(context, label: '+5 TURN H', color: const Color(0xFFFF4D4D), onTap: () => controller.scorePoints('hong', 5))),
              ],
            ),

            SizedBox(height: ResponsiveHelper.h(10)),

            // 2. CHONG (BLUE) SCORING ROW (+1 PUNCH, +2 BODY, +3 HEAD, +4 TURN BODY, +5 TURN HEAD)
            Text(
              'CHONG (BLUE CORNER) SCORING',
              style: const TextStyle(color: Color(0xFF4D96FF), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.0),
            ),
            SizedBox(height: ResponsiveHelper.h(4)),
            Row(
              children: [
                Expanded(child: _buildBtn(context, label: '+1 PUNCH', color: const Color(0xFF4D96FF), onTap: () => controller.scorePoints('chong', 1))),
                SizedBox(width: ResponsiveHelper.w(3)),
                Expanded(child: _buildBtn(context, label: '+2 BODY', color: const Color(0xFF4D96FF), onTap: () => controller.scorePoints('chong', 2))),
                SizedBox(width: ResponsiveHelper.w(3)),
                Expanded(child: _buildBtn(context, label: '+3 HEAD', color: const Color(0xFF4D96FF), onTap: () => controller.scorePoints('chong', 3))),
                SizedBox(width: ResponsiveHelper.w(3)),
                Expanded(child: _buildBtn(context, label: '+4 TURN B', color: const Color(0xFF4D96FF), onTap: () => controller.scorePoints('chong', 4))),
                SizedBox(width: ResponsiveHelper.w(3)),
                Expanded(child: _buildBtn(context, label: '+5 TURN H', color: const Color(0xFF4D96FF), onTap: () => controller.scorePoints('chong', 5))),
              ],
            ),

            SizedBox(height: ResponsiveHelper.h(10)),

            // 3. GAM-JEOM (+1 OPPONENT) PENALTY CHIPS
            Row(
              children: [
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.warning_amber_rounded,
                    label: 'GAM-JEOM (HONG)',
                    color: const Color(0xFFFF4D4D),
                    onTap: () => controller.recordGamJeom('hong'),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(6)),
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.warning_amber_rounded,
                    label: 'GAM-JEOM (CHONG)',
                    color: const Color(0xFF4D96FF),
                    onTap: () => controller.recordGamJeom('chong'),
                  ),
                ),
              ],
            ),

            SizedBox(height: ResponsiveHelper.h(8)),

            // 4. END ROUND, DISQUALIFICATION (PUN) & UNDO CONTROLS
            Row(
              children: [
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.check_circle_outline,
                    label: 'END ROUND',
                    color: AppColors.accent,
                    onTap: () => controller.endRound(),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(6)),
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.report_problem,
                    label: 'PUN (DQ)',
                    color: Colors.redAccent,
                    onTap: () => _showDisqualificationDialog(context, controller, hongName, chongName),
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

  Widget _buildBtn(
    BuildContext context, {
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: AppColors.background,
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(8)),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onTap,
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900),
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

  void _showDisqualificationDialog(BuildContext context, TaekwondoController controller, String hongName, String chongName) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        backgroundColor: AppColors.cardSurface,
        title: Text(
          'Declare Punishment Disqualification (PUN)',
          style: AppTypography.headlineMd.copyWith(color: AppColors.textPrimary, fontSize: 18).responsive(context),
        ),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(ctx);
              controller.recordDisqualification('hong'); // Hong disqualified -> Chong wins
            },
            child: Text('Disqualify HONG (Red) -> Winner: $chongName', style: const TextStyle(color: Color(0xFF4D96FF), fontWeight: FontWeight.bold)),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(ctx);
              controller.recordDisqualification('chong'); // Chong disqualified -> Hong wins
            },
            child: Text('Disqualify CHONG (Blue) -> Winner: $hongName', style: const TextStyle(color: Color(0xFFFF4D4D), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
