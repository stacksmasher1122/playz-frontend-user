import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Karate/karate_controller.dart';

class KarateActionButtons extends StatelessWidget {
  const KarateActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<KarateController>();

    return Obx(() {
      final isReadOnly = controller.isReadOnly.value;

      final akaName = controller.currentMatch.value?.akaFighter ?? 'AKA (Red)';
      final aoName = controller.currentMatch.value?.aoFighter ?? 'AO (Blue)';

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
            // 1. PRIMARY SCORING BUTTONS (YUKO +1 / WAZA-ARI +2 / IPPON +3 FOR AKA & AO)
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
                              label: 'YUKO (+1)',
                              accentColor: const Color(0xFFFF4D4D),
                              isEnabled: !isReadOnly,
                              onTap: () => controller.scoreYuko('aka'),
                            ),
                          ),
                          SizedBox(width: ResponsiveHelper.w(4)),
                          Expanded(
                            child: _buildActionButton(
                              context,
                              label: 'WAZA (+2)',
                              accentColor: const Color(0xFFFF4D4D),
                              isEnabled: !isReadOnly,
                              onTap: () => controller.scoreWazaAri('aka'),
                            ),
                          ),
                          SizedBox(width: ResponsiveHelper.w(4)),
                          Expanded(
                            child: _buildActionButton(
                              context,
                              label: 'IPPON (+3)',
                              accentColor: const Color(0xFFFF4D4D),
                              isEnabled: !isReadOnly,
                              onTap: () => controller.scoreIppon('aka'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveHelper.h(4)),
                      Text(
                        akaName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Color(0xFFFF4D4D), fontSize: 11, fontWeight: FontWeight.bold),
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
                              label: 'YUKO (+1)',
                              accentColor: const Color(0xFF4D96FF),
                              isEnabled: !isReadOnly,
                              onTap: () => controller.scoreYuko('ao'),
                            ),
                          ),
                          SizedBox(width: ResponsiveHelper.w(4)),
                          Expanded(
                            child: _buildActionButton(
                              context,
                              label: 'WAZA (+2)',
                              accentColor: const Color(0xFF4D96FF),
                              isEnabled: !isReadOnly,
                              onTap: () => controller.scoreWazaAri('ao'),
                            ),
                          ),
                          SizedBox(width: ResponsiveHelper.w(4)),
                          Expanded(
                            child: _buildActionButton(
                              context,
                              label: 'IPPON (+3)',
                              accentColor: const Color(0xFF4D96FF),
                              isEnabled: !isReadOnly,
                              onTap: () => controller.scoreIppon('ao'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveHelper.h(4)),
                      Text(
                        aoName,
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

            // 2. PENALTY CHIPS (CATEGORY 1 & 2 WARNINGS)
            Row(
              children: [
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.warning_amber_rounded,
                    label: 'PENALTY (AKA RED)',
                    color: const Color(0xFFFF4D4D),
                    onTap: () => controller.recordPenalty('aka'),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(6)),
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.warning_amber_rounded,
                    label: 'PENALTY (AO BLUE)',
                    color: const Color(0xFF4D96FF),
                    onTap: () => controller.recordPenalty('ao'),
                  ),
                ),
              ],
            ),

            SizedBox(height: ResponsiveHelper.h(8)),

            // 3. FINISH BOUT, HANSOKU DQ & UNDO CONTROLS
            Row(
              children: [
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.check_circle_outline,
                    label: 'FINISH BOUT',
                    color: AppColors.accent,
                    onTap: () => controller.finishBout(),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(6)),
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.report_problem,
                    label: 'HANSOKU (DQ)',
                    color: Colors.redAccent,
                    onTap: () => _showHansokuDialog(context, controller, akaName, aoName),
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
          fontSize: ResponsiveHelper.sp(10),
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

  void _showHansokuDialog(BuildContext context, KarateController controller, String akaName, String aoName) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        backgroundColor: AppColors.cardSurface,
        title: Text(
          'Declare Hansoku (Disqualification)',
          style: AppTypography.headlineMd.copyWith(color: AppColors.textPrimary, fontSize: 18).responsive(context),
        ),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(ctx);
              controller.recordDisqualification('aka'); // AKA disqualified -> AO wins
            },
            child: Text('Disqualify AKA (Red) -> Winner: $aoName', style: const TextStyle(color: Color(0xFF4D96FF), fontWeight: FontWeight.bold)),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(ctx);
              controller.recordDisqualification('ao'); // AO disqualified -> AKA wins
            },
            child: Text('Disqualify AO (Blue) -> Winner: $akaName', style: const TextStyle(color: Color(0xFFFF4D4D), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
