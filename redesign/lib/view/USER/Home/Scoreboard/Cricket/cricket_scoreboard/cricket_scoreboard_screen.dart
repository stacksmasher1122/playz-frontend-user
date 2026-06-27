import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/cricket_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_state_models.dart';

// Internal Imports
import 'widgets/scoreboard_header.dart';
import 'widgets/over_progress_row.dart';
import 'widgets/match_context_card.dart';
import 'widgets/player_stats_tabs.dart';
import 'widgets/ball_timeline.dart';
import 'widgets/scoring_console.dart';
import 'widgets/advanced_actions_grid.dart';
import 'widgets/setup_wizard_card.dart';
import 'widgets/bowler_select_sheet.dart';
import 'widgets/extras_modal.dart';
import 'widgets/wicket_wizard_sheet.dart';

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

  List<BallEvent> get ballHistory => s.ballHistory;
  List<BallEvent> get currentOverBalls => s.currentOverBalls;

  int get partnershipRuns => s.partnership?.runs ?? 0;
  int get partnershipBalls => s.partnership?.balls ?? 0;

  @override
  void initState() {
    super.initState();
    controller = Get.find<CricketController>();
  }

  String get oversDisplay => '$overs.${balls}';
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
    return (progress * 0.8 + (1 - wickets / 10) * 0.2).clamp(0.0, 1.0);
  }

  // Scoring Logic
  void _addRuns(int runs) {
    if (matchStatus != 'LIVE_INNINGS_1' && matchStatus != 'LIVE_INNINGS_2')
      return;
    int prevOvers = overs;
    controller.addRuns(runs);
    if (overs > prevOvers &&
        (matchStatus == 'LIVE_INNINGS_1' || matchStatus == 'LIVE_INNINGS_2'))
      _showBowlerChangeDialog();
    if (matchStatus == 'INNINGS_BREAK') _showInningsBreakDialog();
    if (matchStatus == 'MATCH_COMPLETED') _endMatch();
  }

  void _retireBatter(Player p, bool isHurt) {
    if (matchStatus != 'LIVE_INNINGS_1' && matchStatus != 'LIVE_INNINGS_2')
      return;
    final status = isHurt ? PlayerStatus.retiredHurt : PlayerStatus.retiredOut;
    final updatedBat = s.battingTeam
        .map((b) => b.name == p.name ? b.copyWith(status: status) : b)
        .toList();
    controller.engine.restoreState(
      s.copyWith(battingTeam: updatedBat).toJson(),
    );
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
    if (matchStatus != 'LIVE_INNINGS_1' && matchStatus != 'LIVE_INNINGS_2')
      return;
    int prevOvers = overs;
    controller.addExtra(type, additionalRuns);
    if (overs > prevOvers &&
        (matchStatus == 'LIVE_INNINGS_1' || matchStatus == 'LIVE_INNINGS_2'))
      _showBowlerChangeDialog();
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
    if (matchStatus != 'LIVE_INNINGS_1' && matchStatus != 'LIVE_INNINGS_2')
      return;
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
        (matchStatus == 'LIVE_INNINGS_1' || matchStatus == 'LIVE_INNINGS_2'))
      _showBowlerChangeDialog();
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
    controller.undoEvent();
  }

  // Workflows & Dialogs
  void _showInningsBreakDialog() {
    int target = totalRuns + 1;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Innings Break!',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Target is $target',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.startSecondInnings();
            },
            child: const Text(
              'Prepare 2nd Innings',
              style: TextStyle(color: AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }

  void _endMatch() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Match Completed',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          matchResult,
          style: const TextStyle(
            color: AppColors.accent,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Finish',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) => WicketWizardSheet(
        battingTeam: battingTeam,
        bowlingTeam: bowlingTeam,
        striker: striker,
        nonStriker: nonStriker,
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

  void _showReferralDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Video Referral',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Send this decision to the third umpire?',
          style: TextStyle(color: AppColors.muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Get.snackbar(
                'Third Umpire',
                'Checking for UltraEdge and Ball Tracking...',
                backgroundColor: AppColors.surface.withOpacity(0.8),
                colorText: Colors.white,
                snackPosition: SnackPosition.TOP,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
            child: const Text('PENDING'),
          ),
        ],
      ),
    );
  }

  void _showBreakDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Match Break', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Select break type:',
          style: TextStyle(color: AppColors.muted),
        ),
        actions: [
          _breakBtn(ctx, 'DRINKS', AppColors.accent),
          _breakBtn(ctx, 'RAIN', AppColors.warning),
          _breakBtn(ctx, 'TEA/LUNCH', Colors.white),
        ],
      ),
    );
  }

  Widget _breakBtn(BuildContext ctx, String label, Color color) {
    return TextButton(
      onPressed: () {
        Navigator.pop(ctx);
        Get.snackbar(
          'Match Paused',
          'Match interrupted by $label',
          backgroundColor: color.withOpacity(0.2),
          colorText: color,
        );
      },
      child: Text(label, style: TextStyle(color: color)),
    );
  }

  void _showRetireBatterDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Retire Batter',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            if (striker != null) _retireTile(ctx, striker!),
            if (nonStriker != null) _retireTile(ctx, nonStriker!),
          ],
        ),
      ),
    );
  }

  Widget _retireTile(BuildContext ctx, Player p) {
    return ListTile(
      title: Text(p.name, style: const TextStyle(color: Colors.white)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _retireBatter(p, true);
            },
            child: const Text(
              'HURT',
              style: TextStyle(color: AppColors.warning, fontSize: 12),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _retireBatter(p, false);
            },
            child: const Text(
              'OUT',
              style: TextStyle(color: AppColors.error, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (!controller.isEngineReady.value ||
            controller.liveState.value == null) {
          return const Center(child: CircularProgressIndicator(color: AppColors.accent));
        }

        if (matchStatus == 'INITIALIZING' ||
            (matchStatus == 'LIVE_INNINGS_2' && striker == null)) {
          return Center(
            child: SetupWizardCard(
              controller: controller,
              battingTeam: battingTeam,
              bowlingTeam: bowlingTeam,
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
                  requiredRunRate: requiredRunRate,
                ),
              ),
              SliverToBoxAdapter(
                child: PlayerStatsTabs(
                  striker: striker,
                  nonStriker: nonStriker,
                  currentBowler: currentBowler,
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
                  onNormalRun: (runs) => _addRuns(runs),
                ),
              ),
              SliverToBoxAdapter(
                child: AdvancedActionsGrid(
                  striker: striker,
                  nonStriker: nonStriker,
                  onChangeBowler: _showBowlerChangeDialog,
                  onVideoRefer: _showReferralDialog,
                  onRetireBatter: _showRetireBatterDialog,
                  onMatchBreak: _showBreakDialog,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        );
      }),
    );
  }
}
