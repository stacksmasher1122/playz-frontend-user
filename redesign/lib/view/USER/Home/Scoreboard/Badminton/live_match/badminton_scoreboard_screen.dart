import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/badminton_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/badminton_state_models.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Badminton/live_match/widgets/scoring_console.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Badminton/live_match/widgets/badminton_scoreboard_header.dart';
import 'package:redesign/view/USER/Navigation/user_navigation.dart';

class BadmintonScoreboardScreen extends StatefulWidget {
  BadmintonScoreboardScreen({super.key});

  @override
  State<BadmintonScoreboardScreen> createState() => _BadmintonScoreboardScreenState();
}

class _BadmintonScoreboardScreenState extends State<BadmintonScoreboardScreen> {
  final BadmintonController controller = Get.find<BadmintonController>();

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
            child: Text(
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
        if (shouldPop && mounted) {
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
          if (!controller.isEngineReady.value || controller.liveState.value == null) {
            return Center(child: CircularProgressIndicator(color: AppColors.accent));
          }

          final state = controller.liveState.value!;
          final isCompleted = state.status == MatchStatus.completed;

          return SafeArea(
            child: Column(
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
                        SizedBox(height: 32),
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
                                SizedBox(height: 12),
                                Text(
                                  'MATCH COMPLETED',
                                  style: TextStyle(
                                    color: AppColors.accent,
                                    fontSize: ResponsiveHelper.sp(20),
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  state.matchWinner == PlayerSide.sideA ? 'SIDE A WINS' : 'SIDE B WINS',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ResponsiveHelper.sp(16),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                if (controller.tournamentId.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(top: ResponsiveHelper.h(16)),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.background,
                                        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(24), vertical: ResponsiveHelper.h(12)),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.w(8))),
                                      ),
                                      onPressed: () => controller.endTournamentMatch(),
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
                  ScoringConsole(
                    onUndo: controller.undoLastEvent,
                    onPointSideA: () => controller.addPoint(PlayerSide.sideA),
                    onPointSideB: () => controller.addPoint(PlayerSide.sideB),
                    controller: controller,
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
