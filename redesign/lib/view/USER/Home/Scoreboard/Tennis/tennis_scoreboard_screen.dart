import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/tennis_controller.dart';
import 'package:redesign/view/USER/Home/scoreboard_screen/scoreboards_screen.dart';
import 'widgets/tennis_scoreboard_header.dart';
import 'widgets/tennis_scoring_dock.dart';
import 'widgets/tennis_more_actions_sheet.dart';

class TennisScoreboardScreen extends StatefulWidget {
  const TennisScoreboardScreen({super.key});

  @override
  State<TennisScoreboardScreen> createState() =>
      _TennisScoreboardScreenState();
}

class _TennisScoreboardScreenState extends State<TennisScoreboardScreen> {
  final TennisController controller = Get.find<TennisController>();
  Worker? _stateWorker;
  Worker? _undoTimerWorker;
  bool _isMatchEndFlowActive = false;
  bool _isSetBreakFlowActive = false;

  @override
  void initState() {
    super.initState();
    _stateWorker = ever(controller.liveState, (state) {
      if ((state?.matchStatus == 'COMPLETED' || state?.matchStatus == 'RETIRED') &&
          !_isMatchEndFlowActive &&
          mounted) {
        _triggerMatchCompletionFlow();
      }
    });

    _undoTimerWorker = ever(controller.gamePointUndoSeconds, (seconds) {
      final status = controller.liveState.value?.matchStatus;
      if (seconds > 0 &&
          !_isSetBreakFlowActive &&
          !_isMatchEndFlowActive &&
          status != 'COMPLETED' &&
          status != 'RETIRED' &&
          mounted) {
        _triggerSetCompletedFlow();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final status = controller.liveState.value?.matchStatus;
      if ((status == 'COMPLETED' || status == 'RETIRED') &&
          !_isMatchEndFlowActive &&
          mounted) {
        _triggerMatchCompletionFlow();
      } else if (controller.gamePointUndoSeconds.value > 0 &&
          !_isSetBreakFlowActive &&
          !_isMatchEndFlowActive &&
          mounted) {
        _triggerSetCompletedFlow();
      }
    });
  }

  @override
  void dispose() {
    _stateWorker?.dispose();
    _undoTimerWorker?.dispose();
    super.dispose();
  }

  void _triggerSetCompletedFlow() {
    _isSetBreakFlowActive = true;
    _showSetCompletedDialog();
  }

  void _showSetCompletedDialog() {
    int timeLeft = 15;
    Timer? countdownTimer;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            countdownTimer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
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
                _isSetBreakFlowActive = false;
                controller.gamePointUndoSeconds.value = 0;
              }
            });

            final String formattedTime = '00:${timeLeft.toString().padLeft(2, '0')}';
            final state = controller.liveState.value;
            String setSummaryText = 'Set Completed!';
            if (state != null && state.setScores.isNotEmpty) {
              final lastCompletedSetIdx = state.currentSetIndex > 0 ? state.currentSetIndex - 1 : 0;
              if (lastCompletedSetIdx < state.setScores.length) {
                final setObj = state.setScores[lastCompletedSetIdx];
                final winnerName = setObj.winnerSide == 'A'
                    ? state.matchConfig.homeTeamName
                    : state.matchConfig.awayTeamName;
                setSummaryText = '$winnerName won Set ${setObj.setNumber} (${setObj.sideAGames}-${setObj.sideBGames})';
              }
            }

            return AlertDialog(
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
                side: const BorderSide(color: AppColors.coinsGold, width: 1.5),
              ),
              title: Row(
                children: const [
                  Icon(Icons.emoji_events_rounded, color: AppColors.coinsGold, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Set Completed',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    setSummaryText,
                    style: TextStyle(
                      color: AppColors.coinsGold,
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
                        const Icon(Icons.timer_outlined, color: AppColors.mutedText, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          'Next Set in $formattedTime',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: ResponsiveHelper.sp(14),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
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
                    countdownTimer?.cancel();
                    Navigator.pop(dialogContext);
                    _isSetBreakFlowActive = false;
                    controller.undoSetPoint();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Last point undone. Set resumed.'),
                          backgroundColor: AppColors.surface,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.undo_rounded, size: 18),
                  label: const Text(
                    'UNDO LAST POINT',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    countdownTimer?.cancel();
                    Navigator.pop(dialogContext);
                    _isSetBreakFlowActive = false;
                    controller.gamePointUndoSeconds.value = 0;
                  },
                  child: const Text(
                    'NEXT SET',
                    style: TextStyle(
                      color: AppColors.coinsGold,
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
      _isSetBreakFlowActive = false;
    });
  }

  void _triggerMatchCompletionFlow() {
    _isMatchEndFlowActive = true;
    _showOneMinuteUndoDialog();
  }

  void _showOneMinuteUndoDialog() {
    int timeLeft = 60;
    Timer? countdownTimer;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            countdownTimer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
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
                _showTwentySecondCompletionCountdown();
              }
            });

            final bool canUndoMatchEnd =
                !controller.hasMatchEndUndoBeenUsed.value &&
                controller.engine.canUndo;

            final String formattedTime =
                '00:${timeLeft.toString().padLeft(2, '0')}';
            final String matchResultText =
                controller.liveState.value?.matchResult.isNotEmpty == true
                    ? controller.liveState.value!.matchResult
                    : 'MATCH COMPLETED';

            return AlertDialog(
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
                side: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
              ),
              title: Row(
                children: const [
                  Icon(Icons.emoji_events_rounded, color: AppColors.coinsGold, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Match Completed',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    matchResultText,
                    style: TextStyle(
                      color: AppColors.primaryGreen,
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
                        const Icon(Icons.timer_outlined, color: AppColors.mutedText, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          'Finalizing in $formattedTime',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: ResponsiveHelper.sp(14),
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
                      style: TextStyle(color: Colors.grey, fontSize: 11, fontStyle: FontStyle.italic),
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
                      _isMatchEndFlowActive = false;
                      controller.undoSetPoint();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Last point undone. Match resumed.'),
                            backgroundColor: AppColors.surface,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.undo_rounded, size: 18),
                    label: const Text(
                      'UNDO LAST POINT',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  )
                else
                  const SizedBox.shrink(),
                TextButton(
                  onPressed: () {
                    countdownTimer?.cancel();
                    Navigator.pop(dialogContext);
                    _showTwentySecondCompletionCountdown();
                  },
                  child: const Text(
                    'FINISH NOW',
                    style: TextStyle(
                      color: AppColors.primaryGreen,
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

  void _showTwentySecondCompletionCountdown() {
    int timeLeft = 20;
    Timer? countdownTimer;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            countdownTimer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
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
                _finalizeMatchAndNavigateHome();
              }
            });

            final String formattedTime = '00:${timeLeft.toString().padLeft(2, '0')}';

            return AlertDialog(
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Row(
                children: [
                  Icon(Icons.check_circle_outline, color: AppColors.primaryGreen),
                  SizedBox(width: 8),
                  Text(
                    'Declaring Match Complete',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Match will be declared complete in $formattedTime',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: timeLeft / 20.0,
                    backgroundColor: AppColors.background,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    countdownTimer?.cancel();
                    Navigator.pop(dialogContext);
                    _finalizeMatchAndNavigateHome();
                  },
                  child: const Text(
                    'FINISH IMMEDIATELY',
                    style: TextStyle(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _finalizeMatchAndNavigateHome() {
    Get.offAll(() => const ScoreboardHubScreen());
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
          side: const BorderSide(color: AppColors.borderDark, width: 1),
        ),
        title: Text(
          'Exit Match?',
          style: AppTypography.headlineSm.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to exit? Your match state is saved automatically, so you can resume scoring anytime.',
          style: AppTypography.bodySm.copyWith(
            color: AppColors.mutedText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
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
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
              ),
            ),
            child: const Text(
              'EXIT',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
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
        final shouldExit = await _showExitConfirmationDialog(context);
        if (shouldExit && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primaryGreen),
            onPressed: () async {
              final shouldExit = await _showExitConfirmationDialog(context);
              if (shouldExit && context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
          title: Text(
            'LIVE SCOREBOARD',
            style: AppTypography.headlineMd.copyWith(
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              fontStyle: FontStyle.italic,
              fontSize: context.responsiveFont(16),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert_rounded, color: AppColors.textPrimary),
              onPressed: () {
                final state = controller.liveState.value;
                if (state == null) return;
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (_) => TennisMoreActionsSheet(
                    homeTeamName: state.matchConfig.homeTeamName,
                    awayTeamName: state.matchConfig.awayTeamName,
                    onRetirePlayer: controller.retirePlayer,
                    onChangeServer: controller.changeServer,
                  ),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Obx(() {
            final state = controller.liveState.value;
            if (state == null) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryGreen,
                ),
              );
            }

            final homeName = state.matchConfig.homeTeamName;
            final awayName = state.matchConfig.awayTeamName;
            final isCompleted = state.matchStatus == 'COMPLETED' ||
                state.matchStatus == 'RETIRED';

            return Padding(
              padding: EdgeInsets.all(ResponsiveHelper.w(16.0)),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 1. Sticky Score Header
                          TennisScoreboardHeader(state: state),

                          SizedBox(height: ResponsiveHelper.h(16)),

                          // 2. Match Completed / Retired Result Banner if finished
                          if (isCompleted) ...[
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(bottom: ResponsiveHelper.h(16)),
                              padding: EdgeInsets.all(ResponsiveHelper.w(16)),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreen.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(
                                  ResponsiveHelper.w(16),
                                ),
                                border: Border.all(
                                  color: AppColors.primaryGreen,
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.emoji_events_rounded,
                                        color: AppColors.primaryGreen,
                                        size: 24,
                                      ),
                                      SizedBox(width: ResponsiveHelper.w(8)),
                                      Flexible(
                                        child: Text(
                                          'MATCH CONCLUDED',
                                          style: AppTypography.labelCaps.copyWith(
                                            color: AppColors.primaryGreen,
                                            fontSize: context.responsiveFont(14),
                                            fontWeight: FontWeight.w900,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: ResponsiveHelper.h(6)),
                                  Text(
                                    state.matchResult,
                                    style: AppTypography.headlineMd.copyWith(
                                      color: AppColors.textPrimary,
                                      fontSize: context.responsiveFont(16),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: ResponsiveHelper.h(12)),

                  // 3. Always-Visible Scoring Dock pinned at bottom
                  TennisScoringDock(
                    homeTeamName: homeName,
                    awayTeamName: awayName,
                    canUndo: controller.engine.canUndo,
                    onRecordPoint: (side, outcome) =>
                        controller.recordPoint(side, outcomeType: outcome),
                    onRecordFault: controller.recordFault,
                    onRecordDoubleFault: controller.recordDoubleFault,
                    onRecordLet: controller.recordLet,
                    onUndo: controller.undo,
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
