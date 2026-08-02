import 'dart:async';
import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/cricket_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_state_models.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Cricket/cricket_scoreboard/widgets/advanced_actions_grid.dart';
import 'package:redesign/view/USER/Navigation/user_navigation.dart';
import 'package:redesign/view/USER/Home/scoreboard_screen/scoreboards_screen.dart';

// Internal Imports
import 'widgets/scoreboard_header.dart';
import 'widgets/over_progress_row.dart';
import 'widgets/match_context_card.dart';
import 'widgets/player_stats_tabs.dart';
import 'widgets/ball_timeline.dart';
import 'widgets/scoring_console.dart';
import 'widgets/setup_wizard_card.dart';
import 'widgets/bowler_select_sheet.dart';
import 'widgets/extras_modal.dart';
import 'widgets/wicket_wizard_sheet.dart';
import 'widgets/match_break_timer_sheet.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CricketScoreboardScreen extends StatefulWidget {
  const CricketScoreboardScreen({super.key});

  @override
  State<CricketScoreboardScreen> createState() =>
      _CricketScoreboardScreenState();
}

class _CricketScoreboardScreenState extends State<CricketScoreboardScreen> {
  late final CricketController controller;

  MatchState get s => controller.liveState.value!;

  int get totalRuns => s.totalRuns;
  int get wickets => s.wickets;
  int get overs => s.overs;
  int get balls => s.balls;
  int get inningsNumber => s.inningsNumber;
  int? get targetScore => s.targetScore;
  String get matchStatus => s.matchStatus;

  List<Player> get battingTeam => s.battingTeam;
  List<Player> get bowlingTeam => s.bowlingTeam;
  Player? get striker => s.striker;
  Player? get nonStriker => s.nonStriker;
  Player? get currentBowler => s.currentBowler;
  Player? get previousBowler {
    if (s.previousBowler != null && s.previousBowler!.name != currentBowler?.name) {
      return s.previousBowler;
    }
    final currentName = currentBowler?.name;
    for (final ball in ballHistory.reversed) {
      if (ball.bowlerName != null && ball.bowlerName != currentName) {
        final found = bowlingTeam.where((p) => p.name == ball.bowlerName).firstOrNull;
        if (found != null) return found;
      }
    }
    return null;
  }

  List<BallEvent> get ballHistory => s.ballHistory;
  List<BallEvent> get currentOverBalls => s.currentOverBalls;

  int get partnershipRuns => s.partnership?.runs ?? 0;
  int get partnershipBalls => s.partnership?.balls ?? 0;

  @override
  void initState() {
    super.initState();
    controller = Get.find<CricketController>();
  }

  String get oversDisplay => '$overs.$balls';
  double get currentRunRate =>
      overs > 0 || balls > 0 ? totalRuns / (overs + balls / 6) : 0;
  double get requiredRunRate {
    if (targetScore == null) return 0;
    final remaining = targetScore! - totalRuns;
    final totalOvers = controller.engine.maxOvers;
    final oversRemaining = totalOvers - overs - balls / 6;
    return oversRemaining > 0 ? remaining / oversRemaining : 0;
  }

  int get projectedScore {
    final rate = currentRunRate;
    return (rate * controller.engine.maxOvers).round();
  }

  double get winProbability {
    if (targetScore == null) return 0.5;
    final progress = totalRuns / targetScore!;
    // E2: Use the match's actual maxWickets instead of hardcoded 10.
    final mw = controller.engine.maxWickets;
    return (progress * 0.8 + (1 - wickets / mw) * 0.2).clamp(0.0, 1.0);
  }

  // Scoring Logic
  void _addRuns(int runs) {
    if (matchStatus != 'LIVE_INNINGS_1' && matchStatus != 'LIVE_INNINGS_2') {
      return;
    }
    int prevOvers = overs;
    controller.addRuns(runs);
    if (overs > prevOvers &&
        (matchStatus == 'LIVE_INNINGS_1' || matchStatus == 'LIVE_INNINGS_2')) {
      _showBowlerChangeDialog();
    }
    if (matchStatus == 'INNINGS_BREAK') _showInningsBreakDialog();
    if (matchStatus == 'MATCH_COMPLETED') _endMatch();
  }

