import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/badminton_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/badminton_state_models.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Badminton/live_match/widgets/scoring_console.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Badminton/live_match/widgets/badminton_scoreboard_header.dart';
import 'package:redesign/view/USER/Navigation/user_navigation.dart';

class BadmintonScoreboardScreen extends StatefulWidget {
  const BadmintonScoreboardScreen({super.key});

  @override
  State<BadmintonScoreboardScreen> createState() => _BadmintonScoreboardScreenState();
}

class _BadmintonScoreboardScreenState extends State<BadmintonScoreboardScreen> {
  final BadmintonController controller = Get.find<BadmintonController>();
  Worker? _stateWorker;
  bool _isMatchEndFlowActive = false;

  @override
  void initState() {
    super.initState();
    _stateWorker = ever(controller.liveState, (state) {
      if (state?.status == MatchStatus.completed &&
          !_isMatchEndFlowActive &&
          mounted &&
          !controller.isReadOnly.value) {
        _triggerMatchCompletionFlow();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.liveState.value?.status == MatchStatus.completed &&
          !_isMatchEndFlowActive &&
          mounted &&
          !controller.isReadOnly.value) {
        _triggerMatchCompletionFlow();
      }
    });
  }

  @override
  void dispose() {
    _stateWorker?.dispose();
    super.dispose();
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
            final String rawResult = controller.currentMatch.value?.matchResult ?? '';
            String matchResultText = '';
            if (rawResult.isNotEmpty) {
              matchResultText = rawResult
                  .split(' ')
                  .map((token) => token.contains('@') ? _cleanPlayerName(token) : token)
                  .join(' ');
            } else if (controller.liveState.value != null) {
              matchResultText = _getWinnerTextText(controller.liveState.value!);
            } else {
              matchResultText = 'MATCH COMPLETED';
            }

            return AlertDialog(
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
              ),
              title: Row(
                children: const [
                  Icon(Icons.emoji_events_rounded, color: AppColors.coinsGold),
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
                          style: TextStyle(
                            color: AppColors.textSecondary,
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
                      controller.undoLastEvent();
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
                  Icon(Icons.check_circle_outline, color: AppColors.accent),
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
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
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

  void _finalizeMatchAndNavigateHome() {
    if (controller.tournamentId.isNotEmpty && !controller.isReadOnly.value) {
      controller.endTournamentMatch(context);
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => UserAppNavShell()),
        (route) => false,
      );
    }
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
            icon: Icon(Icons.arrow_back, color: AppColors.accent),
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
            'LIVE MATCH',
            style: TextStyle(
              color: AppColors.accent,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          centerTitle: true,
        ),
        body: Obx(() {
          final state = controller.liveState.value;
          if (!controller.isEngineReady.value || state == null) {
            return Center(child: CircularProgressIndicator(color: AppColors.accent));
          }

          final isCompleted = state.status == MatchStatus.completed;

          return SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(16)),
                        child: Column(
                          children: [
                            BadmintonScoreboardHeader(
                              controller: controller,
                              state: state,
                            ),
                            const SizedBox(height: 32),
                            if (isCompleted)
                              Container(
                                padding: EdgeInsets.all(ResponsiveHelper.w(24)),
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
                                  border: Border.all(color: AppColors.accent, width: 2),
                                ),
                                child: Column(
                                  children: [
                                    Icon(Icons.emoji_events, color: AppColors.accent, size: 48),
                                    const SizedBox(height: 12),
                                    Text(
                                      'MATCH COMPLETED',
                                      style: TextStyle(
                                        color: AppColors.accent,
                                        fontSize: ResponsiveHelper.sp(20),
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _getWinnerTextText(state),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: ResponsiveHelper.sp(16),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    if (controller.tournamentId.isNotEmpty && !controller.isReadOnly.value)
                                      Padding(
                                        padding: EdgeInsets.only(top: ResponsiveHelper.h(16)),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.background,
                                            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(24), vertical: ResponsiveHelper.h(12)),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.w(8))),
                                          ),
                                          onPressed: () => controller.endTournamentMatch(context),
                                          child: Text(
                                            "SAVE & END MATCH",
                                            style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                    if (!isCompleted)
                      controller.isReadOnly.value
                          ? Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                              color: AppColors.surface,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.visibility, color: AppColors.accent, size: 20),
                                  SizedBox(width: ResponsiveHelper.w(8)),
                                  Text(
                                    "LIVE SPECTATOR MODE (READ ONLY)",
                                    style: AppTypography.bodyMd.copyWith(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ScoringConsole(
                              onUndo: controller.undoLastEvent,
                              onPointSideA: () => controller.addPoint(PlayerSide.sideA),
                              onPointSideB: () => controller.addPoint(PlayerSide.sideB),
                              controller: controller,
                            ),
                  ],
                ),

                // A11 Fix: Medical timeout overlay
                if (state.status == MatchStatus.timeout)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black87,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.medical_services, color: AppColors.accent, size: 64),
                            const SizedBox(height: 16),
                            Text("MEDICAL TIMEOUT", style: AppTypography.headlineLg.copyWith(color: AppColors.accent)),
                            const SizedBox(height: 16),
                            Text(
                              "${(controller.medicalTimeoutSeconds.value / 60).floor()}:${(controller.medicalTimeoutSeconds.value % 60).toString().padLeft(2, '0')}",
                              style: AppTypography.displayLg.copyWith(color: AppColors.onPrimary),
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton(
                              onPressed: () {
                                controller.resumeMedicalTimeout();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              ),
                              child: Text("Resume Match", style: AppTypography.labelCaps.copyWith(color: AppColors.background)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  String _getWinnerTextText(BadmintonMatchState state) {
    final winner = state.matchWinner;
    final players = winner == PlayerSide.sideA ? state.teamA : state.teamB;
    if (players.isNotEmpty) {
      final names = players.map((p) => _cleanPlayerName(p.name)).join(' & ');
      return '$names WINS';
    }
    return winner == PlayerSide.sideA ? 'SIDE A WINS' : 'SIDE B WINS';
  }

  String _cleanPlayerName(String raw) {
    String cleaned = raw;
    if (raw.contains('@')) {
      final part = raw.split('@').first;
      final formatted = part
          .split(RegExp(r'[._\-]'))
          .map((s) => s.isEmpty ? '' : '${s[0].toUpperCase()}${s.substring(1)}')
          .join(' ');
      cleaned = formatted.isNotEmpty ? formatted : part;
    }
    if (cleaned.length <= 8) return cleaned;
    return cleaned.substring(0, 8);
  }
}
