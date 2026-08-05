import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Kabaddi/kabaddi_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Kabaddi/kabaddi_state_models.dart';

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

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KabaddiController>();
    final sideAName = state.teamA.isNotEmpty ? state.teamA.first.name : 'Side A';
    final sideBName = state.teamB.isNotEmpty ? state.teamB.first.name : 'Side B';
    final isFriendly = state.config.isFriendlyRules;

    final isRaidingA = state.raidingSide == PlayerSide.sideA;
    final defCount = isRaidingA ? state.sideBActiveCount : state.sideAActiveCount;
    final isBonusEligible = defCount >= 6;

    return Obx(() {
      final isStarted = controller.isMatchStarted.value;
      final isClockActive = controller.isTimerRunning.value;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 0. Initial Start Match Button (Disappears completely once match is started!)
          if (!isStarted) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(14)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: controller.startMatch,
                icon: const Icon(Icons.play_arrow, color: Colors.black, size: 22),
                label: Text(
                  'START MATCH NOW',
                  style: AppTypography.headlineSm.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: context.responsiveFont(14),
                  ),
                ),
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(8)),
          ],

          // 1. Primary Scoring Actions (Raid Points Side A / Side B)
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isStarted ? AppColors.error : AppColors.cardDark,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: isStarted
                      ? () => _showRaidPointsDialog(context, controller, PlayerSide.sideA, sideAName)
                      : null,
                  icon: const Icon(Icons.flash_on, size: 20),
                  label: Flexible(
                    child: Text(
                      'Raid Points $sideAName',
                      style: AppTypography.headlineSm.copyWith(
                        color: Colors.white,
                        fontSize: context.responsiveFont(12),
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(10)),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isStarted ? AppColors.primary : AppColors.cardDark,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: isStarted
                      ? () => _showRaidPointsDialog(context, controller, PlayerSide.sideB, sideBName)
                      : null,
                  icon: const Icon(Icons.flash_on, size: 20),
                  label: Flexible(
                    child: Text(
                      'Raid Points $sideBName',
                      style: AppTypography.headlineSm.copyWith(
                        color: Colors.white,
                        fontSize: context.responsiveFont(12),
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(8)),

          // 2. Secondary Scoring Actions (Empty Raid, Tackle, Bonus, Sub, Break, Undo)
          Row(
            children: [
              // Undo Button
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: canUndo ? AppColors.surfaceElevated : AppColors.cardDark,
                  side: BorderSide(color: canUndo ? AppColors.primaryGreen : AppColors.borderDark),
                  padding: const EdgeInsets.all(8),
                ),
                onPressed: canUndo ? onUndo : null,
                icon: Icon(
                  Icons.undo_rounded,
                  color: canUndo ? AppColors.primaryGreen : AppColors.mutedText,
                  size: 20,
                ),
                tooltip: 'Undo',
              ),
              SizedBox(width: ResponsiveHelper.w(6)),

              // Empty Raid
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey,
                    side: const BorderSide(color: Colors.grey),
                    padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(8)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: isStarted ? () => controller.scoreEmptyRaid(state.raidingSide) : null,
                  child: Text(
                    state.isCurrentRaidDoOrDie ? 'DO-OR-DIE FAIL' : 'EMPTY RAID',
                    style: AppTypography.bodySm.copyWith(
                      color: state.isCurrentRaidDoOrDie ? AppColors.error : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: context.responsiveFont(10),
                    ),
                  ),
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(6)),

              // Tackle Point
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.infoBlue,
                    side: const BorderSide(color: AppColors.infoBlue),
                    padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(8)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: isStarted ? () => _showTackleDialog(context) : null,
                  child: Text(
                    'TACKLE',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.infoBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: context.responsiveFont(11),
                    ),
                  ),
                ),
              ),

              if (controller.subsEnabled.value) ...[
                SizedBox(width: ResponsiveHelper.w(6)),
                // Substitute Rotation Button
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orangeAccent,
                      side: const BorderSide(color: Colors.orangeAccent),
                      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(8)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: isStarted ? () => _showSubstitutionDialog(context, controller) : null,
                    child: Text(
                      'SUB',
                      style: AppTypography.bodySm.copyWith(
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: context.responsiveFont(11),
                      ),
                    ),
                  ),
                ),
              ],

              if (!isFriendly) ...[
                SizedBox(width: ResponsiveHelper.w(6)),
                // Bonus Point (+1) (Guarded: 6+ defenders on court)
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: (isStarted && isBonusEligible) ? AppColors.coinsGold : AppColors.mutedText,
                      side: BorderSide(color: (isStarted && isBonusEligible) ? AppColors.coinsGold : AppColors.borderDark),
                      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(8)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: (isStarted && isBonusEligible) ? () => _showBonusDialog(context) : null,
                    child: Text(
                      'BONUS',
                      style: AppTypography.bodySm.copyWith(
                        color: (isStarted && isBonusEligible) ? AppColors.coinsGold : AppColors.mutedText,
                        fontWeight: FontWeight.bold,
                        fontSize: context.responsiveFont(11),
                      ),
                    ),
                  ),
                ),
              ],

              if (isStarted) ...[
                SizedBox(width: ResponsiveHelper.w(6)),
                // Official Break / Resume Clock Toggle Button
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isClockActive ? Colors.amber : AppColors.primaryGreen,
                    side: BorderSide(color: isClockActive ? Colors.amber : AppColors.primaryGreen),
                    padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(8)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: isClockActive ? controller.pauseForBreak : controller.resumeFromBreak,
                  child: Text(
                    isClockActive ? 'BREAK' : 'RESUME',
                    style: AppTypography.bodySm.copyWith(
                      color: isClockActive ? Colors.amber : AppColors.primaryGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: context.responsiveFont(11),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      );
    });
  }

  void _showRaidPointsDialog(
    BuildContext context,
    KabaddiController controller,
    PlayerSide side,
    String sideName,
  ) {
    final maxDefendersOnCourt = side == PlayerSide.sideA
        ? state.sideBActiveCount
        : state.sideAActiveCount;
    int selectedPoints = 1;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogCtx, setState) => AlertDialog(
          backgroundColor: AppColors.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'RAID TOUCH POINTS ($sideName)',
            style: AppTypography.headlineSm.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Defenders on court: $maxDefendersOnCourt\nHow many touch points did raider score?',
                style: AppTypography.bodyMd.copyWith(color: AppColors.mutedText),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Dynamic Touch Stepper Card (Max capped at current court defenders)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderDark),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: AppColors.error, size: 28),
                      onPressed: selectedPoints > 1
                          ? () => setState(() => selectedPoints--)
                          : null,
                    ),
                    Column(
                      children: [
                        Text(
                          '$selectedPoints Touch Point${selectedPoints > 1 ? 's' : ''}',
                          style: TextStyle(
                            color: selectedPoints >= 3 ? AppColors.coinsGold : Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (selectedPoints >= 3)
                          const Text(
                            '⭐ SUPER RAID! ⭐',
                            style: TextStyle(color: AppColors.coinsGold, fontSize: 10, fontWeight: FontWeight.w900),
                          ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryGreen, size: 28),
                      onPressed: selectedPoints < maxDefendersOnCourt
                          ? () => setState(() => selectedPoints++)
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('CANCEL', style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(ctx);
                onScoreRaid(side, selectedPoints);
              },
              child: const Text('CONFIRM RAID SCORE', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showSubstitutionDialog(BuildContext context, KabaddiController controller) {
    final sideAName = state.teamA.isNotEmpty ? state.teamA.first.name : 'Side A';
    final sideBName = state.teamB.isNotEmpty ? state.teamB.first.name : 'Side B';

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        PlayerSide selectedSide = PlayerSide.sideA;
        KabaddiPlayer? outPlayer;
        KabaddiPlayer? inPlayer;

        return StatefulBuilder(
          builder: (sheetCtx, setState) {
            final currentPlayers = selectedSide == PlayerSide.sideA ? state.teamA : state.teamB;
            final onCourt = currentPlayers.where((p) => p.isOnCourt).toList();
            final reserves = currentPlayers.where((p) => !p.isOnCourt).toList();

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PLAYER SUBSTITUTION (ROTATION)',
                    style: AppTypography.headlineSm.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Side Selector
                  Row(
                    children: [
                      ChoiceChip(
                        label: Text(sideAName),
                        selected: selectedSide == PlayerSide.sideA,
                        onSelected: (val) {
                          if (val) {
                            setState(() {
                              selectedSide = PlayerSide.sideA;
                              outPlayer = null;
                              inPlayer = null;
                            });
                          }
                        },
                      ),
                      const SizedBox(width: 12),
                      ChoiceChip(
                        label: Text(sideBName),
                        selected: selectedSide == PlayerSide.sideB,
                        onSelected: (val) {
                          if (val) {
                            setState(() {
                              selectedSide = PlayerSide.sideB;
                              outPlayer = null;
                              inPlayer = null;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Player Out Dropdown
                  Text('Player Coming Off (Out):', style: TextStyle(color: AppColors.mutedText, fontSize: 12)),
                  DropdownButton<KabaddiPlayer>(
                    dropdownColor: AppColors.cardDark,
                    isExpanded: true,
                    value: outPlayer,
                    hint: const Text('Select player on court', style: TextStyle(color: Colors.white70)),
                    items: onCourt.map((p) {
                      return DropdownMenuItem(value: p, child: Text(p.name, style: const TextStyle(color: Colors.white)));
                    }).toList(),
                    onChanged: (val) => setState(() => outPlayer = val),
                  ),
                  const SizedBox(height: 12),

                  // Player In Dropdown
                  Text('Reserve Coming On (In):', style: TextStyle(color: AppColors.mutedText, fontSize: 12)),
                  DropdownButton<KabaddiPlayer>(
                    dropdownColor: AppColors.cardDark,
                    isExpanded: true,
                    value: inPlayer,
                    hint: const Text('Select reserve player', style: TextStyle(color: Colors.white70)),
                    items: reserves.map((p) {
                      return DropdownMenuItem(value: p, child: Text(p.name, style: const TextStyle(color: Colors.white)));
                    }).toList(),
                    onChanged: (val) => setState(() => inPlayer = val),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
                      onPressed: (outPlayer != null && inPlayer != null)
                          ? () {
                              controller.substitutePlayer(selectedSide, outPlayer!, inPlayer!);
                              Navigator.pop(sheetCtx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Substituted ${outPlayer!.name} with ${inPlayer!.name}'),
                                  backgroundColor: AppColors.card,
                                ),
                              );
                            }
                          : null,
                      child: const Text('CONFIRM ROTATION', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showTackleDialog(BuildContext context) {
    final sideAName = state.teamA.isNotEmpty ? state.teamA.first.name : 'Side A';
    final sideBName = state.teamB.isNotEmpty ? state.teamB.first.name : 'Side B';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text('Successful Tackle By', style: AppTypography.headlineMd.copyWith(color: AppColors.textPrimary)),
        content: Text('Select which defense team completed the tackle (+1 point & revives 1 defender):', style: AppTypography.bodyMd.copyWith(color: AppColors.mutedText)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onScoreTackle(PlayerSide.sideA);
            },
            child: Text(sideAName, style: const TextStyle(color: AppColors.error)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onScoreTackle(PlayerSide.sideB);
            },
            child: Text(sideBName, style: const TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showBonusDialog(BuildContext context) {
    final sideAName = state.teamA.isNotEmpty ? state.teamA.first.name : 'Side A';
    final sideBName = state.teamB.isNotEmpty ? state.teamB.first.name : 'Side B';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text('Award Bonus Point (+1)', style: AppTypography.headlineMd.copyWith(color: AppColors.textPrimary)),
        content: Text('Select which raider crossed bonus line (6+ defenders on court):', style: AppTypography.bodyMd.copyWith(color: AppColors.mutedText)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onScoreBonusPoint(PlayerSide.sideA);
            },
            child: Text(sideAName, style: const TextStyle(color: AppColors.error)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onScoreBonusPoint(PlayerSide.sideB);
            },
            child: Text(sideBName, style: const TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
