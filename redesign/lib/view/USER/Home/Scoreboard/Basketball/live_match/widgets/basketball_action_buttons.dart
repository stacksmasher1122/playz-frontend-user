import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Basketball/basketball_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Basketball/basketball_state_models.dart';

class BasketballActionButtons extends StatelessWidget {
  const BasketballActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<BasketballController>();

    return Obx(() {
      final isStarted = controller.isMatchStarted.value;
      final isRunning = controller.isTimerRunning.value;
      final homeName = controller.currentMatch.value?.homeTeam ?? 'Side A';
      final awayName = controller.currentMatch.value?.awayTeam ?? 'Side B';

      return Column(
        children: [
          // 1. START MATCH NOW / RESUME CLOCK BANNER BUTTON
          if (!isStarted)
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(16),
                vertical: ResponsiveHelper.h(8),
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
                  ),
                  elevation: 6,
                ),
                onPressed: () => controller.startMatch(),
                icon: const Icon(Icons.play_arrow_rounded, size: 24, color: Colors.black),
                label: Text(
                  'START MATCH NOW',
                  style: AppTypography.headlineSm.copyWith(
                    fontSize: ResponsiveHelper.sp(15),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ).responsive(context),
                ),
              ),
            ),

          if (isStarted && !isRunning)
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(16),
                vertical: ResponsiveHelper.h(6),
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warning,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                  ),
                ),
                onPressed: () => controller.resumeFromBreak(),
                icon: const Icon(Icons.play_arrow_rounded, color: Colors.black),
                label: Text(
                  'RESUME MATCH CLOCK',
                  style: AppTypography.headlineSm.copyWith(
                    fontSize: ResponsiveHelper.sp(13),
                    fontWeight: FontWeight.bold,
                  ).responsive(context),
                ),
              ),
            ),

          SizedBox(height: ResponsiveHelper.h(10)),

          // 2. PRIMARY SCORING CARDS (SIDE A vs SIDE B)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
            child: Row(
              children: [
                // Side A Scoring Card
                Expanded(
                  child: _buildTeamScoringCard(
                    context,
                    controller: controller,
                    team: 'sideA',
                    teamName: homeName,
                    accentColor: AppColors.accent,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(12)),
                // Side B Scoring Card
                Expanded(
                  child: _buildTeamScoringCard(
                    context,
                    controller: controller,
                    team: 'sideB',
                    teamName: awayName,
                    accentColor: const Color(0xFF4D96FF),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: ResponsiveHelper.h(16)),

          // 3. SHOT CLOCK MANUAL RESETS
          if (controller.enableShotClock.value)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: const BorderSide(color: Colors.white24),
                        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(10)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
                        ),
                      ),
                      onPressed: () => controller.resetShotClock24(),
                      icon: const Icon(Icons.refresh, size: 16, color: AppColors.accent),
                      label: Text(
                        'Reset 24s Shot Clock',
                        style: AppTypography.bodySm.copyWith(
                          fontSize: ResponsiveHelper.sp(11),
                        ).responsive(context),
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.w(10)),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: const BorderSide(color: Colors.white24),
                        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(10)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
                        ),
                      ),
                      onPressed: () => controller.resetShotClock14(),
                      icon: const Icon(Icons.replay_10, size: 16, color: AppColors.warning),
                      label: Text(
                        'Off. Rebound (14s)',
                        style: AppTypography.bodySm.copyWith(
                          fontSize: ResponsiveHelper.sp(11),
                        ).responsive(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          SizedBox(height: ResponsiveHelper.h(16)),

          // 4. JUMP BALL & POSSESSION ARROW CONTROLS
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: BorderSide(color: AppColors.accent.withValues(alpha: 0.5)),
                      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(10)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
                      ),
                    ),
                    onPressed: () => controller.recordHeldBall(),
                    icon: const Icon(Icons.sports_basketball, size: 16, color: AppColors.accent),
                    label: Text(
                      'HELD BALL / JUMP BALL',
                      style: AppTypography.labelCaps.copyWith(
                        color: AppColors.accent,
                        fontSize: ResponsiveHelper.sp(11),
                        fontWeight: FontWeight.bold,
                      ).responsive(context),
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(10)),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: Colors.white24),
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.w(12),
                      vertical: ResponsiveHelper.h(10),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
                    ),
                  ),
                  onPressed: () => controller.togglePossessionArrow(),
                  icon: const Icon(Icons.swap_horiz, size: 18, color: Colors.amber),
                  label: Text(
                    'ARROW ⇄',
                    style: AppTypography.labelCaps.copyWith(
                      color: Colors.amber,
                      fontSize: ResponsiveHelper.sp(11),
                      fontWeight: FontWeight.bold,
                    ).responsive(context),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: ResponsiveHelper.h(16)),

          // 5. SECONDARY REFEREE ACTION CONTROLS
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
            child: Row(
              children: [
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.warning_amber_rounded,
                    label: 'FOUL',
                    color: Colors.orangeAccent,
                    onTap: () => _showFoulDialog(context, controller, homeName, awayName),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(6)),
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: Icons.timer_outlined,
                    label: 'TIMEOUT',
                    color: AppColors.warning,
                    onTap: () => _showTimeoutDialog(context, controller, homeName, awayName),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(6)),
                Expanded(
                  child: _buildActionChip(
                    context: context,
                    icon: isRunning ? Icons.pause : Icons.play_arrow,
                    label: isRunning ? 'BREAK' : 'RESUME',
                    color: isRunning ? AppColors.liveRed : AppColors.accent,
                    onTap: () {
                      if (isRunning) {
                        controller.pauseForBreak();
                      } else {
                        controller.resumeFromBreak();
                      }
                    },
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
          ),

          SizedBox(height: ResponsiveHelper.h(16)),
        ],
      );
    });
  }

  Widget _buildTeamScoringCard(
    BuildContext context, {
    required BasketballController controller,
    required String team,
    required String teamName,
    required Color accentColor,
  }) {
    final isEnabled = controller.isMatchStarted.value && !controller.isReadOnly.value;

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(12)),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: accentColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            teamName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.headlineSm.copyWith(
              color: accentColor,
              fontSize: ResponsiveHelper.sp(13),
              fontWeight: FontWeight.bold,
            ).responsive(context),
          ),
          SizedBox(height: ResponsiveHelper.h(10)),
          Row(
            children: [
              Expanded(
                child: _buildPointButton(
                  context,
                  '+1 FT',
                  points: 1,
                  isEnabled: isEnabled,
                  accentColor: accentColor,
                  onTap: () => controller.scorePoints(team, 1),
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(6)),
              Expanded(
                child: _buildPointButton(
                  context,
                  '+2 FG',
                  points: 2,
                  isEnabled: isEnabled,
                  accentColor: accentColor,
                  onTap: () => controller.scorePoints(team, 2),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(6)),
          _buildPointButton(
            context,
            '+3 3-PT',
            points: 3,
            isEnabled: isEnabled,
            accentColor: accentColor,
            isFullWidth: true,
            onTap: () => controller.scorePoints(team, 3),
          ),
        ],
      ),
    );
  }

  Widget _buildPointButton(
    BuildContext context,
    String text, {
    required int points,
    required bool isEnabled,
    required Color accentColor,
    bool isFullWidth = false,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? accentColor : Colors.white10,
          foregroundColor: isEnabled ? Colors.black : AppColors.mutedText,
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(10)),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
          ),
        ),
        onPressed: isEnabled ? onTap : null,
        child: Text(
          text,
          style: AppTypography.headlineSm.copyWith(
            fontSize: ResponsiveHelper.sp(12),
            fontWeight: FontWeight.w900,
          ).responsive(context),
        ),
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

  void _showFoulDialog(BuildContext context, BasketballController controller, String homeName, String awayName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final state = controller.liveState.value;
        if (state == null) return const SizedBox.shrink();

        return Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Record Personal / Technical Foul',
                style: AppTypography.headlineMd.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Side A Foul Section
              _buildFoulTeamList(
                context,
                controller: controller,
                team: 'sideA',
                teamName: homeName,
                players: state.teamA,
                accentColor: AppColors.accent,
              ),

              const SizedBox(height: 16),

              // Side B Foul Section
              _buildFoulTeamList(
                context,
                controller: controller,
                team: 'sideB',
                teamName: awayName,
                players: state.teamB,
                accentColor: const Color(0xFF4D96FF),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFoulTeamList(
    BuildContext context, {
    required BasketballController controller,
    required String team,
    required String teamName,
    required List<BasketballPlayer> players,
    required Color accentColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              teamName,
              style: AppTypography.headlineSm.copyWith(
                color: accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor.withValues(alpha: 0.2),
                foregroundColor: accentColor,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                minimumSize: Size.zero,
              ),
              onPressed: () {
                Navigator.pop(context);
                controller.recordFoul(team);
              },
              child: const Text('Team Foul +1', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: players.map((player) {
            final isFouledOut = player.isFouledOut;
            return ChoiceChip(
              backgroundColor: const Color(0xFF262626),
              selectedColor: Colors.orangeAccent,
              selected: false,
              label: Text(
                '${player.name} (${player.personalFouls}/5 PF)',
                style: AppTypography.bodySm.copyWith(
                  color: isFouledOut ? AppColors.liveRed : AppColors.textPrimary,
                  decoration: isFouledOut ? TextDecoration.lineThrough : null,
                ),
              ),
              avatar: isFouledOut
                  ? const Icon(Icons.block, size: 14, color: AppColors.liveRed)
                  : const Icon(Icons.warning_amber_rounded, size: 14, color: Colors.orangeAccent),
              onSelected: isFouledOut
                  ? null
                  : (_) {
                      Navigator.pop(context);
                      controller.recordFoul(team, playerFouledId: player.id);
                    },
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showTimeoutDialog(BuildContext context, BasketballController controller, String homeName, String awayName) {
    Get.defaultDialog(
      title: 'Call 60s Timeout',
      backgroundColor: AppColors.cardSurface,
      titleStyle: AppTypography.headlineMd.copyWith(color: AppColors.textPrimary),
      content: Column(
        children: [
          ListTile(
            title: Text('Timeout for $homeName', style: AppTypography.bodyMd.copyWith(color: AppColors.textPrimary)),
            onTap: () {
              Get.back();
              controller.useTimeout('sideA');
            },
          ),
          ListTile(
            title: Text('Timeout for $awayName', style: AppTypography.bodyMd.copyWith(color: AppColors.textPrimary)),
            onTap: () {
              Get.back();
              controller.useTimeout('sideB');
            },
          ),
        ],
      ),
    );
  }
}
