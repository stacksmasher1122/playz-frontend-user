import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Kabaddi/kabaddi_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Kabaddi/kabaddi_state_models.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

/// Scoring Action Controls & Workflows for Kabaddi Scoreboard matching attached UI designs.
class KabaddiActionButtons extends StatelessWidget {
  final KabaddiMatchState state;
  final bool canUndo;
  final Function(PlayerSide team, int points) onScoreRaid;
  final Function(PlayerSide) onScoreTackle;
  final Function(PlayerSide)? onScoreAllOut;
  final Function(PlayerSide) onScoreBonusPoint;
  final VoidCallback onSwitchHalf;
  final VoidCallback onUndo;

  const KabaddiActionButtons({
    super.key,
    required this.state,
    required this.canUndo,
    required this.onScoreRaid,
    required this.onScoreTackle,
    this.onScoreAllOut,
    required this.onScoreBonusPoint,
    required this.onSwitchHalf,
    required this.onUndo,
  });

  // ─── STEP 1: ACTIVE RAIDER SELECTION SHEET ───
  void _startRaidWorkflow(
    BuildContext context,
    KabaddiController controller,
    PlayerSide side,
    String teamName,
  ) {
    final team = (side == PlayerSide.sideA) ? state.teamA : state.teamB;
    final activePlayers = team.where((p) => p.isOnCourt).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveHelper.w(24.0)),
        ),
      ),
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(20.0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Drag Handle Pill
              Center(
                child: Container(
                  width: ResponsiveHelper.w(44.0),
                  height: ResponsiveHelper.h(4.5),
                  margin: EdgeInsets.only(bottom: ResponsiveHelper.h(14.0)),
                  decoration: BoxDecoration(
                    color: AppColors.mutedText.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(10.0)),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Active Raider',
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: ResponsiveHelper.sp(18.0),
                      fontWeight: FontWeight.bold,
                    ).responsive(ctx),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: AppColors.mutedText),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveHelper.h(4.0)),
              Text(
                'Active court players for $teamName',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.mutedText,
                  fontSize: ResponsiveHelper.sp(13.0),
                ).responsive(ctx),
              ),
              SizedBox(height: ResponsiveHelper.h(16.0)),

              if (activePlayers.isEmpty)
                // Fallback default players if team list is unpopulated
                Column(
                  children: List.generate(
                    state.config.activePlayersPerTeam,
                    (idx) {
                      final fallbackName = '$teamName Raider ${idx + 1}';
                      return _buildRaiderSelectTile(
                        ctx,
                        name: fallbackName,
                        onTap: () {
                          Navigator.pop(ctx);
                          _showRaidTouchPointsSheet(context, controller, side, teamName, fallbackName);
                        },
                      );
                    },
                  ),
                )
              else
                Column(
                  children: activePlayers.map((player) {
                    return _buildRaiderSelectTile(
                      ctx,
                      name: player.name,
                      onTap: () {
                        Navigator.pop(ctx);
                        _showRaidTouchPointsSheet(context, controller, side, teamName, player.name);
                      },
                    );
                  }).toList(),
                ),
              SizedBox(height: ResponsiveHelper.h(16.0)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRaiderSelectTile(
    BuildContext context, {
    required String name,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.h(8.0)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.w(14.0),
              vertical: ResponsiveHelper.h(12.0),
            ),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
              border: Border.all(color: AppColors.borderDark),
            ),
            child: Row(
              children: [
                Container(
                  width: ResponsiveHelper.w(36.0),
                  height: ResponsiveHelper.w(36.0),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : 'R',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w900,
                      ).responsive(context),
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(12.0)),
                Expanded(
                  child: Text(
                    name,
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveHelper.sp(14.0),
                    ).responsive(context),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.accent,
                  size: ResponsiveHelper.w(20.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── STEP 2: RAID TOUCH POINTS SHEET (MATCHING ATTACHED IMAGE 1) ───
  void _showRaidTouchPointsSheet(
    BuildContext context,
    KabaddiController controller,
    PlayerSide side,
    String teamName,
    String raiderName,
  ) {
    final defendingSide = (side == PlayerSide.sideA) ? PlayerSide.sideB : PlayerSide.sideA;
    final int defendersOnCourt = (defendingSide == PlayerSide.sideA)
        ? state.sideAActiveCount
        : state.sideBActiveCount;

    final raiderTeamOutPlayers = ((side == PlayerSide.sideA) ? state.teamA : state.teamB)
        .where((p) => !p.isOnCourt)
        .toList();

    int touchPoints = 1;
    KabaddiPlayer? selectedRevivedPlayer;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveHelper.w(24.0)),
        ),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setSheetState) {
            return Container(
              padding: EdgeInsets.all(ResponsiveHelper.w(20.0)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      width: ResponsiveHelper.w(44.0),
                      height: ResponsiveHelper.h(4.5),
                      margin: EdgeInsets.only(bottom: ResponsiveHelper.h(14.0)),
                      decoration: BoxDecoration(
                        color: AppColors.mutedText.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(10.0)),
                      ),
                    ),
                  ),

                  // Header Row: Hand Icon + Title + Close X
                  Row(
                    children: [
                      Container(
                        width: ResponsiveHelper.w(42.0),
                        height: ResponsiveHelper.w(42.0),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.accent, width: 1.2),
                        ),
                        child: Icon(
                          Icons.front_hand_rounded,
                          color: AppColors.accent,
                          size: ResponsiveHelper.w(22.0),
                        ),
                      ),
                      SizedBox(width: ResponsiveHelper.w(14.0)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'RAID TOUCH POINTS',
                              style: AppTypography.headlineSm.copyWith(
                                color: AppColors.textPrimary,
                                fontSize: ResponsiveHelper.sp(16.0),
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ).responsive(dialogCtx),
                            ),
                            SizedBox(height: ResponsiveHelper.h(2.0)),
                            RichText(
                              text: TextSpan(
                                text: 'Raider: ',
                                style: AppTypography.bodySm.copyWith(
                                  color: AppColors.mutedText,
                                  fontSize: ResponsiveHelper.sp(13.0),
                                ),
                                children: [
                                  TextSpan(
                                    text: raiderName,
                                    style: const TextStyle(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: AppColors.mutedText),
                        onPressed: () => Navigator.pop(dialogCtx),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveHelper.h(18.0)),

                  // Defenders On Court Info Box
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.w(16.0),
                      vertical: ResponsiveHelper.h(14.0),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
                      border: Border.all(color: AppColors.borderDark),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.people_outline_rounded,
                          color: AppColors.accent,
                          size: ResponsiveHelper.w(24.0),
                        ),
                        SizedBox(width: ResponsiveHelper.w(12.0)),
                        Expanded(
                          child: Text(
                            'Defenders on court',
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.mutedText,
                              fontSize: ResponsiveHelper.sp(14.0),
                              fontWeight: FontWeight.w600,
                            ).responsive(dialogCtx),
                          ),
                        ),
                        Text(
                          '$defendersOnCourt',
                          style: AppTypography.displayLg.copyWith(
                            color: AppColors.accent,
                            fontSize: ResponsiveHelper.sp(26.0),
                            fontWeight: FontWeight.w900,
                          ).responsive(dialogCtx),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.h(20.0)),

                  // Prompt Text
                  Center(
                    child: Text(
                      'How many touch points did the raider score?',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.mutedText,
                        fontSize: ResponsiveHelper.sp(13.5),
                        fontWeight: FontWeight.w500,
                      ).responsive(dialogCtx),
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.h(14.0)),

                  // Touch Points Stepper Box
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.w(20.0),
                      vertical: ResponsiveHelper.h(14.0),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
                      border: Border.all(color: AppColors.borderDark),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Minus Button
                        IconButton(
                          onPressed: () {
                            if (touchPoints > 1) {
                              setSheetState(() => touchPoints--);
                            }
                          },
                          icon: Container(
                            width: ResponsiveHelper.w(36.0),
                            height: ResponsiveHelper.w(36.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.error, width: 1.5),
                            ),
                            child: Icon(
                              Icons.remove_rounded,
                              color: AppColors.error,
                              size: ResponsiveHelper.w(20.0),
                            ),
                          ),
                        ),

                        // Points Display
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$touchPoints',
                              style: AppTypography.displayLg.copyWith(
                                color: AppColors.textPrimary,
                                fontSize: ResponsiveHelper.sp(28.0),
                                fontWeight: FontWeight.w900,
                              ).responsive(dialogCtx),
                            ),
                            Text(
                              touchPoints == 1 ? 'TOUCH POINT' : 'TOUCH POINTS',
                              style: AppTypography.labelCaps.copyWith(
                                color: AppColors.mutedText,
                                fontSize: ResponsiveHelper.sp(10.0),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ).responsive(dialogCtx),
                            ),
                          ],
                        ),

                        // Plus Button
                        IconButton(
                          onPressed: () {
                            if (touchPoints < defendersOnCourt) {
                              setSheetState(() => touchPoints++);
                            }
                          },
                          icon: Container(
                            width: ResponsiveHelper.w(36.0),
                            height: ResponsiveHelper.w(36.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.accent, width: 1.5),
                            ),
                            child: Icon(
                              Icons.add_rounded,
                              color: AppColors.accent,
                              size: ResponsiveHelper.w(20.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.h(16.0)),

                  // Optional Revival Selector (if out players exist)
                  if (raiderTeamOutPlayers.isNotEmpty) ...[
                    Text(
                      'Select player to revive (Optional)',
                      style: AppTypography.labelCaps.copyWith(
                        color: AppColors.mutedText,
                        fontSize: ResponsiveHelper.sp(11.0),
                        fontWeight: FontWeight.bold,
                      ).responsive(dialogCtx),
                    ),
                    SizedBox(height: ResponsiveHelper.h(8.0)),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: ResponsiveHelper.h(100.0)),
                      child: SingleChildScrollView(
                        child: Column(
                          children: raiderTeamOutPlayers.map((p) {
                            final isSel = (selectedRevivedPlayer?.id == p.id);
                            return InkWell(
                              onTap: () {
                                setSheetState(() {
                                  selectedRevivedPlayer = isSel ? null : p;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: ResponsiveHelper.h(6.0)),
                                padding: EdgeInsets.symmetric(
                                  horizontal: ResponsiveHelper.w(12.0),
                                  vertical: ResponsiveHelper.h(8.0),
                                ),
                                decoration: BoxDecoration(
                                  color: isSel
                                      ? AppColors.accent.withValues(alpha: 0.15)
                                      : AppColors.background,
                                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(10.0)),
                                  border: Border.all(
                                    color: isSel ? AppColors.accent : AppColors.borderDark,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      p.name,
                                      style: TextStyle(
                                        color: isSel ? AppColors.accent : AppColors.textPrimary,
                                        fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                    const Spacer(),
                                    if (isSel)
                                      const Icon(Icons.check_circle_rounded,
                                          color: AppColors.accent, size: 18),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.h(16.0)),
                  ],

                  // Action Buttons Row (CANCEL | CONFIRM RAID SCORE)
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: ResponsiveHelper.h(48.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.background,
                              foregroundColor: AppColors.textPrimary,
                              elevation: 0,
                              side: const BorderSide(color: AppColors.borderDark),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
                              ),
                            ),
                            onPressed: () => Navigator.pop(dialogCtx),
                            child: Text(
                              'CANCEL',
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: ResponsiveHelper.sp(13.0),
                              ).responsive(dialogCtx),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: ResponsiveHelper.w(12.0)),
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: ResponsiveHelper.h(48.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              foregroundColor: AppColors.background,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(dialogCtx);
                              controller.scoreRaidPoint(
                                side,
                                points: touchPoints,
                                revivedPlayerId: selectedRevivedPlayer?.id,
                              );
                            },
                            child: Text(
                              'CONFIRM RAID SCORE',
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.background,
                                fontWeight: FontWeight.w900,
                                fontSize: ResponsiveHelper.sp(13.0),
                                letterSpacing: 0.5,
                              ).responsive(dialogCtx),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveHelper.h(10.0)),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ─── WORKFLOW 2: SUCCESSFUL TACKLE SHEET (MATCHING ATTACHED IMAGE 2) ───
  void _showSuccessfulTackleSheet(
    BuildContext context,
    KabaddiController controller,
  ) {
    final sideAName = controller.homeTeamName.value.isNotEmpty
        ? controller.homeTeamName.value
        : (state.teamA.isNotEmpty ? state.teamA.first.name : 'Side A');

    final sideBName = controller.awayTeamName.value.isNotEmpty
        ? controller.awayTeamName.value
        : (state.teamB.isNotEmpty ? state.teamB.first.name : 'Side B');

    PlayerSide selectedDefenseSide = PlayerSide.sideA;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveHelper.w(24.0)),
        ),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setSheetState) {
            final outDefenders = ((selectedDefenseSide == PlayerSide.sideA) ? state.teamA : state.teamB)
                .where((p) => !p.isOnCourt)
                .toList();

            return Container(
              padding: EdgeInsets.all(ResponsiveHelper.w(20.0)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Drag Handle Pill
                  Center(
                    child: Container(
                      width: ResponsiveHelper.w(44.0),
                      height: ResponsiveHelper.h(4.5),
                      margin: EdgeInsets.only(bottom: ResponsiveHelper.h(14.0)),
                      decoration: BoxDecoration(
                        color: AppColors.mutedText.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(10.0)),
                      ),
                    ),
                  ),

                  // Header Row: Shield Icon + Title + Close X
                  Row(
                    children: [
                      Container(
                        width: ResponsiveHelper.w(42.0),
                        height: ResponsiveHelper.w(42.0),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.accent, width: 1.2),
                        ),
                        child: Icon(
                          Icons.shield_rounded,
                          color: AppColors.accent,
                          size: ResponsiveHelper.w(22.0),
                        ),
                      ),
                      SizedBox(width: ResponsiveHelper.w(14.0)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'SUCCESSFUL TACKLE',
                              style: AppTypography.headlineSm.copyWith(
                                color: AppColors.textPrimary,
                                fontSize: ResponsiveHelper.sp(16.0),
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ).responsive(dialogCtx),
                            ),
                            SizedBox(height: ResponsiveHelper.h(2.0)),
                            Text(
                              'Select which defense team completed the tackle.',
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.mutedText,
                                fontSize: ResponsiveHelper.sp(12.5),
                              ).responsive(dialogCtx),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: AppColors.mutedText),
                        onPressed: () => Navigator.pop(dialogCtx),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveHelper.h(18.0)),

                  // Award Info Banner Box
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.w(14.0),
                      vertical: ResponsiveHelper.h(12.0),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
                      border: Border.all(color: AppColors.borderDark),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: ResponsiveHelper.w(32.0),
                          height: ResponsiveHelper.w(32.0),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '+1',
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w900,
                                fontSize: ResponsiveHelper.sp(13.0),
                              ).responsive(dialogCtx),
                            ),
                          ),
                        ),
                        SizedBox(width: ResponsiveHelper.w(12.0)),
                        Expanded(
                          child: Text(
                            'Award +1 point & revive 1 defender',
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: ResponsiveHelper.sp(13.5),
                              fontWeight: FontWeight.w600,
                            ).responsive(dialogCtx),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.h(20.0)),

                  // Side-by-Side Defense Team Cards
                  Row(
                    children: [
                      // Side A Defense Card (Red)
                      Expanded(
                        child: _buildDefenseTeamCard(
                          dialogCtx,
                          teamName: sideAName,
                          side: PlayerSide.sideA,
                          isSelected: (selectedDefenseSide == PlayerSide.sideA),
                          accentColor: AppColors.error,
                          onSelect: () => setSheetState(() => selectedDefenseSide = PlayerSide.sideA),
                        ),
                      ),
                      SizedBox(width: ResponsiveHelper.w(14.0)),

                      // Side B Defense Card (Green)
                      Expanded(
                        child: _buildDefenseTeamCard(
                          dialogCtx,
                          teamName: sideBName,
                          side: PlayerSide.sideB,
                          isSelected: (selectedDefenseSide == PlayerSide.sideB),
                          accentColor: AppColors.accent,
                          onSelect: () => setSheetState(() => selectedDefenseSide = PlayerSide.sideB),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveHelper.h(16.0)),

                  // Optional Defender Revival Picker (if out defenders exist)
                  if (outDefenders.isNotEmpty) ...[
                    Text(
                      'Select defender to revive (Optional)',
                      style: AppTypography.labelCaps.copyWith(
                        color: AppColors.mutedText,
                        fontSize: ResponsiveHelper.sp(11.0),
                        fontWeight: FontWeight.bold,
                      ).responsive(dialogCtx),
                    ),
                    SizedBox(height: ResponsiveHelper.h(8.0)),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: ResponsiveHelper.h(90.0)),
                      child: SingleChildScrollView(
                        child: Column(
                          children: outDefenders.map((p) {
                            return Container(
                              margin: EdgeInsets.only(bottom: ResponsiveHelper.h(6.0)),
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveHelper.w(12.0),
                                vertical: ResponsiveHelper.h(8.0),
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(ResponsiveHelper.w(10.0)),
                                border: Border.all(color: AppColors.borderDark),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    p.name,
                                    style: AppTypography.bodySm.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ).responsive(dialogCtx),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.favorite_rounded,
                                      color: AppColors.accent, size: 16),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.h(12.0)),
                  ],

                  // Bottom Info Tip
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.accent,
                        size: ResponsiveHelper.w(18.0),
                      ),
                      SizedBox(width: ResponsiveHelper.w(8.0)),
                      Expanded(
                        child: Text(
                          'The selected team gets +1 point and one defender will be revived.',
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.mutedText,
                            fontSize: ResponsiveHelper.sp(12.0),
                          ).responsive(dialogCtx),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveHelper.h(16.0)),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDefenseTeamCard(
    BuildContext context, {
    required String teamName,
    required PlayerSide side,
    required bool isSelected,
    required Color accentColor,
    required VoidCallback onSelect,
  }) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(14.0)),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(18.0)),
        border: Border.all(
          color: isSelected ? accentColor : AppColors.borderDark,
          width: isSelected ? 2.0 : 1.0,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Shield Badge
          Container(
            width: ResponsiveHelper.w(48.0),
            height: ResponsiveHelper.w(48.0),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shield_rounded,
              color: accentColor,
              size: ResponsiveHelper.w(26.0),
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(10.0)),

          // Team Name
          Text(
            teamName,
            textAlign: TextAlign.center,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textPrimary,
              fontSize: ResponsiveHelper.sp(14.0),
              fontWeight: FontWeight.bold,
            ).responsive(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: ResponsiveHelper.h(2.0)),
          Text(
            'Defense Team',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.mutedText,
              fontSize: ResponsiveHelper.sp(11.0),
            ).responsive(context),
          ),
          SizedBox(height: ResponsiveHelper.h(12.0)),

          // SELECT Button
          SizedBox(
            width: double.infinity,
            height: ResponsiveHelper.h(38.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: AppColors.background,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(10.0)),
                ),
              ),
              onPressed: () {
                onSelect();
                onScoreTackle(side);
                Navigator.pop(context);
              },
              child: Text(
                'SELECT',
                style: AppTypography.labelCaps.copyWith(
                  color: AppColors.background,
                  fontSize: ResponsiveHelper.sp(12.0),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ).responsive(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<KabaddiController>();

    final sideAName = controller.homeTeamName.value.isNotEmpty
        ? controller.homeTeamName.value
        : (state.teamA.isNotEmpty ? state.teamA.first.name : 'Side A');

    final sideBName = controller.awayTeamName.value.isNotEmpty
        ? controller.awayTeamName.value
        : (state.teamB.isNotEmpty ? state.teamB.first.name : 'Side B');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Row 1: 2 Large Raid Points Action Cards (Red Side A | Green Side B)
        Row(
          children: [
            // Left Raid Points Card (Red Theme)
            Expanded(
              child: _buildRaidCardTile(
                context,
                teamName: sideAName,
                backgroundColor: AppColors.error,
                onTap: () => _startRaidWorkflow(
                  context,
                  controller,
                  PlayerSide.sideA,
                  sideAName,
                ),
              ),
            ),
            SizedBox(width: ResponsiveHelper.w(12.0)),

            // Right Raid Points Card (Green Theme)
            Expanded(
              child: _buildRaidCardTile(
                context,
                teamName: sideBName,
                backgroundColor: AppColors.accent,
                onTap: () => _startRaidWorkflow(
                  context,
                  controller,
                  PlayerSide.sideB,
                  sideBName,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveHelper.h(12.0)),

        // Row 2: 3 Bottom Action Control Tiles (UNDO | EMPTY RAID | TACKLE)
        Row(
          children: [
            // 1. UNDO Button (Text UNDO in green)
            Expanded(
              child: _buildActionTile(
                context,
                label: 'UNDO',
                textColor: canUndo ? AppColors.accent : AppColors.mutedText,
                borderColor: canUndo ? AppColors.accent : AppColors.borderDark,
                onTap: canUndo ? onUndo : null,
              ),
            ),
            SizedBox(width: ResponsiveHelper.w(10.0)),

            // 2. EMPTY RAID Button
            Expanded(
              child: _buildActionTile(
                context,
                label: state.isCurrentRaidDoOrDie ? 'DO-OR-DIE FAIL' : 'EMPTY RAID',
                textColor: state.isCurrentRaidDoOrDie ? AppColors.error : AppColors.textPrimary,
                borderColor: AppColors.borderDark,
                onTap: () => controller.scoreEmptyRaid(state.raidingSide),
              ),
            ),
            SizedBox(width: ResponsiveHelper.w(10.0)),

            // 3. TACKLE Button
            Expanded(
              child: _buildActionTile(
                context,
                label: 'TACKLE',
                textColor: const Color(0xFF4D96FF), // Blue Accent
                borderColor: const Color(0xFF4D96FF).withValues(alpha: 0.6),
                onTap: () => _showSuccessfulTackleSheet(context, controller),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRaidCardTile(
    BuildContext context, {
    required String teamName,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.w(14.0),
            vertical: ResponsiveHelper.h(12.0),
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
          ),
          child: Row(
            children: [
              // Flash Icon
              Icon(
                Icons.flash_on_rounded,
                color: AppColors.background,
                size: ResponsiveHelper.w(22.0),
              ),
              SizedBox(width: ResponsiveHelper.w(8.0)),

              // Subtitle & Team Name Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'RAID POINTS',
                      style: AppTypography.labelCaps.copyWith(
                        color: AppColors.background.withValues(alpha: 0.8),
                        fontSize: ResponsiveHelper.sp(9.0),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ).responsive(context),
                    ),
                    SizedBox(height: ResponsiveHelper.h(2.0)),
                    Text(
                      teamName,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.background,
                        fontSize: ResponsiveHelper.sp(13.0),
                        fontWeight: FontWeight.w900,
                      ).responsive(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Right Chevron Arrow Icon
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.background,
                size: ResponsiveHelper.w(22.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required String label,
    required Color textColor,
    required Color borderColor,
    required VoidCallback? onTap,
  }) {
    final bool isEnabled = (onTap != null);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12.0)),
        child: Container(
          height: ResponsiveHelper.h(46.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(12.0)),
            border: Border.all(
              color: isEnabled ? borderColor : AppColors.borderDark,
              width: 1.2,
            ),
          ),
          child: Text(
            label,
            style: AppTypography.labelCaps.copyWith(
              color: isEnabled ? textColor : AppColors.mutedText,
              fontSize: ResponsiveHelper.sp(11.0),
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ).responsive(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
