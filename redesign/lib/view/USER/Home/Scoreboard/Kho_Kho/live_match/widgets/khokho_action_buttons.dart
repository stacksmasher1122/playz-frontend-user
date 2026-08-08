import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Kho_Kho/khokho_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Kho_Kho/live_match/widgets/khokho_select_chaser_sheet.dart';

/// App-themed Kho Kho Action Controls matching design guidelines.
class KhoKhoActionButtons extends StatelessWidget {
  const KhoKhoActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<KhoKhoController>();

    return Obx(() {
      final isReadOnly = controller.isReadOnly.value;
      final state = controller.liveState.value;

      final chasingTeamKey = state?.activeChasingTeam ?? 'sideA';
      final chasingTeamName = chasingTeamKey == 'sideA'
          ? (controller.currentMatch.value?.homeTeam.isNotEmpty == true
              ? controller.currentMatch.value!.homeTeam
              : 'Side A')
          : (controller.currentMatch.value?.awayTeam.isNotEmpty == true
              ? controller.currentMatch.value!.awayTeam
              : 'Side B');

      const Color greenColor = Color(0xFF00E676);
      const Color blueColor = Color(0xFF448AFF);
      const Color goldColor = Color(0xFFFFC107);
      const Color cardBgColor = Color(0xFF10141E);
      final Color chasingAccentColor = chasingTeamKey == 'sideA' ? greenColor : blueColor;

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
            // ─── 1. PRIMARY SCORING BUTTONS (+1 OUT & POLE DIVE +2) ───
            Row(
              children: [
                // +1 OUT BUTTON
                Expanded(
                  flex: 3,
                  child: _buildFilledScoringButton(
                    context,
                    title: '+1 OUT',
                    subtitle: chasingTeamName,
                    accentColor: chasingAccentColor,
                    icon: Icons.directions_run_rounded,
                    isEnabled: !isReadOnly,
                    onTap: () => KhoKhoSelectChaserSheet.show(
                      context,
                      controller,
                      chasingTeamKey,
                      chasingTeamName,
                      isPoleDive: false,
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(10.0)),
                // POLE DIVE (+2) BUTTON
                Expanded(
                  flex: 2,
                  child: _buildFilledScoringButton(
                    context,
                    title: 'POLE DIVE',
                    subtitle: '+2 PTS',
                    accentColor: goldColor,
                    icon: Icons.bolt_rounded,
                    isEnabled: !isReadOnly,
                    onTap: () => KhoKhoSelectChaserSheet.show(
                      context,
                      controller,
                      chasingTeamKey,
                      chasingTeamName,
                      isPoleDive: true,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: ResponsiveHelper.h(14.0)),

            // ─── 2. SECONDARY CONTROLS (DREAM RUN +1, NEXT TURN, UNDO) ───
            Row(
              children: [
                // DREAM RUN (+1)
                Expanded(
                  child: _buildUtilityCard(
                    context,
                    icon: Icons.shield_outlined,
                    label: 'DREAM RUN (+1)',
                    accentColor: goldColor,
                    borderColor: goldColor,
                    isEnabled: !isReadOnly,
                    onTap: () => controller.awardDreamRun(),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(8.0)),
                // NEXT TURN
                Expanded(
                  child: _buildUtilityCard(
                    context,
                    icon: Icons.timer_outlined,
                    label: 'NEXT TURN',
                    accentColor: greenColor,
                    borderColor: greenColor,
                    isEnabled: !isReadOnly,
                    onTap: () => controller.advanceTurn(),
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

  // ─── HELPER: FILLED SCORING BUTTON ───
  Widget _buildFilledScoringButton(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Color accentColor,
    required IconData icon,
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
              Container(
                padding: EdgeInsets.all(ResponsiveHelper.w(8.0)),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(10.0)),
                ),
                child: Icon(
                  icon,
                  color: Colors.black,
                  size: ResponsiveHelper.w(22.0),
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(8.0)),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.headlineSm.copyWith(
                        color: Colors.black,
                        fontSize: ResponsiveHelper.sp(15.0),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ).responsive(context),
                    ),
                    SizedBox(height: ResponsiveHelper.h(2.0)),
                    Text(
                      subtitle,
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