  void _retireBatter(Player p, bool isHurt) {
    if (matchStatus != 'LIVE_INNINGS_1' && matchStatus != 'LIVE_INNINGS_2') {
      return;
    }
    final status = isHurt ? PlayerStatus.retiredHurt : PlayerStatus.retiredOut;
    // B4: Use the engine's dedicated retireBatter() method which preserves
    // undo history, instead of restoreState() which wipes it.
    controller.engine.retireBatter(p.name, status);
    controller.updateEngineState();
    Get.snackbar(
      'Retired',
      '${p.name} retired ${isHurt ? "hurt" : "out"}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.surface,
      colorText: Colors.white70,
    );
  }

  void _addExtra(ExtraType type, int additionalRuns) {
    if (matchStatus != 'LIVE_INNINGS_1' && matchStatus != 'LIVE_INNINGS_2') {
      return;
    }
    int prevOvers = overs;
    controller.addExtra(type, additionalRuns);
    if (overs > prevOvers &&
        (matchStatus == 'LIVE_INNINGS_1' || matchStatus == 'LIVE_INNINGS_2')) {
      _showBowlerChangeDialog();
    }
    if (matchStatus == 'INNINGS_BREAK') _showInningsBreakDialog();
    if (matchStatus == 'MATCH_COMPLETED') _endMatch();
  }

  void _addWicket(
    DismissalType type, {
    String? fielder,
    Player? newBatter,
    bool newBatterOnStrike = true,
    String? outPlayer = 'striker',
    bool crossed = false,
  }) {
    if (matchStatus != 'LIVE_INNINGS_1' && matchStatus != 'LIVE_INNINGS_2') {
      return;
    }
    int prevOvers = overs;
    controller.addWicket(
      type,
      fielder: fielder,
      newBatterName: newBatter?.name,
      newBatterOnStrike: newBatterOnStrike,
      outPlayer: outPlayer,
      crossed: crossed,
    );
    if (overs > prevOvers &&
        (matchStatus == 'LIVE_INNINGS_1' || matchStatus == 'LIVE_INNINGS_2')) {
      _showBowlerChangeDialog();
    }
    if (matchStatus == 'INNINGS_BREAK') _showInningsBreakDialog();
    if (matchStatus == 'MATCH_COMPLETED') _endMatch();
  }

