import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Wrestling/wrestling_controller.dart';

class WrestlingActionButtons extends StatelessWidget {
  const WrestlingActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<WrestlingController>();

    return Obx(() {
      final isReadOnly = controller.isReadOnly.value;
      final state = controller.liveState.value;

      final wAName = controller.currentMatch.value?.wrestlerA ?? 'Red Corner';
      final wBName = controller.currentMatch.value?.wrestlerB ?? 'Blue Corner';

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
            // 1. PRIMARY SCORING BUTTONS (+1 PT / +2 PTS TAKEDOWN / +4 PTS THROW / +5 PTS GRAND THROW FOR RED & BLUE)
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
                              label: '+1 PT',
                              accentColor: const Color(0xFFFF4D4D),
                              isEnabled: !isReadOnly,
                              onTap: () => controller.addPoints('wrestlerA', 1),
                            ),
                          ),
                          SizedBox(width: ResponsiveHelper.w(6)),
                          Expanded(
                            child: _buildActionButton(
                              context,
                              label: '+2 PTS',
                              accentColor: const Color(0xFFFF4D4D),
                              isEnabled: !isReadOnly,
                              onTap: () => controller.addPoints('wrestlerA', 2),
                            ),
                          ),
                          SizedBox(width: ResponsiveHelper.w(6)),
                          Expanded(
                            child: _buildActionButton(
                              context,
                              label: '+4 PTS',
                              accentColor: const Color(0xFFFF4D4D),
                              isEnabled: !isReadOnly,
                              onTap: () => controller.addPoints('wrestlerA', 4),
                            ),
                          ),
                          SizedBox(width: ResponsiveHelper.w(6)),
                          Expanded(
                            child: _buildActionButton(
                              context,
                              label: '+5 PTS',
                              accentColor: const Color(0xFFFF4D4D),
                              isEnabled: !isReadOnly,
                              onTap: () => controller.addPoints('wrestlerA', 5),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveHelper.h(4)),
                      Text(
                        wAName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Color(0xFFFF4D4D), fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(12)),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              context,
                              label: '+1 PT',
                              accentColor: const Color(0xFF4D96FF),
                              isEnabled: !isReadOnly,
                              onTap: () => controller.addPoints('wrestlerB', 1),
                            ),
                          ),
                          SizedBox(width: ResponsiveHelper.w(6)),
                          Expanded(
                            child: _buildActionButton(
                              context,
                              label: '+2 PTS',
                              accentColor: const Color(0xFF4D96FF),
                              isEnabled: !isReadOnly,
                              onTap: () => controller.addPoints('wrestlerB', 2),
                            ),
                          ),
                          SizedBox(width: ResponsiveHelper.w(6)),
                          Expanded(
                            child: _buildActionButton(
                              context,
                              label: '+4 PTS',
                              accentColor: const Color(0xFF4D96FF),
                              isEnabled: !isReadOnly,
                              onTap: () => controller.addPoints('wrestlerB', 4),
                            ),
                          ),
                          SizedBox(width: ResponsiveHelper.w(6)),
                          Expanded(
                            child: _buildActionButton(
                              context,
                              label: '+5 PTS',
                              accentColor: const Color(0xFF4D96FF),
                              isEnabled: !isReadOnly,
                              onTap: () => controller.addPoints('wrestlerB', 5),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveHelper.h(4)),
                      Text(
                        wBName,
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

            // 2. CAUTION & PIN (FALL) CHIPS
            Row(
              children: [
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.warning_amber_rounded,
                    label: 'CAUTION RED (+1 BLUE)',
                    color: const Color(0xFFFF4D4D),
                    onTap: () => controller.recordCaution('wrestlerA'),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(6)),
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.warning_amber_rounded,
                    label: 'CAUTION BLUE (+1 RED)',
                    color: const Color(0xFF4D96FF),
                    onTap: () => controller.recordCaution('wrestlerB'),
                  ),
                ),
              ],
            ),

            SizedBox(height: ResponsiveHelper.h(8)),

            // 3. END PERIOD, VICTORY BY FALL & UNDO CONTROLS
            Row(
              children: [
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.timer,
                    label: 'END PERIOD ${state != null ? state.currentPeriodIndex + 1 : 1}',
                    color: AppColors.accent,
                    onTap: () => controller.completePeriod(),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(6)),
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.sports_kabaddi,
                    label: 'FALL (PIN)',
                    color: Colors.amber,
                    onTap: () => _showFallDialog(context, controller, wAName, wBName),
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

  void _showFallDialog(BuildContext context, WrestlingController controller, String nameA, String nameB) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        backgroundColor: AppColors.cardSurface,
        title: Text(
          'Declare Victory by Fall (Pin)',
          style: AppTypography.headlineMd.copyWith(color: AppColors.textPrimary, fontSize: 18).responsive(context),
        ),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(ctx);
              controller.recordFall('wrestlerA');
            },
            child: Text('Fall (Pin) Winner: $nameA', style: const TextStyle(color: Color(0xFFFF4D4D), fontWeight: FontWeight.bold)),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(ctx);
              controller.recordFall('wrestlerB');
            },
            child: Text('Fall (Pin) Winner: $nameB', style: const TextStyle(color: Color(0xFF4D96FF), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
