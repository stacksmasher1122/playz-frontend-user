import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Kabaddi/kabaddi_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Kabaddi/kabaddi_state_models.dart';
import 'package:redesign/view/USER/Navigation/user_navigation.dart';
import 'widgets/kabaddi_score_display.dart';
import 'widgets/kabaddi_action_buttons.dart';

class KabaddiScoreboardScreen extends StatefulWidget {
  const KabaddiScoreboardScreen({super.key});

  @override
  State<KabaddiScoreboardScreen> createState() => _KabaddiScoreboardScreenState();
}

class _KabaddiScoreboardScreenState extends State<KabaddiScoreboardScreen> {
  final KabaddiController controller = Get.find<KabaddiController>();
  Worker? _stateWorker;
  Timer? _liveTicker;
  bool _isCompletionDialogActive = false;

  @override
  void initState() {
    super.initState();
    _liveTicker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (controller.isTimerRunning.value) {
        controller.tickHalfTimer();
      }
      if (controller.isRaidClockRunning.value) {
        controller.tickRaidClock();
      }
    });

    _stateWorker = ever(controller.liveState, (state) {
      if (state != null &&
          (state.isHalfCompleted || state.isMatchFinished) &&
          !_isCompletionDialogActive &&
          mounted &&
          !controller.isReadOnly.value) {
        _triggerCompletionFlow();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = controller.liveState.value;
      if (state != null &&
          (state.isHalfCompleted || state.isMatchFinished) &&
          !_isCompletionDialogActive &&
          mounted &&
          !controller.isReadOnly.value) {
        _triggerCompletionFlow();
      }
    });
  }

  @override
  void dispose() {
    _liveTicker?.cancel();
    _stateWorker?.dispose();
    super.dispose();
  }

  void _triggerCompletionFlow() {
    _isCompletionDialogActive = true;
    _showOneMinuteUndoDialog();
  }

  void _showOneMinuteUndoDialog() {
    final state = controller.liveState.value;
    if (state == null) {
      _isCompletionDialogActive = false;
      return;
    }

    final bool isMatchEnd = state.isMatchFinished;
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
                _isCompletionDialogActive = false;
                if (isMatchEnd) {
                  _finalizeMatchAndNavigateHome();
                } else {
                  controller.switchHalf();
                }
              }
            });

            final bool canUndoPoint =
                !controller.hasMatchEndUndoBeenUsed.value && controller.engine.canUndo;
            final String formattedTime = '00:${timeLeft.toString().padLeft(2, '0')}';

            final String titleText = isMatchEnd
                ? 'Match Completed'
                : '1st Half Completed';

            final String resultText = isMatchEnd
                ? (controller.currentMatch.value?.matchResult.isNotEmpty == true
                    ? controller.currentMatch.value!.matchResult
                    : _getWinnerText(state))
                : 'Half-time Break (${state.sideAScore} - ${state.sideBScore})';

            final String actionButtonText = isMatchEnd
                ? 'FINISH MATCH NOW'
                : 'START 2ND HALF';

            return AlertDialog(
              backgroundColor: AppColors.card,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
              ),
              title: Row(
                children: [
                  const Icon(Icons.emoji_events_rounded, color: AppColors.coinsGold),
                  const SizedBox(width: 8),
                  Text(
                    titleText,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    resultText,
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
                          'Auto-proceeding in $formattedTime',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: ResponsiveHelper.sp(13),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (controller.hasMatchEndUndoBeenUsed.value) ...[
                    const SizedBox(height: 12),
                    const Text(
                      'Completion undo already used (1/1)',
                      style: TextStyle(color: Colors.grey, fontSize: 11, fontStyle: FontStyle.italic),
                    ),
                  ],
                ],
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                if (canUndoPoint)
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
                      _isCompletionDialogActive = false;
                      controller.undoLastMatchPoint();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Last point undone. Scoring resumed.'),
                            backgroundColor: AppColors.card,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.undo_rounded, size: 18),
                    label: const Text(
                      'UNDO LAST POINT',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  )
                else
                  const SizedBox.shrink(),
                TextButton(
                  onPressed: () {
                    countdownTimer?.cancel();
                    Navigator.pop(dialogContext);
                    _isCompletionDialogActive = false;
                    if (isMatchEnd) {
                      _finalizeMatchAndNavigateHome();
                    } else {
                      controller.switchHalf();
                    }
                  },
                  child: Text(
                    actionButtonText,
                    style: const TextStyle(
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
      _isCompletionDialogActive = false;
    });
  }

  void _finalizeMatchAndNavigateHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => UserAppNavShell()),
      (route) => false,
    );
  }

  Future<bool> _showExitConfirmationDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
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
          'Are you sure you want to exit? Your match state is automatically saved, but you will leave the live scoreboard.',
          style: TextStyle(
            color: AppColors.mutedText,
            fontSize: ResponsiveHelper.sp(14),
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
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
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
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primaryGreen),
            onPressed: () async {
              final shouldPop = await _showExitConfirmationDialog();
              if (shouldPop && context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => UserAppNavShell()),
                  (route) => false,
                );
              }
            },
          ),
          title: Text(
            'KABADDI MATCH',
            style: AppTypography.headlineMd.copyWith(
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              fontStyle: FontStyle.italic,
              fontSize: context.responsiveFont(16),
            ),
          ),
          centerTitle: false,
          actions: [
            Obx(() {
              final state = controller.liveState.value;
              final canUndo = state != null && controller.engine.canUndo;
              return IconButton(
                icon: Icon(
                  Icons.undo_rounded,
                  color: canUndo ? AppColors.primaryGreen : AppColors.mutedText,
                ),
                onPressed: canUndo ? controller.undoLastAction : null,
              );
            }),
          ],
        ),
        body: SafeArea(
          child: Obx(() {
            final state = controller.liveState.value;
            if (state == null) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryGreen),
              );
            }

            return Column(
              children: [
                // 1. TOP PINNED HIGH-VISIBILITY SCOREBOARD SECTION
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(16),
                    vertical: ResponsiveHelper.h(8),
                  ),
                  child: KabaddiScoreDisplay(
                    state: state,
                    onScoreRaid: controller.scoreRaidPoint,
                    onScoreTackle: controller.scoreTacklePoint,
                  ),
                ),

                // 2. MIDDLE OPTIONAL SCROLLABLE SECTION
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.w(16),
                      vertical: ResponsiveHelper.h(8),
                    ),
                    child: Column(
                      children: [
                        if (state.isMatchFinished) ...[
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(ResponsiveHelper.w(20)),
                            decoration: BoxDecoration(
                              color: AppColors.primaryGreen.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.primaryGreen, width: 2),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.emoji_events_rounded,
                                  color: AppColors.coinsGold,
                                  size: 48,
                                ),
                                SizedBox(height: ResponsiveHelper.h(8)),
                                Text(
                                  'MATCH COMPLETED!',
                                  style: AppTypography.headlineLg.copyWith(
                                    color: AppColors.primaryGreen,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                SizedBox(height: ResponsiveHelper.h(4)),
                                Text(
                                  controller.currentMatch.value?.matchResult ?? _getWinnerText(state),
                                  style: AppTypography.bodyLg.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: ResponsiveHelper.h(16)),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryGreen,
                                    foregroundColor: Colors.black,
                                  ),
                                  onPressed: () => _finalizeMatchAndNavigateHome(),
                                  child: const Text('Return to Home'),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: ResponsiveHelper.h(16)),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),

        // 3. FIXED BOTTOM SCORING CONSOLE
        bottomNavigationBar: SafeArea(
          child: Obx(() {
            final state = controller.liveState.value;
            if (state == null) return const SizedBox.shrink();

            if (controller.isReadOnly.value) {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                color: AppColors.surfaceElevated,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.visibility, color: AppColors.primaryGreen, size: 20),
                    SizedBox(width: ResponsiveHelper.w(8)),
                    Text(
                      "LIVE SPECTATOR MODE (READ ONLY)",
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state.isMatchFinished) return const SizedBox.shrink();

            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(16),
                vertical: ResponsiveHelper.h(10),
              ),
              decoration: const BoxDecoration(
                color: AppColors.background,
                border: Border(
                  top: BorderSide(color: AppColors.borderDark, width: 1),
                ),
              ),
              child: KabaddiActionButtons(
                state: state,
                canUndo: controller.engine.canUndo,
                onScoreRaid: (team, points) => controller.scoreRaidPoint(team, points: points),
                onScoreTackle: controller.scoreTacklePoint,
                onScoreAllOut: controller.scoreAllOut,
                onScoreBonusPoint: controller.scoreBonusPoint,
                onSwitchHalf: controller.switchHalf,
                onUndo: controller.undoLastAction,
              ),
            );
          }),
        ),
      ),
    );
  }

  String _getWinnerText(KabaddiMatchState? state) {
    if (state == null) return 'MATCH COMPLETED';
    final winner = state.matchWinner;
    if (winner == null) return 'MATCH TIED (${state.sideAScore} - ${state.sideBScore})';
    final teamName = winner == PlayerSide.sideA
        ? (state.teamA.isNotEmpty ? state.teamA.first.name : 'Side A')
        : (state.teamB.isNotEmpty ? state.teamB.first.name : 'Side B');
    return '$teamName WON (${state.sideAScore} - ${state.sideBScore})';
  }
}
