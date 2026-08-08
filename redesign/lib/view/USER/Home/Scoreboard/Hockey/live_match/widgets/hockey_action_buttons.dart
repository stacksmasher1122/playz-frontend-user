import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Hockey/hockey_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Hockey/live_match/widgets/hockey_goal_type_sheet.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Hockey/live_match/widgets/hockey_penalty_corner_sheet.dart';

/// Pixel-perfect Hockey Action & Scoring Controls matching the attached reference screenshot.
class HockeyActionButtons extends StatelessWidget {
  const HockeyActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<HockeyController>();

    return Obx(() {
      final homeName = controller.currentMatch.value?.homeTeam.isNotEmpty == true
          ? controller.currentMatch.value!.homeTeam
          : 'Side A';
      final awayName = controller.currentMatch.value?.awayTeam.isNotEmpty == true
          ? controller.currentMatch.value!.awayTeam
          : 'Side B';
      final isReadOnly = controller.isReadOnly.value;

      const Color greenColor = Color(0xFF00E676);
      const Color blueColor = Color(0xFF448AFF);
      const Color goldColor = Color(0xFFFFC107);
      const Color cardBgColor = Color(0xFF10141E);

      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.w(16.0),
          vertical: ResponsiveHelper.h(16.0),
        ),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(24.0))),
          border: Border.all(color: const Color(0xFF1F2B3E), width: 1.2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ─── 1. PRIMARY SCORING BUTTONS (+1 GOAL SIDE A & SIDE B) ───
            Row(
              children: [
                // SIDE A +1 GOAL BUTTON (GREEN FILLED)
                Expanded(
                  child: _buildFilledGoalButton(
                    context,
                    teamName: homeName,
                    accentColor: greenColor,
                    isEnabled: !isReadOnly,
                    onTap: () => HockeyGoalTypeSheet.show(context, controller, 'sideA', homeName),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(12.0)),
                // SIDE B +1 GOAL BUTTON (BLUE FILLED)
                Expanded(
                  child: _buildFilledGoalButton(
                    context,
                    teamName: awayName,
                    accentColor: blueColor,
                    isEnabled: !isReadOnly,
                    onTap: () => HockeyGoalTypeSheet.show(context, controller, 'sideB', awayName),
                  ),
                ),
              ],
            ),

            SizedBox(height: ResponsiveHelper.h(14.0)),

            // ─── 2. BOTTOM UTILITY CONTROLS (PENALTY CORNER, NEXT PERIOD, UNDO) ───
            Row(
              children: [
                // PENALTY CORNER
                Expanded(
                  child: _buildUtilityCard(
                    context,
                    icon: Icons.flag_outlined,
                    label: 'PENALTY CORNER',
                    accentColor: goldColor,
                    borderColor: goldColor,
                    isEnabled: !isReadOnly,
                    onTap: () => HockeyPenaltyCornerSheet.show(context, controller, homeName, awayName),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(8.0)),
                // NEXT PERIOD
                Expanded(
                  child: _buildUtilityCard(
                    context,
                    icon: Icons.timer_outlined,
                    label: 'NEXT PERIOD',
                    accentColor: greenColor,
                    borderColor: greenColor,
                    isEnabled: !isReadOnly,
                    onTap: () => controller.advancePeriod(),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(8.0)),
                // UNDO
                Expanded(
                  child: _buildUtilityCard(
                    context,
                    icon: Icons.undo_rounded,
                    label: 'UNDO',
                    accentColor: const Color(0xFF9EABBE),
                    borderColor: const Color(0xFF232E42),
                    isEnabled: !isReadOnly,
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

  // ─── HELPER: FILLED GOAL BUTTON (+1 GOAL) ───
  Widget _buildFilledGoalButton(
    BuildContext context, {
    required String teamName,
    required Color accentColor,
    required bool isEnabled,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
        child: Container(
          height: ResponsiveHelper.h(68.0),
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12.0)),
          decoration: BoxDecoration(
            color: isEnabled ? accentColor : Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
          ),
          child: Row(
            children: [
              // Goal Net Icon Box
              Container(
                padding: EdgeInsets.all(ResponsiveHelper.w(8.0)),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(10.0)),
                ),
                child: Icon(
                  Icons.sports_soccer_outlined,
                  color: Colors.black,
                  size: ResponsiveHelper.w(24.0),
                ),
              ),

              SizedBox(width: ResponsiveHelper.w(10.0)),

              // Text Column (+1 GOAL & Team Name)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '+1 GOAL',
                      style: AppTypography.headlineSm.copyWith(
                        color: Colors.black,
                        fontSize: ResponsiveHelper.sp(16.0),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ).responsive(context),
                    ),
                    SizedBox(height: ResponsiveHelper.h(2.0)),
                    Text(
                      teamName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySm.copyWith(
                        color: Colors.black.withValues(alpha: 0.8),
                        fontSize: ResponsiveHelper.sp(12.0),
                        fontWeight: FontWeight.w700,
                      ).responsive(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── HELPER: UTILITY ACTION CARD ───
  Widget _buildUtilityCard(
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
                size: ResponsiveHelper.w(16.0),
              ),
              SizedBox(width: ResponsiveHelper.w(6.0)),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelCaps.copyWith(
                    color: isEnabled ? accentColor : AppColors.mutedText,
                    fontSize: ResponsiveHelper.sp(11.0),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ).responsive(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
