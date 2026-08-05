import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/MuayThai/muay_thai_controller.dart';

class MuayThaiActionButtons extends StatelessWidget {
  const MuayThaiActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<MuayThaiController>();

    return Obx(() {
      final isReadOnly = controller.isReadOnly.value;

      final redName = controller.currentMatch.value?.fighterA ?? 'RED Corner';
      final blueName = controller.currentMatch.value?.fighterB ?? 'BLUE Corner';

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
            // 1. ROUND SCORING BUTTONS (10-9 RED, 10-9 BLUE, 10-8 RED, 10-8 BLUE, 10-10 DRAW)
            Text(
              'END OF ROUND JUDGES SCORING (10-MUST)',
              style: const TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.0),
            ),
            SizedBox(height: ResponsiveHelper.h(6)),
            Row(
              children: [
                Expanded(child: _buildBtn(context, label: '10-9 RED', color: const Color(0xFFFF4D4D), onTap: () => controller.scoreRound(10, 9))),
                SizedBox(width: ResponsiveHelper.w(4)),
                Expanded(child: _buildBtn(context, label: '10-9 BLUE', color: const Color(0xFF4D96FF), onTap: () => controller.scoreRound(9, 10))),
                SizedBox(width: ResponsiveHelper.w(4)),
                Expanded(child: _buildBtn(context, label: '10-8 RED', color: const Color(0xFFFF4D4D), onTap: () => controller.scoreRound(10, 8))),
                SizedBox(width: ResponsiveHelper.w(4)),
                Expanded(child: _buildBtn(context, label: '10-8 BLUE', color: const Color(0xFF4D96FF), onTap: () => controller.scoreRound(8, 10))),
                SizedBox(width: ResponsiveHelper.w(4)),
                Expanded(child: _buildBtn(context, label: '10-10 EVEN', color: Colors.amber, onTap: () => controller.scoreRound(10, 10))),
              ],
            ),

            SizedBox(height: ResponsiveHelper.h(10)),

            // 2. KNOCKDOWN (8-COUNT) BUTTONS
            Row(
              children: [
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.flash_on,
                    label: 'KNOCKDOWN (RED)',
                    color: const Color(0xFFFF4D4D),
                    onTap: () => controller.recordKnockdown('fighterA'),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(6)),
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.flash_on,
                    label: 'KNOCKDOWN (BLUE)',
                    color: const Color(0xFF4D96FF),
                    onTap: () => controller.recordKnockdown('fighterB'),
                  ),
                ),
              ],
            ),

            SizedBox(height: ResponsiveHelper.h(8)),

            // 3. STOPPAGE (KO / TKO) & UNDO CONTROLS
            Row(
              children: [
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.dangerous,
                    label: 'KO / TKO STOPPAGE',
                    color: Colors.redAccent,
                    onTap: () => _showStoppageDialog(context, controller, redName, blueName),
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

  void _showStoppageDialog(BuildContext context, MuayThaiController controller, String redName, String blueName) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        backgroundColor: AppColors.cardSurface,
        title: Text(
          'Declare Muay Thai Stoppage Victory',
          style: AppTypography.headlineMd.copyWith(color: AppColors.textPrimary, fontSize: 18).responsive(context),
        ),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(ctx);
              controller.stopMatch('KO (Knockout)', 'fighterA');
            },
            child: Text('RED Corner ($redName) KO Victory', style: const TextStyle(color: Color(0xFFFF4D4D), fontWeight: FontWeight.bold)),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(ctx);
              controller.stopMatch('TKO (Technical Knockout)', 'fighterA');
            },
            child: Text('RED Corner ($redName) TKO Victory', style: const TextStyle(color: Color(0xFFFF4D4D), fontWeight: FontWeight.bold)),
          ),
          const Divider(color: Colors.white10),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(ctx);
              controller.stopMatch('KO (Knockout)', 'fighterB');
            },
            child: Text('BLUE Corner ($blueName) KO Victory', style: const TextStyle(color: Color(0xFF4D96FF), fontWeight: FontWeight.bold)),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(ctx);
              controller.stopMatch('TKO (Technical Knockout)', 'fighterB');
            },
            child: Text('BLUE Corner ($blueName) TKO Victory', style: const TextStyle(color: Color(0xFF4D96FF), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
