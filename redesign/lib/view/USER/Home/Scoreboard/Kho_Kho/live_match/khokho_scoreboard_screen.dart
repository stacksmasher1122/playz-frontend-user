import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Kho_Kho/khokho_controller.dart';
import 'package:redesign/view/USER/Home/scoreboard_screen/scoreboards_screen.dart';
import 'package:redesign/common/common_match_end_sheet.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Kho_Kho/live_match/widgets/khokho_score_display.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Kho_Kho/live_match/widgets/khokho_action_buttons.dart';

class KhoKhoScoreboardScreen extends StatefulWidget {
  const KhoKhoScoreboardScreen({super.key});

  @override
  State<KhoKhoScoreboardScreen> createState() => _KhoKhoScoreboardScreenState();
}

class _KhoKhoScoreboardScreenState extends State<KhoKhoScoreboardScreen> {
  final KhoKhoController controller = Get.find<KhoKhoController>();
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
      } else if (state.isTurnCompleted) {
        _isDialogShowing = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _showTurnCompletedDialog(context, controller).then((_) {
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
    Get.offAll(() => const ScoreboardHubScreen());
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
        body: SafeArea(
          child: Obx(() {
            if (!controller.isEngineReady.value || controller.liveState.value == null) {
              return const Center(child: CircularProgressIndicator(color: AppColors.accent));
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // ─── TOP SECTION: SCORE DISPLAY ───
                          Column(
                            children: [
                              SizedBox(height: ResponsiveHelper.h(8.0)),
                              if (controller.isReadOnly.value)
                                Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: ResponsiveHelper.w(16.0),
                                    vertical: ResponsiveHelper.h(4.0),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ResponsiveHelper.w(12.0),
                                    vertical: ResponsiveHelper.h(6.0),
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.warning.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.remove_red_eye_rounded, color: AppColors.warning, size: 16),
                                      SizedBox(width: ResponsiveHelper.w(6.0)),
                                      Text(
                                        'SPECTATOR MODE (VIEW ONLY)',
                                        style: AppTypography.labelCaps.copyWith(
                                          color: AppColors.warning,
                                          fontSize: ResponsiveHelper.sp(11.0),
                                          fontWeight: FontWeight.bold,
                                        ).responsive(context),
                                      ),
                                    ],
                                  ),
                                ),
                              const KhoKhoScoreDisplay(),
                            ],
                          ),

                          // ─── BOTTOM SECTION: SCORING & ACTION CONTROLS ───
                          const KhoKhoActionButtons(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
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

  Future<void> _showTurnCompletedDialog(BuildContext context, KhoKhoController controller) {
    final state = controller.liveState.value;
    final homeName = controller.currentMatch.value?.homeTeam ?? 'Side A';
    final awayName = controller.currentMatch.value?.awayTeam ?? 'Side B';

    return CommonMatchEndSheet.show(
      context,
      title: 'TURN ${state?.currentTurn ?? 1} COMPLETED',
      titleIcon: Icons.directions_run_rounded,
      titleIconColor: AppColors.accent,
      resultBannerText: 'END OF TURN ${state?.currentTurn ?? 1}',
      team1Name: homeName,
      team1Score: '${state?.pointsA ?? 0} PTS',
      team2Name: awayName,
      team2Score: '${state?.pointsB ?? 0} PTS',
      canUndo: controller.engine.canUndo,
      undoButtonText: 'UNDO LAST ACTION',
      finishButtonText: 'START NEXT TURN',
      onUndo: () {
        controller.undoLastAction();
      },
      onFinish: () {
        controller.advanceTurn();
      },
    );
  }

  Future<void> _showMatchFinishedDialog(BuildContext context, KhoKhoController controller) {
    final state = controller.liveState.value;
    final homeName = controller.currentMatch.value?.homeTeam ?? 'Side A';
    final awayName = controller.currentMatch.value?.awayTeam ?? 'Side B';

    return CommonMatchEndSheet.show(
      context,
      title: 'MATCH COMPLETED',
      titleIcon: Icons.emoji_events_rounded,
      titleIconColor: AppColors.accent,
      resultBannerText: controller.currentMatch.value?.matchResult ?? 'Match Finished',
      team1Name: homeName,
      team1Score: '${state?.pointsA ?? 0} PTS',
      team2Name: awayName,
      team2Score: '${state?.pointsB ?? 0} PTS',
      canUndo: controller.engine.canUndo && !controller.hasMatchEndUndoBeenUsed.value,
      undoButtonText: 'UNDO MATCH POINT',
      finishButtonText: 'GO TO MATCH HUB',
      onUndo: () {
        controller.undoLastMatchPoint();
      },
      onFinish: () {
        _navigateToScoreboardHub(context);
      },
    );
  }
}