  void _changeBowler(Player newBowler) {
    try {
      controller.changeBowler(newBowler.name);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void _undo() {
    if (!controller.engine.canUndo) return;

    controller.undoEvent();

    if (balls == 0 &&
        overs > 0 &&
        matchStatus.startsWith('LIVE_') &&
        currentOverBalls.isEmpty) {
      Future.microtask(() => _showBowlerChangeDialog());
    }
  }

  // Workflows & Dialogs
  void _showInningsBreakDialog() {
    int target = totalRuns + 1;
    int timeLeft = 60;
    Timer? countdownTimer;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            countdownTimer ??= Timer.periodic(const Duration(seconds: 1), (
              timer,
            ) {
              if (timeLeft > 0) {
                if (mounted) {
                  setState(() {
                    timeLeft--;
                  });
                }
              } else {
                timer.cancel();
                if (Navigator.canPop(dialogContext)) {
                  Navigator.pop(dialogContext);
                }
                controller.startSecondInnings();
              }
            });

            final bool canUndoInningsBreak =
                !controller.hasInningsBreakUndoBeenUsed.value &&
                controller.engine.canUndo;

            final String formattedTime =
                '00:${timeLeft.toString().padLeft(2, '0')}';

            return AlertDialog(
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  const Icon(Icons.pause_circle_outline_rounded, color: AppColors.accent),
                  const SizedBox(width: 8),
                  const Text(
                    'Innings Break',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '1st Innings Ended: ${s.matchConfig.battingTeamName} scored $totalRuns/$wickets',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.sp(14),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Target for ${s.matchConfig.bowlingTeamName} is $target runs',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: ResponsiveHelper.sp(16),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.timer_outlined, color: AppColors.muted, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          '2nd Innings starts in $formattedTime',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!canUndoInningsBreak && controller.hasInningsBreakUndoBeenUsed.value) ...[
                    const SizedBox(height: 12),
                    const Text(
                      'Innings-break undo already used (1/1)',
                      style: TextStyle(color: AppColors.muted, fontSize: 11, fontStyle: FontStyle.italic),
                    ),
                  ],
                ],
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                if (canUndoInningsBreak)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error.withValues(alpha: 0.2),
                      foregroundColor: AppColors.error,
                      elevation: 0,
                      side: const BorderSide(color: AppColors.error, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      controller.hasInningsBreakUndoBeenUsed.value = true;
                      countdownTimer?.cancel();
                      Navigator.pop(dialogContext);
                      _undo();
                      Get.snackbar(
                        'Undone',
                        'Last ball undone. You can now correct the 1st innings final delivery.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.surface,
                        colorText: Colors.white,
                      );
                    },
                    icon: const Icon(Icons.undo_rounded, size: 18),
                    label: const Text(
                      'UNDO LAST BALL',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  )
                else
                  const SizedBox.shrink(),
                TextButton(
                  onPressed: () {
                    countdownTimer?.cancel();
                    Navigator.pop(dialogContext);
                    controller.startSecondInnings();
                  },
                  child: const Text(
                    'START 2ND INNINGS',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      countdownTimer?.cancel();
    });
  }

  void _endMatch() {
    int timeLeft = 60;
    Timer? countdownTimer;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            countdownTimer ??= Timer.periodic(const Duration(seconds: 1), (
              timer,
            ) {
              if (timeLeft > 0) {
                if (mounted) {
                  setState(() {
                    timeLeft--;
                  });
                }
              } else {
                timer.cancel();
                if (Navigator.canPop(dialogContext)) {
                  Navigator.pop(dialogContext);
                }
                Get.offAll(() => const ScoreboardHubScreen());
              }
            });

            final bool canUndoMatchEnd =
                !controller.hasMatchEndUndoBeenUsed.value &&
                controller.engine.canUndo;

            final String formattedTime =
                '00:${timeLeft.toString().padLeft(2, '0')}';

            return AlertDialog(
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  const Icon(Icons.emoji_events_rounded, color: AppColors.coinsGold),
                  const SizedBox(width: 8),
                  const Text(
                    'Match Completed',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    matchResult,
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: ResponsiveHelper.sp(18),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.timer_outlined, color: AppColors.muted, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          'Finalizing in $formattedTime',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!canUndoMatchEnd && controller.hasMatchEndUndoBeenUsed.value) ...[
                    const SizedBox(height: 12),
                    const Text(
                      'Match-end undo already used (1/1)',
                      style: TextStyle(color: AppColors.muted, fontSize: 11, fontStyle: FontStyle.italic),
                    ),
                  ],
                ],
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                if (canUndoMatchEnd)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error.withValues(alpha: 0.2),
                      foregroundColor: AppColors.error,
                      elevation: 0,
                      side: const BorderSide(color: AppColors.error, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      controller.hasMatchEndUndoBeenUsed.value = true;
                      countdownTimer?.cancel();
                      Navigator.pop(dialogContext);
                      _undo();
                      Get.snackbar(
                        'Undone',
                        'Last ball undone. You can now re-enter or correct the delivery.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.surface,
                        colorText: Colors.white,
                      );
                    },
                    icon: const Icon(Icons.undo_rounded, size: 18),
                    label: const Text(
                      'UNDO LAST BALL',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  )
                else
                  const SizedBox.shrink(),
                TextButton(
                  onPressed: () {
                    countdownTimer?.cancel();
                    Navigator.pop(dialogContext);
                    Get.offAll(() => const ScoreboardHubScreen());
                  },
                  child: const Text(
                    'FINISH NOW',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      countdownTimer?.cancel();
    });
  }

  String get currentPhase => s.currentPhase;

  String get matchResult {
    if (s.matchResult != null) return s.matchResult!;
    if (matchStatus != 'MATCH_COMPLETED' || targetScore == null) return '';
    final totalBatters = s.battingTeam.length;
    final wicketsRemaining = (totalBatters - 1) - wickets;
    if (totalRuns >= targetScore!) {
      return controller.currentMatch.value != null
          ? '${controller.currentMatch.value!.bowlingFirstTeam} won by $wicketsRemaining wickets'
          : 'Batting team won by $wicketsRemaining wickets';
    } else {
      final runsTarget = targetScore! - totalRuns;
      return controller.currentMatch.value != null
          ? '${controller.currentMatch.value!.battingFirstTeam} won by ${runsTarget - 1} runs'
          : 'Bowling team won by ${runsTarget - 1} runs';
    }
  }

  void _showBowlerChangeDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveHelper.w(18)),
        ),
      ),
      builder: (ctx) => BowlerSelectSheet(
        bowlers: bowlingTeam,
        currentBowler: currentBowler,
        onSelect: (b) {
          _changeBowler(b);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _showExtrasModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveHelper.w(18)),
        ),
      ),
      builder: (ctx) => ExtrasModal(
        onSelect: (type, runs) {
          _addExtra(type, runs);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _showWicketWizard() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveHelper.w(18)),
        ),
      ),
      builder: (ctx) => WicketWizardSheet(
        battingTeam: battingTeam,
        bowlingTeam: bowlingTeam,
        striker: striker,
        nonStriker: nonStriker,
        isFreeHit: controller.liveState.value?.isFreeHit ?? false,
        onComplete: (type, fielder, newBatter, onStrike, outPlayer, crossed) {
          Navigator.pop(ctx);
          _addWicket(
            type,
            fielder: fielder,
            newBatter: newBatter,
            newBatterOnStrike: onStrike,
            outPlayer: outPlayer,
            crossed: crossed,
          );
        },
      ),
    );
  }

  void _showRetireBowlerDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveHelper.w(18)),
        ),
      ),
      builder: (ctx) => BowlerSelectSheet(
        bowlers: bowlingTeam,
        currentBowler: currentBowler,
        onSelect: (b) {
          _retireBowler(b);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _retireBowler(Player newBowler) {
    try {
      controller.retireBowler(newBowler.name);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void _showReferralDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Video Referral', style: TextStyle(color: Colors.white)),
        content: Text(
          'Send this decision to the third umpire?',
          style: TextStyle(color: AppColors.muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Get.snackbar(
                'Third Umpire',
                'Checking for UltraEdge and Ball Tracking...',
                backgroundColor: AppColors.surface.withValues(alpha: 0.8),
                colorText: Colors.white,
                snackPosition: SnackPosition.TOP,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
            child: Text('PENDING'),
          ),
        ],
      ),
    );
  }

  void _showBreakDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveHelper.w(18)),
        ),
      ),
      builder: (ctx) => const MatchBreakTimerSheet(),
    );
  }

  void _showRetireBatterDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveHelper.w(18)),
        ),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.all(ResponsiveHelper.w(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Retire Batter',
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(18),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(16)),
            if (striker != null) _retireTile(ctx, striker!),
            if (nonStriker != null) _retireTile(ctx, nonStriker!),
          ],
        ),
      ),
    );
  }

  Widget _retireTile(BuildContext ctx, Player p) {
    final allowSub = s.matchConfig.allowSubstitutes;
    return ListTile(
      title: Text(p.name, style: TextStyle(color: AppColors.textPrimary)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _retireBatter(p, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning.withValues(alpha: 0.2),
              foregroundColor: AppColors.warning,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
              ),
            ),
            child: Text(
              'RETIRE HURT',
              style: TextStyle(
                color: AppColors.warning,
                fontSize: ResponsiveHelper.sp(11),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (allowSub) ...[
            SizedBox(width: ResponsiveHelper.w(8)),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                _retireBatter(p, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent.withValues(alpha: 0.2),
                foregroundColor: AppColors.accent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
                ),
              ),
              child: Text(
                'SUBSTITUTE',
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: ResponsiveHelper.sp(11),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<bool> _showExitConfirmationDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        ),
        title: Text(
          'Exit Match?',
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveHelper.sp(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to exit? Your match state is saved, but you will leave the live scoreboard.',
          style: TextStyle(
            color: AppColors.muted,
            fontSize: ResponsiveHelper.sp(14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'CANCEL',
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(16),
                vertical: ResponsiveHelper.h(8),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
              ),
            ),
            child: Text('EXIT', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _showExitConfirmationDialog();
        if (shouldPop && context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => UserAppNavShell()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Obx(() {
          if (!controller.isEngineReady.value ||
              controller.liveState.value == null) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          }

          if (matchStatus == 'INITIALIZING' ||
              (matchStatus == 'LIVE_INNINGS_2' && striker == null)) {
            return SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: SetupWizardCard(
                  controller: controller,
                  battingTeam: battingTeam,
                  bowlingTeam: bowlingTeam,
                ),
              ),
            );
          }

          return SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: ScoreboardHeader(
                    controller: controller,
                    totalRuns: totalRuns,
                    wickets: wickets,
                    inningsNumber: inningsNumber,
                    oversDisplay: oversDisplay,
                    currentPhase: currentPhase,
                    currentRunRate: currentRunRate,
                    projectedScore: projectedScore,
                    targetScore: targetScore,
                    matchResult: matchResult,
                    matchStatus: matchStatus,
                    isFreeHit: s.isFreeHit,
                    overs: overs,
                    balls: balls,
                  ),
                ),
                SliverToBoxAdapter(
                  child: OverProgressRow(currentOverBalls: currentOverBalls),
                ),
                SliverToBoxAdapter(
                  child: MatchContextCard(
                    winProbability: winProbability,
                    partnershipRuns: partnershipRuns,
                    partnershipBalls: partnershipBalls,
                    currentRunRate: currentRunRate,
                    requiredRunRate: requiredRunRate,
                    inningsNumber: inningsNumber,
                  ),
                ),
                SliverToBoxAdapter(
                  child: PlayerStatsTabs(
                    striker: striker,
                    nonStriker: nonStriker,
                    currentBowler: currentBowler,
                    previousBowler: previousBowler,
                    currentOverBalls: currentOverBalls,
                    currentRunRate: currentRunRate,
                    partnershipRuns: partnershipRuns,
                    partnershipBalls: partnershipBalls,
                    ballHistory: ballHistory,
                  ),
                ),
                SliverToBoxAdapter(
                  child: BallTimeline(ballHistory: ballHistory),
                ),
                SliverToBoxAdapter(
                  child: ScoringConsole(
                    onUndo: _undo,
                    onWicket: _showWicketWizard,
                    onExtras: _showExtrasModal,
                    canUndo: controller.engine.canUndo,
                  ),
                ),
                SliverToBoxAdapter(
                  child: AdvancedActionsGrid(
                    striker: striker,
                    nonStriker: nonStriker,
                    onRetireBowler: _showRetireBowlerDialog,
                    onVideoRefer: _showReferralDialog,
                    onRetireBatter: _showRetireBatterDialog,
                    onMatchBreak: _showBreakDialog,
                    allowSubstitutes: s.matchConfig.allowSubstitutes,
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),
          );
        }),
        bottomNavigationBar: Obx(() {
          if (!controller.isEngineReady.value ||
              controller.liveState.value == null) {
            return const SizedBox.shrink();
          }
          if (matchStatus == 'INITIALIZING' ||
              (matchStatus == 'LIVE_INNINGS_2' && striker == null)) {
            return const SizedBox.shrink();
          }
          return ScoringNumberRow(
            onNormalRun: (runs) => _addRuns(runs),
          );
        }),
      ),
    );
  }
}
