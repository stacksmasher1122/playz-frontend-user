import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_controller.dart';
import 'package:redesign/score_engine/footballMatchEngine/football_match_engine.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

/// 3x2 Grid Action Controls Bar for Football Scoreboard adhering to AppColors design tokens.
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

  void _confirmEndMatch(BuildContext context, FootballController controller) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardSurface,
        title: Text('End Match?', style: TextStyle(color: AppColors.textPrimary)),
        content: Text('Are you sure you want to conclude this match session?',
            style: TextStyle(color: AppColors.mutedText)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('CANCEL', style: TextStyle(color: AppColors.mutedText)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              engine.endMatch();
            },
            child: Text('END MATCH', style: TextStyle(color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<FootballController>();
    final bool run = engine.state.isRunning;

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16.0)),
      color: AppColors.background,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row 1: GOAL | CARD | SUB
            Row(
              children: [
                Expanded(
                  child: _buildGridButton(
                    context,
                    label: 'GOAL',
                    icon: Icons.sports_soccer,
                    borderColor: AppColors.accent,
                    iconColor: AppColors.accent,
                    onTap: showGoalModal,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(10.0)),
                Expanded(
                  child: _buildGridButton(
                    context,
                    label: 'CARD',
                    icon: Icons.style,
                    borderColor: AppColors.warning,
                    iconColor: AppColors.warning,
                    onTap: showCardModal,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(10.0)),
                Expanded(
                  child: _buildGridButton(
                    context,
                    label: 'SUB',
                    icon: Icons.compare_arrows_rounded,
                    borderColor: AppColors.accent,
                    iconColor: AppColors.accent,
                    onTap: showSubModal,
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.h(10.0)),

            // Row 2: PAUSE / RESUME | END MATCH | UNDO
            Row(
              children: [
                Expanded(
                  child: _buildGridButton(
                    context,
                    label: run ? 'PAUSE' : 'RESUME',
                    icon: run ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    borderColor: AppColors.accent,
                    iconColor: AppColors.accent,
                    onTap: () => controller.toggleTimer(),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(10.0)),
                Expanded(
                  child: _buildGridButton(
                    context,
                    label: 'END MATCH',
                    icon: Icons.crop_square_rounded,
                    borderColor: AppColors.error,
                    iconColor: AppColors.error,
                    textColor: AppColors.error,
                    onTap: () => _confirmEndMatch(context, controller),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(10.0)),
                Expanded(
                  child: _buildGridButton(
                    context,
                    label: 'UNDO',
                    icon: Icons.undo_rounded,
                    borderColor: AppColors.accent,
                    iconColor: AppColors.accent,
                    onTap: () => controller.undo(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color borderColor,
    required Color iconColor,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
        child: Container(
          height: ResponsiveHelper.h(85.0),
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
            border: Border.all(color: borderColor.withValues(alpha: 0.6), width: 1.2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: iconColor,
                size: ResponsiveHelper.w(26.0),
              ),
              SizedBox(height: ResponsiveHelper.h(8.0)),
              Text(
                label,
                style: AppTypography.labelCaps.copyWith(
                  color: textColor ?? iconColor,
                  fontSize: ResponsiveHelper.sp(12.0),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ).responsive(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
