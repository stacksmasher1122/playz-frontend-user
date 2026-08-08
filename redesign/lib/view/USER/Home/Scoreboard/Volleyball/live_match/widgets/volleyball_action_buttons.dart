import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Volleyball/live_match/widgets/volleyball_call_timeout_sheet.dart';

/// Pixel-perfect Volleyball Action & Scoring Controls matching the attached screenshot UI.
class VolleyballActionButtons extends StatelessWidget {
  const VolleyballActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<VolleyballController>();

    const Color greenColor = Color(0xFF00E676);
    const Color blueColor = Color(0xFF448AFF);
    const Color goldColor = Color(0xFFFFC107);
    const Color cardBgColor = Color(0xFF121724);

    return Obx(() {
      final homeName = controller.currentMatch.value?.homeTeam.isNotEmpty == true
          ? controller.currentMatch.value!.homeTeam
          : 'SIDE A';
      final awayName = controller.currentMatch.value?.awayTeam.isNotEmpty == true
          ? controller.currentMatch.value!.awayTeam
          : 'SIDE B';
      final isReadOnly = controller.isReadOnly.value;

      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.w(16.0),
          vertical: ResponsiveHelper.h(8.0),
        ),
        child: Column(
          children: [
            // ─── 1. SIDE-BY-SIDE RALLY POINT SCORING PANELS ───
            Row(
              children: [
                // ─── SIDE A SCORING PANEL (NEON GREEN ACCENT) ───
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.w(12.0),
                      vertical: ResponsiveHelper.h(12.0),
                    ),
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
                      border: Border.all(
                        color: greenColor,
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.sports_volleyball,
                              color: greenColor,
                              size: 16,
                            ),
                            SizedBox(width: ResponsiveHelper.w(6.0)),
                            Flexible(
                              child: Text(
                                homeName.toUpperCase(),
                                style: AppTypography.labelCaps.copyWith(
                                  color: greenColor,
                                  fontSize: ResponsiveHelper.sp(12.0),
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.8,
                                ).responsive(context),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ResponsiveHelper.h(10.0)),
                        _buildScoringButton(
                          context,
                          label: '+1 POINT',
                          borderColor: greenColor,
                          isEnabled: !isReadOnly,
                          onTap: () => controller.scorePoint('sideA'),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: ResponsiveHelper.w(12.0)),

                // ─── SIDE B SCORING PANEL (ELECTRIC BLUE ACCENT) ───
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.w(12.0),
                      vertical: ResponsiveHelper.h(12.0),
                    ),
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
                      border: Border.all(
                        color: blueColor,
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.sports_volleyball,
                              color: blueColor,
                              size: 16,
                            ),
                            SizedBox(width: ResponsiveHelper.w(6.0)),
                            Flexible(
                              child: Text(
                                awayName.toUpperCase(),
                                style: AppTypography.labelCaps.copyWith(
                                  color: blueColor,
                                  fontSize: ResponsiveHelper.sp(12.0),
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.8,
                                ).responsive(context),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ResponsiveHelper.h(10.0)),
                        _buildScoringButton(
                          context,
                          label: '+1 POINT',
                          borderColor: blueColor,
                          isEnabled: !isReadOnly,
                          onTap: () => controller.scorePoint('sideB'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: ResponsiveHelper.h(14.0)),

            // ─── 2. BOTTOM UTILITY TILES (SERVE ⇄ | TIMEOUT | UNDO) ───
            Row(
              children: [
                // Toggle Serving Team
                Expanded(
                  child: _buildActionTile(
                    context,
                    icon: Icons.swap_horiz_rounded,
                    label: 'SERVE',
                    accentColor: goldColor,
                    borderColor: goldColor,
                    isEnabled: !isReadOnly,
                    onTap: () => controller.toggleServingTeam(),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(8.0)),

                // Call Timeout
                Expanded(
                  child: _buildActionTile(
                    context,
                    icon: Icons.timer_outlined,
                    label: 'TIMEOUT',
                    accentColor: goldColor,
                    borderColor: goldColor,
                    isEnabled: !isReadOnly,
                    onTap: () => _showTimeoutDialog(context, controller, homeName, awayName),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(8.0)),

                // Undo Action
                Expanded(
                  child: _buildActionTile(
                    context,
                    icon: Icons.undo_rounded,
                    label: 'UNDO',
                    accentColor: const Color(0xFFC5D1E0),
                    borderColor: const Color(0xFF2B3850),
                    isEnabled: !isReadOnly && controller.engine.canUndo,
                    onTap: () => controller.undoLastAction(),
                  ),
                ),
              ],
            ),

            SizedBox(height: ResponsiveHelper.h(12.0)),
          ],
        ),
      );
    });
  }

  // ─── HELPER: +1 POINT SCORING BUTTON ───
  Widget _buildScoringButton(
    BuildContext context, {
    required String label,
    required Color borderColor,
    required bool isEnabled,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12.0)),
        child: Container(
          height: ResponsiveHelper.h(46.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF182030),
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(12.0)),
            border: Border.all(
              color: isEnabled ? borderColor : Colors.white.withValues(alpha: 0.1),
              width: 1.0,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTypography.headlineSm.copyWith(
                color: isEnabled ? Colors.white : AppColors.mutedText,
                fontSize: ResponsiveHelper.sp(15.0),
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ).responsive(context),
            ),
          ),
        ),
      ),
    );
  }

  // ─── HELPER: BOTTOM ACTION TILE ───
  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color accentColor,
    required Color borderColor,
    required bool isEnabled,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
        child: Container(
          height: ResponsiveHelper.h(48.0),
          decoration: BoxDecoration(
            color: const Color(0xFF121724),
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
            border: Border.all(
              color: isEnabled ? borderColor : Colors.white.withValues(alpha: 0.08),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isEnabled ? accentColor : AppColors.mutedText,
                size: ResponsiveHelper.w(18.0),
              ),
              SizedBox(width: ResponsiveHelper.w(6.0)),
              Text(
                label,
                style: AppTypography.labelCaps.copyWith(
                  color: isEnabled ? accentColor : AppColors.mutedText,
                  fontSize: ResponsiveHelper.sp(12.0),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.6,
                ).responsive(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTimeoutDialog(
    BuildContext context,
    VolleyballController controller,
    String homeName,
    String awayName,
  ) {
    VolleyballCallTimeoutSheet.show(context, controller);
  }
}
