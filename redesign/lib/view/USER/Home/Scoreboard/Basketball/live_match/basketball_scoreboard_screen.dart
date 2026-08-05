import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Basketball/basketball_controller.dart';
import 'package:redesign/view/USER/Navigation/user_navigation.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Basketball/live_match/widgets/basketball_score_display.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Basketball/live_match/widgets/basketball_action_buttons.dart';

class BasketballScoreboardScreen extends StatelessWidget {
  const BasketballScoreboardScreen({super.key});

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
    final controller = Get.find<BasketballController>();

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
            'Basketball Live Scoreboard',
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
              minimumSize: const Size(double.infinity, 44),
            ),
            onPressed: () {
              Get.back();
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
      ),
      barrierDismissible: false,
    );
  }
}
