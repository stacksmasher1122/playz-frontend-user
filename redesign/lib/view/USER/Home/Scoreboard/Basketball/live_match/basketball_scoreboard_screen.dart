import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Basketball/basketball_controller.dart';
import 'package:redesign/view/USER/Navigation/user_navigation.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Basketball/live_match/widgets/basketball_score_display.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Basketball/live_match/widgets/basketball_action_buttons.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Basketball/live_match/widgets/basketball_quarter_ended_sheet.dart';

class BasketballScoreboardScreen extends StatefulWidget {
  const BasketballScoreboardScreen({super.key});

  @override
  State<BasketballScoreboardScreen> createState() => _BasketballScoreboardScreenState();
}

class _BasketballScoreboardScreenState extends State<BasketballScoreboardScreen> {
  final BasketballController controller = Get.find<BasketballController>();
  Worker? _quarterWorker;
  Worker? _otWorker;
  bool _isQuarterSheetActive = false;

  @override
  void initState() {
    super.initState();
    _quarterWorker = ever(controller.pendingQuarterEnded, (endedQ) {
      if (endedQ > 0 && !_isQuarterSheetActive && mounted && !controller.isReadOnly.value) {
        _showQuarterEndedModal(endedQ, isOvertime: false);
      }
    });

    _otWorker = ever(controller.pendingOvertimeEnded, (endedQ) {
      if (endedQ > 0 && !_isQuarterSheetActive && mounted && !controller.isReadOnly.value) {
        _showQuarterEndedModal(endedQ, isOvertime: true);
      }
    });
  }

  @override
  void dispose() {
    _quarterWorker?.dispose();
    _otWorker?.dispose();
    super.dispose();
  }

  void _showQuarterEndedModal(int endedQ, {required bool isOvertime}) {
    _isQuarterSheetActive = true;
    BasketballQuarterEndedSheet.show(
      context,
      controller: controller,
      endedQuarter: endedQ,
      isOvertime: isOvertime,
      onStartNextQuarter: () {
        _isQuarterSheetActive = false;
        controller.pendingQuarterEnded.value = 0;
        controller.pendingOvertimeEnded.value = 0;
        controller.startMatch();
      },
    );
  }

  void _navigateToScoreboardHub(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const UserAppNavShell(
          initialIndex: 2,
          playInitialTab: 2,
        ),
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
        body: SafeArea(
          child: Obx(() {
            if (!controller.isEngineReady.value || controller.liveState.value == null) {
              return const Center(child: CircularProgressIndicator(color: AppColors.accent));
            }

            final state = controller.liveState.value!;
            if (state.isMatchFinished) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showMatchFinishedDialog(context, controller);
              });
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  const BasketballScoreDisplay(),
                  const BasketballActionButtons(),
                ],
              ),
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

  void _showMatchFinishedDialog(BuildContext context, BasketballController controller) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.cardSurface,
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
            if (!controller.hasMatchEndUndoBeenUsed.value && !controller.isReadOnly.value)
              TextButton.icon(
                onPressed: () {
                  Get.back();
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
            ),
            onPressed: () => _navigateToScoreboardHub(context),
            child: Text(
              'GO TO MATCH HUB',
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
}
