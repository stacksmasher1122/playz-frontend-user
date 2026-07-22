import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../football_scoreboard_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ScoreboardControls extends StatelessWidget {
  final MatchEngine engine;
  final VoidCallback showGoalModal;
  final VoidCallback showCardModal;
  final VoidCallback showSubModal;

  ScoreboardControls({
    super.key,
    required this.engine,
    required this.showGoalModal,
    required this.showCardModal,
    required this.showSubModal,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      color: kSurfaceHighlight,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _buildBigBtn(
                  "GOAL",
                  kGoal,
                  Icons.sports_soccer,
                  showGoalModal,
                ),
                SizedBox(width: 12),
                _buildBigBtn("CARD", kYellow, Icons.style, showCardModal),
                SizedBox(width: 12),
                _buildBigBtn(
                  "SUB",
                  kAccent,
                  Icons.compare_arrows,
                  showSubModal,
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: engine.isRunning,
                    builder: (_, run, __) => _buildAuxBtn(
                      run ? "PAUSE" : "RESUME",
                      run ? Icons.pause : Icons.play_arrow,
                      engine.toggleTimer,
                      isActive: true,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildAuxBtn("PHASE", Icons.flag, engine.endPhase),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBigBtn(
    String label,
    Color col,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: Material(
        color: col.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
          child: SizedBox(
            height: ResponsiveHelper.h(70),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: col, size: 28),
                SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(color: col, fontWeight: FontWeight.bold),
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
      color: isActive ? kAccent : kSurface,
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        child: SizedBox(
          height: ResponsiveHelper.h(50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isActive ? AppColors.background : kTextSecondary,
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? AppColors.background : kTextSecondary,
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
