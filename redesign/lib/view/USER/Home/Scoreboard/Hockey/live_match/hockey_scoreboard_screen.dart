import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Hockey/hockey_controller.dart';
import 'package:redesign/view/USER/Home/scoreboard_screen/scoreboards_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Hockey/live_match/widgets/hockey_score_display.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Hockey/live_match/widgets/hockey_action_buttons.dart';

class HockeyScoreboardScreen extends StatefulWidget {
  const HockeyScoreboardScreen({super.key});

  @override
  State<HockeyScoreboardScreen> createState() => _HockeyScoreboardScreenState();
}

class _HockeyScoreboardScreenState extends State<HockeyScoreboardScreen> {
  final HockeyController controller = Get.find<HockeyController>();
  Worker? _stateWorker;
  bool _isDialogShowing = false;

  @override
  void initState() {
    super.initState();
    _stateWorker = ever(controller.liveState, (state) {
      if (state == null || _isDialogShowing || !mounted) return;
      if (state.isMatchFinished) {
        _isDialogShowing = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _showMatchFinishedDialog(context, controller).then((_) {
              _isDialogShowing = false;
            });
          }
        });
      } else if (state.isPeriodCompleted) {
        _isDialogShowing = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _showPeriodCompletedDialog(context, controller).then((_) {
              _isDialogShowing = false;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _stateWorker?.dispose();
    super.dispose();
  }

  void _navigateToScoreboardHub(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const ScoreboardHubScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await _showExitDialog(context);
        if (shouldExit == true && context.mounted) {
          _navigateToScoreboardHub(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
            onPressed: () async {
              final shouldExit = await _showExitDialog(context);
              if (shouldExit == true && context.mounted) {
                _navigateToScoreboardHub(context);
              }
            },
          ),
          title: Text(
            'Field Hockey Live Scoreboard',
            style: AppTypography.headlineMd.copyWith(
              color: AppColors.textPrimary,
              fontSize: ResponsiveHelper.sp(16),
              fontWeight: FontWeight.bold,
            ).responsive(context),
          ),
          actions: [
            Obx(() {
              if (controller.isReadOnly.value) {
                return Container(
                  margin: EdgeInsets.only(right: ResponsiveHelper.w(16)),
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(10),
                    vertical: ResponsiveHelper.h(4),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'SPECTATOR',
                      style: AppTypography.labelCaps.copyWith(
                        color: AppColors.warning,
                        fontSize: ResponsiveHelper.sp(11),
                        fontWeight: FontWeight.bold,
                      ).responsive(context),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
        body: Obx(() {
          if (!controller.isEngineReady.value || controller.liveState.value == null) {
            return const Center(child: CircularProgressIndicator(color: AppColors.accent));
          }

          return const SingleChildScrollView(
            child: Column(
              children: [
                HockeyScoreDisplay(),
              ],
            ),
          );
        }),
        bottomNavigationBar: Obx(() {
          if (!controller.isEngineReady.value || controller.liveState.value == null) {
            return const SizedBox.shrink();
          }
          return const HockeyActionButtons();
        }),
      ),
    );
  }

  Future<bool?> _showExitDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardSurface,
        title: Text(
          'Exit Scoreboard?',
          style: AppTypography.headlineMd.copyWith(color: AppColors.textPrimary),
        ),
        content: Text(
          'Your match progress is saved automatically. You can resume it anytime from the Scoreboards tab.',
          style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: AppTypography.bodySm.copyWith(color: AppColors.mutedText)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.black,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Exit Match',
              style: AppTypography.bodySm.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showPeriodCompletedDialog(BuildContext context, HockeyController controller) async {
    final state = controller.liveState.value;
    if (state == null) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.emoji_events_rounded, color: AppColors.accent),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Q${state.currentPeriod} Completed',
                style: AppTypography.headlineMd.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Period ${state.currentPeriod} completed! Tap below to begin Period ${state.currentPeriod + 1} or undo the last period goal.',
              style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),
            if (!controller.isReadOnly.value && controller.engine.canUndo)
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    controller.undoPeriodCompletionGoal();
                  },
                  icon: const Icon(Icons.undo, color: AppColors.warning, size: 18),
                  label: Text(
                    'Undo Last Goal & Continue Period',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 44),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              controller.advancePeriod();
            },
            child: Text(
              'Start Next Period Q${state.currentPeriod + 1}',
              style: AppTypography.bodySm.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showMatchFinishedDialog(BuildContext context, HockeyController controller) async {
    int timeLeft = 60;
    Timer? countdownTimer;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            countdownTimer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
              if (timeLeft > 0) {
                if (dialogCtx.mounted) {
                  setDialogState(() {
                    timeLeft--;
                  });
                }
              } else {
                timer.cancel();
                if (dialogCtx.mounted && Navigator.canPop(dialogCtx)) {
                  Navigator.pop(dialogCtx);
                }
                if (context.mounted) {
                  _navigateToScoreboardHub(context);
                }
              }
            });

            final formattedTime = '00:${timeLeft.toString().padLeft(2, '0')}';

            return AlertDialog(
              backgroundColor: AppColors.cardSurface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(
                '🏆 MATCH COMPLETED!',
                textAlign: TextAlign.center,
                style: AppTypography.headlineMd.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    controller.currentMatch.value?.matchResult ?? 'Match Finished',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
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
                          style: AppTypography.bodySm.copyWith(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (!controller.hasMatchEndUndoBeenUsed.value && !controller.isReadOnly.value)
                    TextButton.icon(
                      onPressed: () {
                        countdownTimer?.cancel();
                        Navigator.pop(dialogCtx);
                        controller.undoLastMatchPoint();
                      },
                      icon: const Icon(Icons.undo, color: AppColors.warning),
                      label: Text(
                        'Undo Last Point & Continue Match',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.warning,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 44),
                  ),
                  onPressed: () {
                    countdownTimer?.cancel();
                    Navigator.pop(dialogCtx);
                    _navigateToScoreboardHub(context);
                  },
                  child: Text(
                    'Return to Scoreboard Hub',
                    style: AppTypography.bodySm.copyWith(
                      color: Colors.black,
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

    countdownTimer?.cancel();
  }
}
