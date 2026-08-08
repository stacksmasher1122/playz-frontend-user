import 'dart:async';
import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/cricket_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_state_models.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Cricket/cricket_scoreboard/widgets/advanced_actions_grid.dart';
import 'package:redesign/view/USER/Navigation/user_navigation.dart';
import 'package:redesign/view/USER/Home/scoreboard_screen/scoreboards_screen.dart';
import 'package:redesign/common/common_match_end_sheet.dart';

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

  void _retireBatter(Player p, PlayerStatus status) {
    if (matchStatus != 'LIVE_INNINGS_1' && matchStatus != 'LIVE_INNINGS_2') {
      return;
    }
    controller.engine.retireBatter(p.name, status);
    controller.updateEngineState();
    Get.snackbar(
      'Batter Retired',
      '${p.name} retired ${status == PlayerStatus.retiredHurt ? "hurt" : "out"}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.surface,
      colorText: Colors.white,
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
    final bool canUndoInningsBreak =
        !controller.hasInningsBreakUndoBeenUsed.value &&
        controller.engine.canUndo;

    final target = totalRuns + 1;
    final highlights = <MatchHighlightItem>[];
    if (topBatter != null) {
      highlights.add(MatchHighlightItem(
        icon: Icons.sports_cricket,
        iconColor: AppColors.accent,
        label: '1st Innings Top Batter',
        value: '${topBatter!.name} (${topBatter!.runs}r, ${topBatter!.ballsFaced}b)',
      ));
    }
    if (topBowler != null) {
      highlights.add(MatchHighlightItem(
        icon: Icons.sports_baseball,
        iconColor: const Color(0xFFFF6B6B),
        label: '1st Innings Top Bowler',
        value: '${topBowler!.name} (${topBowler!.wicketsTaken}w / ${topBowler!.runsConceded}r)',
      ));
    }

    CommonMatchEndSheet.showInningsBreak(
      context,
      title: '1ST INNINGS COMPLETED',
      targetText: 'Target for ${s.matchConfig.bowlingTeamName}: $target runs',
      team1Name: s.matchConfig.battingTeamName,
      team1Score: '$totalRuns/$wickets ($oversDisplay ov)',
      team2Name: s.matchConfig.bowlingTeamName,
      team2Score: 'Target: $target runs',
      highlights: highlights,
      canUndo: canUndoInningsBreak,
      undoButtonText: 'UNDO LAST BALL',
      finishButtonText: 'START 2ND INNINGS',
      timerPrefix: '2nd Innings starts in',
      onUndo: () {
        controller.hasInningsBreakUndoBeenUsed.value = true;
        _undo();
        Get.snackbar(
          'Undone',
          'Last ball undone. You can now correct the 1st innings final delivery.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.cardSurface,
          colorText: Colors.white,
        );
      },
      onFinish: () {
        controller.startSecondInnings();
      },
    );
  }

  void _endMatch() {
    final bool canUndoMatchEnd =
        !controller.hasMatchEndUndoBeenUsed.value && controller.engine.canUndo;

    final highlights = <MatchHighlightItem>[];
    if (topBatter != null) {
      highlights.add(MatchHighlightItem(
        icon: Icons.sports_cricket,
        iconColor: AppColors.accent,
        label: 'Top Batter',
        value: '${topBatter!.name} (${topBatter!.runs}r, ${topBatter!.ballsFaced}b)',
      ));
    }
    if (topBowler != null) {
      highlights.add(MatchHighlightItem(
        icon: Icons.sports_baseball,
        iconColor: const Color(0xFFFF6B6B),
        label: 'Top Bowler',
        value: '${topBowler!.name} (${topBowler!.wicketsTaken}w / ${topBowler!.runsConceded}r)',
      ));
    }

    CommonMatchEndSheet.show(
      context,
      title: 'MATCH COMPLETED',
      resultBannerText: matchResult,
      team1Name: s.matchConfig.bowlingTeamName,
      team1Score: '${targetScore != null ? targetScore! - 1 : totalRuns} runs',
      team2Name: s.matchConfig.battingTeamName,
      team2Score: '$totalRuns/$wickets ($oversDisplay ov)',
      highlights: highlights,
      canUndo: canUndoMatchEnd,
      undoButtonText: 'UNDO LAST BALL',
      finishButtonText: 'FINISH MATCH',
      onUndo: () {
        controller.hasMatchEndUndoBeenUsed.value = true;
        _undo();
        Get.snackbar(
          'Undone',
          'Last ball undone. You can now re-enter or correct the delivery.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.cardSurface,
          colorText: Colors.white,
        );
      },
      onFinish: () {
        if (controller.tournamentId.value.isNotEmpty) {
          controller.endTournamentMatch(context);
        } else {
          Get.offAll(() => const ScoreboardHubScreen());
        }
      },
    );
  }

  String get currentPhase => s.currentPhase;

  Player? get topBatter {
    final allBatters = [...s.battingTeam, ...s.bowlingTeam];
    if (allBatters.isEmpty) return null;
    allBatters.sort((a, b) => b.runs.compareTo(a.runs));
    return allBatters.first.runs > 0 ? allBatters.first : null;
  }

  Player? get topBowler {
    final allBowlers = [...s.battingTeam, ...s.bowlingTeam];
    if (allBowlers.isEmpty) return null;
    allBowlers.sort((a, b) {
      final wComp = b.wicketsTaken.compareTo(a.wicketsTaken);
      if (wComp != 0) return wComp;
      return a.runsConceded.compareTo(b.runsConceded);
    });
    return allBowlers.first.wicketsTaken > 0 ? allBowlers.first : null;
  }

  String get matchResult {
    if (s.matchResult != null && s.matchResult!.isNotEmpty) return s.matchResult!;
    if (matchStatus != 'MATCH_COMPLETED') return '';

    final batTeam = s.matchConfig.battingTeamName;
    final bowlTeam = s.matchConfig.bowlingTeamName;

    if (targetScore != null) {
      final maxW = controller.engine.maxWickets;
      final wicketsRemaining = maxW - wickets;

      if (totalRuns >= targetScore!) {
        final wRem = wicketsRemaining > 0 ? wicketsRemaining : 1;
        return '$batTeam won by $wRem wicket${wRem != 1 ? 's' : ''}';
      } else if (totalRuns == targetScore! - 1) {
        return 'Match Tied';
      } else {
        final runsMargin = (targetScore! - 1) - totalRuns;
        return '$bowlTeam won by $runsMargin run${runsMargin != 1 ? 's' : ''}';
      }
    }
    return 'Match Completed';
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
    final allowSub = s.matchConfig.allowSubstitutes;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Retire / Substitute Bowler',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.sp(18),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.h(12)),
            if (currentBowler != null)
              Container(
                padding: EdgeInsets.all(ResponsiveHelper.w(14)),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          currentBowler!.name,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: ResponsiveHelper.sp(15),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${currentBowler!.oversBowledDisplay} ov • ${currentBowler!.runsConceded}r • ${currentBowler!.wicketsTaken}w',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: ResponsiveHelper.sp(12),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveHelper.h(12)),
                    Wrap(
                      spacing: ResponsiveHelper.w(8),
                      runSpacing: ResponsiveHelper.h(8),
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(ctx);
                            _showBowlerReplacementSheet(currentBowler!);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.warning.withValues(alpha: 0.2),
                            foregroundColor: AppColors.warning,
                            elevation: 0,
                            side: const BorderSide(color: AppColors.warning, width: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
                            ),
                          ),
                          icon: const Icon(Icons.healing, size: 14),
                          label: Text(
                            'RETIRE HURT',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.sp(11),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(ctx);
                            _showBowlerReplacementSheet(currentBowler!);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error.withValues(alpha: 0.2),
                            foregroundColor: AppColors.error,
                            elevation: 0,
                            side: const BorderSide(color: AppColors.error, width: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
                            ),
                          ),
                          icon: const Icon(Icons.no_accounts, size: 14),
                          label: Text(
                            'RETIRE OUT',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.sp(11),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (allowSub)
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(ctx);
                              _showBowlerSubstitutionDialog(currentBowler!.name);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent.withValues(alpha: 0.2),
                              foregroundColor: AppColors.accent,
                              elevation: 0,
                              side: const BorderSide(color: AppColors.accent, width: 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
                              ),
                            ),
                            icon: const Icon(Icons.swap_horiz, size: 14),
                            label: Text(
                              'SUBSTITUTE',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.sp(11),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'No active bowler assigned.',
                  style: TextStyle(color: AppColors.muted, fontSize: ResponsiveHelper.sp(14)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showBowlerReplacementSheet(Player retiredBowler) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveHelper.w(18)),
        ),
      ),
      builder: (ctx) => BowlerSelectSheet(
        bowlers: bowlingTeam.where((b) => b.name != retiredBowler.name).toList(),
        currentBowler: currentBowler,
        onSelect: (newBowler) {
          _retireBowler(newBowler);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _showBowlerSubstitutionDialog(String oldBowlerName) {
    final availableSubs = bowlingTeam.where((b) => b.name != oldBowlerName).toList();
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
              'Select Substitute Bowler for $oldBowlerName',
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(16),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(8)),
            if (availableSubs.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('No available bowlers for substitution.', style: TextStyle(color: AppColors.muted)),
              )
            else
              ...availableSubs.map(
                (sub) => ListTile(
                  title: Text(sub.name, style: const TextStyle(color: Colors.white)),
                  subtitle: Text('${sub.oversBowledDisplay} ov • ${sub.runsConceded}r • ${sub.wicketsTaken}w', style: const TextStyle(color: AppColors.muted, fontSize: 11)),
                  trailing: const Icon(Icons.swap_horiz, color: AppColors.accent),
                  onTap: () {
                    Navigator.pop(ctx);
                    controller.substituteBowler(
                      oldBowlerName: oldBowlerName,
                      newBowlerName: sub.name,
                    );
                    Get.snackbar(
                      'Substituted',
                      '${sub.name} came in as substitute bowler for $oldBowlerName',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.surface,
                      colorText: Colors.white,
                    );
                  },
                ),
              ),
          ],
        ),
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
      isScrollControlled: true,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Retire / Substitute Batter',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.sp(18),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.h(12)),
            if (striker != null) _retireBatterTile(ctx, striker!, isStriker: true),
            if (nonStriker != null) _retireBatterTile(ctx, nonStriker!, isStriker: false),
            if (striker == null && nonStriker == null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'No active batters at the crease.',
                  style: TextStyle(color: AppColors.muted, fontSize: ResponsiveHelper.sp(14)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _retireBatterTile(BuildContext ctx, Player p, {required bool isStriker}) {
    final allowSub = s.matchConfig.allowSubstitutes;
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.h(12)),
      padding: EdgeInsets.all(ResponsiveHelper.w(14)),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                p.name,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: ResponsiveHelper.sp(15),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isStriker
                      ? AppColors.accent.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isStriker ? 'STRIKER' : 'NON-STRIKER',
                  style: TextStyle(
                    color: isStriker ? AppColors.accent : Colors.white70,
                    fontSize: ResponsiveHelper.sp(10),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${p.runs} (${p.ballsFaced})',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: ResponsiveHelper.sp(13),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(12)),
          Wrap(
            spacing: ResponsiveHelper.w(8),
            runSpacing: ResponsiveHelper.h(8),
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  _handleRetireBatterAction(p, PlayerStatus.retiredHurt);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warning.withValues(alpha: 0.2),
                  foregroundColor: AppColors.warning,
                  elevation: 0,
                  side: const BorderSide(color: AppColors.warning, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
                  ),
                ),
                icon: const Icon(Icons.healing, size: 14),
                label: Text(
                  'RETIRE HURT',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.sp(11),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  _handleRetireBatterAction(p, PlayerStatus.retiredOut);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error.withValues(alpha: 0.2),
                  foregroundColor: AppColors.error,
                  elevation: 0,
                  side: const BorderSide(color: AppColors.error, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
                  ),
                ),
                icon: const Icon(Icons.no_accounts, size: 14),
                label: Text(
                  'RETIRE OUT',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.sp(11),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (allowSub)
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _showBatterSubstitutionDialog(p.name);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent.withValues(alpha: 0.2),
                    foregroundColor: AppColors.accent,
                    elevation: 0,
                    side: const BorderSide(color: AppColors.accent, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
                    ),
                  ),
                  icon: const Icon(Icons.swap_horiz, size: 14),
                  label: Text(
                    'SUBSTITUTE',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.sp(11),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleRetireBatterAction(Player p, PlayerStatus status) {
    _retireBatter(p, status);

    final dnbPlayers = battingTeam
        .where(
          (x) =>
              !x.hasBatted &&
              x.name != striker?.name &&
              x.name != nonStriker?.name &&
              x.status != PlayerStatus.out &&
              x.status != PlayerStatus.retiredHurt &&
              x.status != PlayerStatus.retiredOut,
        )
        .toList();
    if (dnbPlayers.isNotEmpty) {
      _showIncomingBatterSelectionSheet(
        oldBatterName: p.name,
        dnbPlayers: dnbPlayers,
      );
    }
  }

  void _showIncomingBatterSelectionSheet({
    required String oldBatterName,
    required List<Player> dnbPlayers,
  }) {
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
              'Select Next Batter',
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(18),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(8)),
            ...dnbPlayers.map(
              (player) => ListTile(
                title: Text(
                  player.name,
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppColors.accent,
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  controller.selectIncomingBatter(
                    oldBatterName: oldBatterName,
                    newBatterName: player.name,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBatterSubstitutionDialog(String oldBatterName) {
    final dnbPlayers = battingTeam
        .where(
          (x) =>
              !x.hasBatted &&
              x.name != striker?.name &&
              x.name != nonStriker?.name &&
              x.status != PlayerStatus.out &&
              x.status != PlayerStatus.retiredHurt &&
              x.status != PlayerStatus.retiredOut,
        )
        .toList();
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
              'Select Substitute Batter for $oldBatterName',
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(16),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(8)),
            if (dnbPlayers.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('No available bench players for substitution.', style: TextStyle(color: AppColors.muted)),
              )
            else
              ...dnbPlayers.map(
                (sub) => ListTile(
                  title: Text(sub.name, style: const TextStyle(color: Colors.white)),
                  subtitle: const Text('Bench Player', style: TextStyle(color: AppColors.muted, fontSize: 11)),
                  trailing: const Icon(Icons.swap_horiz, color: AppColors.accent),
                  onTap: () {
                    Navigator.pop(ctx);
                    controller.substituteBatter(
                      oldBatterName: oldBatterName,
                      newBatterName: sub.name,
                    );
                    Get.snackbar(
                      'Substituted',
                      '${sub.name} came in as substitute for $oldBatterName',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.surface,
                      colorText: Colors.white,
                    );
                  },
                ),
              ),
          ],
        ),
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
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: SetupWizardCard(
                    controller: controller,
                    battingTeam: battingTeam,
                    bowlingTeam: bowlingTeam,
                  ),
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
