import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/MuayThai/muay_thai_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/MuayThai/live_match/widgets/muay_thai_score_display.dart';
import 'package:redesign/view/USER/Home/Scoreboard/MuayThai/live_match/widgets/muay_thai_action_buttons.dart';
import 'package:redesign/view/USER/Home/scoreboard_screen/scoreboards_screen.dart';

class MuayThaiScoreboardScreen extends StatefulWidget {
  const MuayThaiScoreboardScreen({super.key});

  @override
  State<MuayThaiScoreboardScreen> createState() => _MuayThaiScoreboardScreenState();
}

class _MuayThaiScoreboardScreenState extends State<MuayThaiScoreboardScreen> {
  Worker? _matchFinishedWorker;
  bool _isDialogShowing = false;
  Timer? _countdownTimer;
  int _secondsRemaining = 60;

  @override
  void initState() {
    super.initState();
    final controller = Get.find<MuayThaiController>();

    _matchFinishedWorker = ever(controller.liveState, (state) {
      if (state != null && state.isMatchFinished && !_isDialogShowing) {
        _isDialogShowing = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _showMatchFinishedDialog(context, controller);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _matchFinishedWorker?.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _showMatchFinishedDialog(BuildContext context, MuayThaiController controller) {
    _secondsRemaining = 60;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        if (mounted) {
          setState(() {
            _secondsRemaining--;
          });
        }
      } else {
        timer.cancel();
        if (mounted && _isDialogShowing) {
          Navigator.of(context).pop();
          Get.offAll(() => const ScoreboardHubScreen());
        }
      }
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final matchResult = controller.currentMatch.value?.matchResult ?? 'Bout Finished';

            return AlertDialog(
              backgroundColor: AppColors.cardSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: AppColors.accent.withValues(alpha: 0.3)),
              ),
              title: Row(
                children: [
                  const Icon(Icons.emoji_events, color: AppColors.accent, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'BOUT FINISHED',
                      style: GoogleFonts.inter(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      matchResult,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Auto exiting in $_secondsRemaining seconds...',
                    style: GoogleFonts.inter(
                      color: AppColors.mutedText,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              actions: [
                if (!controller.hasMatchEndUndoBeenUsed.value)
                  TextButton(
                    onPressed: () {
                      _countdownTimer?.cancel();
                      _isDialogShowing = false;
                      Navigator.of(ctx).pop();
                      controller.undoLastMatchPoint();
                    },
                    child: Text(
                      'Undo Finish & Resume',
                      style: GoogleFonts.inter(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    _countdownTimer?.cancel();
                    Navigator.of(ctx).pop();
                    Get.offAll(() => const ScoreboardHubScreen());
                  },
                  child: Text(
                    'DONE',
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<MuayThaiController>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        _showExitConfirmationDialog(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => _showExitConfirmationDialog(context),
          ),
          title: Obx(() {
            final isReadOnly = controller.isReadOnly.value;
            return Row(
              children: [
                Text(
                  'Muay Thai Live',
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: ResponsiveHelper.sp(16),
                    fontWeight: FontWeight.bold,
                  ).responsive(context),
                ),
                if (isReadOnly) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
                    ),
                    child: const Text(
                      'SPECTATOR',
                      style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ],
            );
          }),
        ),
        body: const SafeArea(
          child: Column(
            children: [
              MuayThaiScoreDisplay(),
              Spacer(),
            ],
          ),
        ),
        bottomNavigationBar: const MuayThaiActionButtons(),
      ),
    );
  }

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardSurface,
        title: const Text('Exit Muay Thai Bout?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text(
          'Your bout progress is saved in SQLite and Cloud. You can resume it anytime from the Scoreboard Hub.',
          style: TextStyle(color: AppColors.mutedText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL', style: TextStyle(color: AppColors.mutedText)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
            onPressed: () {
              Navigator.pop(ctx);
              Get.offAll(() => const ScoreboardHubScreen());
            },
            child: const Text('EXIT TO HUB', style: TextStyle(color: AppColors.background, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
