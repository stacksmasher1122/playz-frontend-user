import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Judo/judo_controller.dart';

class JudoActionButtons extends StatelessWidget {
  const JudoActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<JudoController>();

    return Obx(() {
      final isReadOnly = controller.isReadOnly.value;
      final isOsaekomiActive = controller.liveState.value?.isOsaekomiActive ?? false;

      final whiteName = controller.currentMatch.value?.whiteFighter ?? 'WHITE Corner';
      final blueName = controller.currentMatch.value?.blueFighter ?? 'BLUE Corner';

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
            // 1. PRIMARY SCORING BUTTONS (IPPON / WAZA-ARI FOR WHITE & BLUE)
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              context,
                              label: 'IPPON',
                              accentColor: const Color(0xFFE0E0E0),
                              textColor: Colors.black,
                              isEnabled: !isReadOnly,
                              onTap: () => controller.scoreIppon('white'),
                            ),
                          ),
                          SizedBox(width: ResponsiveHelper.w(4)),
                          Expanded(
                            child: _buildActionButton(
                              context,
                              label: 'WAZA-ARI',
                              accentColor: const Color(0xFFE0E0E0),
                              textColor: Colors.black,
                              isEnabled: !isReadOnly,
                              onTap: () => controller.scoreWazaAri('white'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveHelper.h(4)),
                      Text(
                        whiteName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Color(0xFFE0E0E0), fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(10)),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              context,
                              label: 'IPPON',
                              accentColor: const Color(0xFF4D96FF),
                              textColor: Colors.white,
                              isEnabled: !isReadOnly,
                              onTap: () => controller.scoreIppon('blue'),
                            ),
                          ),
                          SizedBox(width: ResponsiveHelper.w(4)),
                          Expanded(
                            child: _buildActionButton(
                              context,
                              label: 'WAZA-ARI',
                              accentColor: const Color(0xFF4D96FF),
                              textColor: Colors.white,
                              isEnabled: !isReadOnly,
                              onTap: () => controller.scoreWazaAri('blue'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveHelper.h(4)),
                      Text(
                        blueName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Color(0xFF4D96FF), fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: ResponsiveHelper.h(10)),

            // 2. OSAEKOMI (HOLD-DOWN) & TOKETA (BREAK) CONTROLS
            if (isOsaekomiActive) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.stop_circle_outlined, size: 20),
                  label: const Text('TOKETA (RELEASE / BREAK)', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                  onPressed: () => controller.stopOsaekomiToketa(),
                ),
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: _buildActionChip(
                      context: context,
                      icon: Icons.timer,
                      label: 'OSAEKOMI (WHITE)',
                      color: const Color(0xFFE0E0E0),
                      onTap: () => controller.startOsaekomi('white'),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.w(6)),
                  Expanded(
                    child: _buildActionChip(
                      context: context,
                      icon: Icons.timer,
                      label: 'OSAEKOMI (BLUE)',
                      color: const Color(0xFF4D96FF),
                      onTap: () => controller.startOsaekomi('blue'),
                    ),
                  ),
                ],
              ),
            ],

            SizedBox(height: ResponsiveHelper.h(8)),

            // 3. SHIDO PENALTIES & DISQUALIFICATION & UNDO CONTROLS
            Row(
              children: [
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.warning_amber_rounded,
                    label: 'SHIDO (WHITE)',
                    color: const Color(0xFFE0E0E0),
                    onTap: () => controller.recordShido('white'),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(4)),
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.warning_amber_rounded,
                    label: 'SHIDO (BLUE)',
                    color: const Color(0xFF4D96FF),
                    onTap: () => controller.recordShido('blue'),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(4)),
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.report_problem,
                    label: 'HANSOKU (DQ)',
                    color: Colors.redAccent,
                    onTap: () => _showHansokuDialog(context, controller, whiteName, blueName),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(4)),
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
    required Color textColor,
    required bool isEnabled,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled ? accentColor : Colors.white10,
        foregroundColor: isEnabled ? textColor : AppColors.mutedText,
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(10)),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
        ),
      ),
      onPressed: isEnabled ? onTap : null,
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.headlineSm.copyWith(
          fontSize: ResponsiveHelper.sp(11),
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
          horizontal: ResponsiveHelper.w(4),
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
            Icon(icon, color: color, size: 14),
            SizedBox(width: ResponsiveHelper.w(2)),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.labelCaps.copyWith(
                  color: color,
                  fontSize: ResponsiveHelper.sp(9),
                  fontWeight: FontWeight.bold,
                ).responsive(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHansokuDialog(BuildContext context, JudoController controller, String whiteName, String blueName) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        backgroundColor: AppColors.cardSurface,
        title: Text(
          'Declare Hansoku-make (Disqualification)',
          style: AppTypography.headlineMd.copyWith(color: AppColors.textPrimary, fontSize: 18).responsive(context),
        ),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(ctx);
              controller.recordHansokuMake('white'); // WHITE disqualified -> BLUE wins
            },
            child: Text('Disqualify WHITE -> Winner: $blueName', style: const TextStyle(color: Color(0xFF4D96FF), fontWeight: FontWeight.bold)),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(ctx);
              controller.recordHansokuMake('blue'); // BLUE disqualified -> WHITE wins
            },
            child: Text('Disqualify BLUE -> Winner: $whiteName', style: const TextStyle(color: Color(0xFFE0E0E0), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
