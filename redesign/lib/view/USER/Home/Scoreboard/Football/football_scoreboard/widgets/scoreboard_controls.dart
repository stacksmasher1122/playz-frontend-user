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

  const ScoreboardControls({
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
    final bool run = engine.state.isRunning;
    final bool isPreMatch = engine.state.phase == MatchPhase.preMatch;
    final bool showRules = engine.allowProRules;

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: Color(0xFF161616),
        border: Border(
          top: BorderSide(color: Color(0xFF2A2A2A), width: 1.0),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Action Buttons Row (GOAL, CARD, SUB, [RULES])
            Row(
              children: [
                _buildBigBtn(
                  "GOAL",
                  AppColors.success,
                  Icons.sports_soccer,
                  showGoalModal,
                  isEnabled: engine.isPlayActive,
                ),
                SizedBox(width: ResponsiveHelper.w(8)),
                _buildBigBtn(
                  "CARD",
                  AppColors.warning,
                  Icons.style,
                  showCardModal,
                  isEnabled: engine.isPlayActive,
                ),
                SizedBox(width: ResponsiveHelper.w(8)),
                _buildBigBtn(
                  "SUB",
                  AppColors.accent,
                  Icons.compare_arrows,
                  showSubModal,
                  isEnabled: engine.isPlayActive,
                ),
                if (showRules) ...[
                  SizedBox(width: ResponsiveHelper.w(8)),
                  _buildBigBtn(
                    "RULES",
                    Color(0xFF7E57C2),
                    Icons.gavel,
                    showRulesModal,
                    isEnabled: true,
                  ),
                ],
              ],
            ),
            SizedBox(height: ResponsiveHelper.h(12)),

            // Control Bar Row
            if (isPreMatch)
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildAuxBtn(
                      "START MATCH",
                      Icons.play_arrow,
                      () {
                        if (engine.state.phase == MatchPhase.preMatch) {
                          engine.startMatch();
                        }
                        controller.toggleTimer();
                      },
                      isActive: true,
                    ),
                  ),
                  if (engine.canUndo) ...[
                    SizedBox(width: ResponsiveHelper.w(8)),
                    Expanded(
                      flex: 1,
                      child: _buildAuxBtn(
                        "UNDO",
                        Icons.undo,
                        () => controller.undo(),
                        isActive: true,
                      ),
                    ),
                  ],
                ],
              )
            else
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
                  SizedBox(width: ResponsiveHelper.w(8)),
                  if (showRules)
                    Expanded(
                      child: _buildAuxBtn(
                        "NEXT PHASE",
                        Icons.skip_next,
                        () => _confirmPhaseAdvance(context, controller),
                      ),
                    )
                  else
                    Expanded(
                      child: _buildAuxBtn(
                        "END MATCH",
                        Icons.stop_circle,
                        () => _confirmEndMatch(context, controller),
                        isDanger: true,
                      ),
                    ),
                  SizedBox(width: ResponsiveHelper.w(8)),
                  Expanded(
                    child: _buildAuxBtn(
                      "UNDO",
                      Icons.undo,
                      engine.canUndo ? () => controller.undo() : () {},
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
        backgroundColor: Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
          side: BorderSide(color: Color(0xFF2C2C2C)),
        ),
        title: Text(
          "Advance Phase?",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Are you sure you want to end the current phase?",
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("CANCEL", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              controller.endPhase();
            },
            child: Text(
              "ADVANCE",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmEndMatch(
    BuildContext context,
    FootballController controller,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
          side: BorderSide(color: Color(0xFF2C2C2C)),
        ),
        title: Text(
          "End Match?",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Are you sure you want to complete and end this match?",
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("CANCEL", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              controller.endMatch();
            },
            child: Text(
              "END MATCH",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
    VoidCallback onTap, {
    bool isEnabled = true,
  }) {
    final effectiveColor = isEnabled ? color : color.withValues(alpha: 0.35);

    return Expanded(
      child: Material(
        color: effectiveColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        child: InkWell(
          onTap: isEnabled
              ? onTap
              : () {
                  Get.snackbar(
                    "Match Not Active",
                    "Please start or resume the match timer to score.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Color(0xFF222222),
                    colorText: Colors.amberAccent,
                    margin: EdgeInsets.all(ResponsiveHelper.w(12)),
                    duration: Duration(seconds: 2),
                  );
                },
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: isEnabled ? Colors.black : Colors.black45,
                    size: 24,
                  ),
                  SizedBox(height: 2),
                  Text(
                    label,
                    style: TextStyle(
                      color: isEnabled ? Colors.black : Colors.black45,
                      fontWeight: FontWeight.w900,
                      fontSize: ResponsiveHelper.sp(11),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
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
    bool isDanger = false,
  }) {
    Color bg = Color(0xFF222222);
    Color fg = Colors.grey;

    if (isActive) {
      bg = AppColors.accent;
      fg = Colors.black;
    } else if (isDanger) {
      bg = AppColors.error.withValues(alpha: 0.2);
      fg = AppColors.error;
    }

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveHelper.h(12),
            horizontal: ResponsiveHelper.w(8),
          ),
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: fg,
                  size: 18,
                ),
                SizedBox(width: ResponsiveHelper.w(6)),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: fg,
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveHelper.sp(12),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
