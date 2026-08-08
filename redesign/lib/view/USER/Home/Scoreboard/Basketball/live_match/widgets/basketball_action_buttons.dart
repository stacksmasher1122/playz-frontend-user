import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Basketball/basketball_controller.dart';
import 'basketball_record_foul_sheet.dart';
import 'basketball_call_timeout_sheet.dart';

/// High-fidelity Basketball Live Action Buttons & Controls matching the design screenshot.
class BasketballActionButtons extends StatelessWidget {
  const BasketballActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<BasketballController>();

    return Obx(() {
      final isStarted = controller.isMatchStarted.value;
      final isRunning = controller.isTimerRunning.value;
      final homeName = controller.currentMatch.value?.homeTeam.isNotEmpty == true
          ? controller.currentMatch.value!.homeTeam
          : 'SIDE A';
      final awayName = controller.currentMatch.value?.awayTeam.isNotEmpty == true
          ? controller.currentMatch.value!.awayTeam
          : 'SIDE B';

      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.w(16.0),
          vertical: ResponsiveHelper.h(12.0),
        ),
        child: Column(
          children: [
            // ─── START MATCH NOW BANNER (IF NOT STARTED) ───
            if (!isStarted) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16.0)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () => controller.startMatch(),
                  icon: const Icon(Icons.play_arrow_rounded, size: 24, color: Colors.black),
                  label: Text(
                    'START MATCH NOW',
                    style: AppTypography.headlineSm.copyWith(
                      fontSize: ResponsiveHelper.sp(15.0),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ).responsive(context),
                  ),
                ),
              ),
              SizedBox(height: ResponsiveHelper.h(14.0)),
            ],

            // ─── 1. TEAM SCORING PANELS (SIDE A GREEN | SIDE B BLUE) ───
            Row(
              children: [
                // SIDE A Scoring Panel
                Expanded(
                  child: _buildTeamScoringPanel(
                    context,
                    controller: controller,
                    team: 'sideA',
                    teamName: homeName,
                    accentColor: AppColors.accent,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(12.0)),

                // SIDE B Scoring Panel
                Expanded(
                  child: _buildTeamScoringPanel(
                    context,
                    controller: controller,
                    team: 'sideB',
                    teamName: awayName,
                    accentColor: const Color(0xFF4D96FF),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.h(14.0)),

            // ─── 2. SHOT CLOCK UTILITY CONTROLS (ROW 1: RESET 24s | OFF. REBOUND 14s) ───
            Row(
              children: [
                // RESET 24s SHOT CLOCK Button
                Expanded(
                  child: _buildShotClockControlTile(
                    context,
                    badgeText: '24',
                    title: 'RESET 24s',
                    subtitle: 'SHOT CLOCK',
                    accentColor: AppColors.accent,
                    onTap: () => controller.resetShotClock24(),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(12.0)),

                // OFF. REBOUND 14s Button
                Expanded(
                  child: _buildShotClockControlTile(
                    context,
                    badgeText: '14',
                    title: 'OFF. REBOUND',
                    subtitle: '14s',
                    accentColor: const Color(0xFF4D96FF),
                    onTap: () => controller.resetShotClock14(),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.h(12.0)),

            // ─── 3. POSSESSION CONTROLS (ROW 2: HELD BALL / JUMP BALL | ARROW ⇄) ───
            Row(
              children: [
                // HELD BALL / JUMP BALL Button
                Expanded(
                  flex: 3,
                  child: _buildOutlineUtilityTile(
                    context,
                    icon: Icons.sports_basketball_rounded,
                    label: 'HELD BALL / JUMP BALL',
                    accentColor: AppColors.accent,
                    onTap: () => controller.recordHeldBall(),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(10.0)),

                // ARROW ⇄ Button
                Expanded(
                  flex: 2,
                  child: _buildOutlineUtilityTile(
                    context,
                    icon: Icons.swap_horizontal_circle_outlined,
                    label: 'ARROW  ⇄',
                    accentColor: const Color(0xFFFFB300),
                    onTap: () => controller.togglePossessionArrow(),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.h(14.0)),

            // ─── 4. BOTTOM ACTION CONTROL TILES (FOUL | TIMEOUT | BREAK | UNDO) ───
            Row(
              children: [
                // 1. FOUL Tile
                Expanded(
                  child: _buildBottomActionTile(
                    context,
                    icon: Icons.sports_rounded,
                    label: 'FOUL',
                    accentColor: const Color(0xFFFFB300),
                    onTap: () => _showFoulDialog(context, controller, homeName, awayName),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(8.0)),

                // 2. TIMEOUT Tile
                Expanded(
                  child: _buildBottomActionTile(
                    context,
                    icon: Icons.timer_outlined,
                    label: 'TIMEOUT',
                    accentColor: const Color(0xFFFFC107),
                    onTap: () => _showTimeoutDialog(context, controller, homeName, awayName),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(8.0)),

                // 3. BREAK / RESUME Tile
                Expanded(
                  child: _buildBottomActionTile(
                    context,
                    icon: isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    label: isRunning ? 'BREAK' : 'RESUME',
                    accentColor: isRunning ? const Color(0xFFFF5252) : AppColors.accent,
                    onTap: () {
                      if (isRunning) {
                        controller.pauseForBreak();
                      } else {
                        controller.resumeFromBreak();
                      }
                    },
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(8.0)),

                // 4. UNDO Tile
                Expanded(
                  child: _buildBottomActionTile(
                    context,
                    icon: Icons.undo_rounded,
                    label: 'UNDO',
                    accentColor: AppColors.mutedText,
                    onTap: () => controller.undoLastAction(),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.h(16.0)),
          ],
        ),
      );
    });
  }

  // ─── HELPER: TEAM SCORING PANEL (SIDE A / SIDE B) ───
  Widget _buildTeamScoringPanel(
    BuildContext context, {
    required BasketballController controller,
    required String team,
    required String teamName,
    required Color accentColor,
  }) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(14.0)),
      decoration: BoxDecoration(
        color: const Color(0xFF141822),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(18.0)),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.6),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // Header Label with Underline Indicator
          Text(
            teamName.toUpperCase(),
            style: AppTypography.labelCaps.copyWith(
              color: accentColor,
              fontSize: ResponsiveHelper.sp(13.0),
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ).responsive(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: ResponsiveHelper.h(4.0)),
          Container(
            width: ResponsiveHelper.w(20.0),
            height: 2.0,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(14.0)),

          // Top Row: +1 FT & +2 FG Buttons
          Row(
            children: [
              Expanded(
                child: _buildScoringButton(
                  context,
                  icon: Icons.filter_center_focus_rounded,
                  label: '+1 FT',
                  accentColor: accentColor,
                  onTap: () => controller.scorePoints(team, 1),
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(8.0)),
              Expanded(
                child: _buildScoringButton(
                  context,
                  icon: Icons.sports_basketball_outlined,
                  label: '+2 FG',
                  accentColor: accentColor,
                  onTap: () => controller.scorePoints(team, 2),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(8.0)),

          // Bottom Full-Width Row: +3 3-PT Button
          _buildScoringButton(
            context,
            icon: Icons.sports_basketball_rounded,
            label: '+3 3-PT',
            accentColor: accentColor,
            isFullWidth: true,
            onTap: () => controller.scorePoints(team, 3),
          ),
        ],
      ),
    );
  }

  // ─── HELPER: SCORING BUTTON TILE ───
  Widget _buildScoringButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color accentColor,
    bool isFullWidth = false,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12.0)),
        child: Container(
          height: ResponsiveHelper.h(48.0),
          width: isFullWidth ? double.infinity : null,
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(4.0)),
          decoration: BoxDecoration(
            color: const Color(0xFF0D111A),
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(12.0)),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.35),
              width: 1.0,
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(4.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: accentColor,
                    size: ResponsiveHelper.w(16.0),
                  ),
                  SizedBox(width: ResponsiveHelper.w(4.0)),
                  Text(
                    label,
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: ResponsiveHelper.sp(13.0),
                      fontWeight: FontWeight.w900,
                    ).responsive(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── HELPER: SHOT CLOCK CONTROL TILE ───
  Widget _buildShotClockControlTile(
    BuildContext context, {
    required String badgeText,
    required String title,
    required String subtitle,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
        child: Container(
          height: ResponsiveHelper.h(54.0),
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(10.0)),
          decoration: BoxDecoration(
            color: const Color(0xFF141822),
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              // Round Badge
              Container(
                width: ResponsiveHelper.w(30.0),
                height: ResponsiveHelper.w(30.0),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: accentColor, width: 1.2),
                ),
                child: Center(
                  child: Text(
                    badgeText,
                    style: AppTypography.labelCaps.copyWith(
                      color: accentColor,
                      fontSize: ResponsiveHelper.sp(10.5),
                      fontWeight: FontWeight.w900,
                    ).responsive(context),
                  ),
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
                      style: AppTypography.labelCaps.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: ResponsiveHelper.sp(10.5),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ).responsive(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      subtitle,
                      style: AppTypography.labelCaps.copyWith(
                        color: AppColors.mutedText,
                        fontSize: ResponsiveHelper.sp(8.5),
                        fontWeight: FontWeight.bold,
                      ).responsive(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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

  // ─── HELPER: OUTLINE UTILITY TILE ───
  Widget _buildOutlineUtilityTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
        child: Container(
          height: ResponsiveHelper.h(48.0),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(4.0)),
          decoration: BoxDecoration(
            color: const Color(0xFF141822),
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.5),
              width: 1.2,
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: accentColor, size: ResponsiveHelper.w(18.0)),
                SizedBox(width: ResponsiveHelper.w(6.0)),
                Text(
                  label,
                  style: AppTypography.labelCaps.copyWith(
                    color: accentColor,
                    fontSize: ResponsiveHelper.sp(11.0),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.6,
                  ).responsive(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── HELPER: BOTTOM ACTION TILE (FOUL | TIMEOUT | BREAK | UNDO) ───
  Widget _buildBottomActionTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
        child: Container(
          height: ResponsiveHelper.h(62.0),
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(2.0)),
          decoration: BoxDecoration(
            color: const Color(0xFF141822),
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.4),
              width: 1.2,
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: accentColor, size: ResponsiveHelper.w(20.0)),
                SizedBox(height: ResponsiveHelper.h(4.0)),
                Text(
                  label,
                  style: AppTypography.labelCaps.copyWith(
                    color: accentColor,
                    fontSize: ResponsiveHelper.sp(10.0),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ).responsive(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── BOTTOM SHEETS FOR RECORD FOUL & CALL TIMEOUT ───
  void _showFoulDialog(
    BuildContext context,
    BasketballController controller,
    String homeName,
    String awayName,
  ) {
    BasketballRecordFoulSheet.show(context, controller);
  }

  void _showTimeoutDialog(
    BuildContext context,
    BasketballController controller,
    String homeName,
    String awayName,
  ) {
    BasketballCallTimeoutSheet.show(context, controller);
  }
}
