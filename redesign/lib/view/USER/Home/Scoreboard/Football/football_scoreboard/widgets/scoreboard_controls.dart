import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:redesign/score_engine/footballMatchEngine/football_match_engine.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_controller.dart';

class ScoreboardControls extends StatelessWidget {
  final MatchEngine engine;
  final VoidCallback showGoalModal;
  final VoidCallback showCardModal;
  final VoidCallback showSubModal;
  final VoidCallback showRulesModal;

  ScoreboardControls({
    super.key,
    required this.engine,
    required this.showGoalModal,
    required this.showCardModal,
    required this.showSubModal,
    required this.showRulesModal,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<FootballController>();
    bool run = engine.state.isRunning;
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      color: AppColors.outlineVariant,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _buildBigBtn(
                  "GOAL",
                  AppColors.success,
                  Icons.sports_soccer,
                  showGoalModal,
                ),
                SizedBox(width: 12),
                _buildBigBtn(
                  "CARD",
                  AppColors.warning,
                  Icons.style,
                  showCardModal,
                ),
                SizedBox(width: 12),
                _buildBigBtn(
                  "SUB",
                  AppColors.accent,
                  Icons.compare_arrows,
                  showSubModal,
                ),
                SizedBox(width: 12),
                _buildBigBtn(
                  "RULES",
                  Colors.deepPurple,
                  Icons.gavel,
                  showRulesModal,
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildAuxBtn(
                    run ? "PAUSE" : "RESUME",
                    run ? Icons.pause : Icons.play_arrow,
                    () => controller.toggleTimer(),
                    isActive: run,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildAuxBtn(
                    "NEXT PHASE",
                    Icons.skip_next,
                    () => _confirmPhaseAdvance(context, controller),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildAuxBtn(
                    "UNDO",
                    Icons.undo,
                    engine.canUndo
                        ? () {
                            controller.undo();
                          }
                        : () {},
                    isActive: engine.canUndo,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmPhaseAdvance(
    BuildContext context,
    FootballController controller,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          "Advance Phase?",
          style: TextStyle(color: AppColors.onPrimary),
        ),
        content: Text(
          "Are you sure you want to end the current phase?",
          style: TextStyle(color: AppColors.muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("CANCEL", style: TextStyle(color: AppColors.muted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
            onPressed: () {
              Navigator.pop(ctx);
              controller.endPhase();
            },
            child: Text(
              "ADVANCE",
              style: TextStyle(color: AppColors.background),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBigBtn(
    String label,
    Color color,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
            child: Column(
              children: [
                Icon(icon, color: AppColors.background, size: 28),
                SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.background,
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveHelper.sp(12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuxBtn(
    String label,
    IconData icon,
    VoidCallback onTap, {
    bool isActive = false,
  }) {
    return Material(
      color: isActive ? AppColors.accent : AppColors.surface,
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isActive ? AppColors.background : AppColors.muted,
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? AppColors.background : AppColors.muted,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
