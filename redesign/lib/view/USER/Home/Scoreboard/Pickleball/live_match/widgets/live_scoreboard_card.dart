import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'serving_indicator.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LiveScoreboardCard extends StatelessWidget {
  final int scoreA;
  final int scoreB;
  final bool isServingTeamA;
  final AnimationController glowController;
  final AnimationController pulseController;

  LiveScoreboardCard({
    super.key,
    required this.scoreA,
    required this.scoreB,
    required this.isServingTeamA,
    required this.glowController,
    required this.pulseController,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return RepaintBoundary(
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(24)),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
          border: Border.all(color: AppColors.surfaceContainerHighest, width: 1),
        ),
        child: Column(
          children: [
            ServingIndicator(
              isServingLeft: isServingTeamA,
              pulseController: pulseController,
            ),
            SizedBox(height: 16),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: _buildScoreDisplay(
                      score: scoreA,
                      isServing: isServingTeamA,
                    ),
                  ),
                  VerticalDivider(
                    color: AppColors.surfaceContainerHighest,
                    thickness: 1,
                    width: ResponsiveHelper.w(1),
                  ),
                  Expanded(
                    child: _buildScoreDisplay(
                      score: scoreB,
                      isServing: !isServingTeamA,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreDisplay({required int score, required bool isServing}) {
    return Center(
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation,
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: AnimatedBuilder(
          key: ValueKey<int>(score),
          animation: glowController,
          builder: (context, child) {
            double blur = isServing ? Tween<double>(begin: 8.0, end: 24.0).evaluate(glowController) : 0.0;
            return Text(
              '$score',
              style: TextStyle(
                fontFamily: 'Inter', // Assuming standard body font
                fontSize: ResponsiveHelper.sp(100), // Massive font size
                fontWeight: FontWeight.w900,
                color: isServing ? AppColors.primaryContainer : AppColors.muted,
                height: ResponsiveHelper.h(1.0),
                shadows: isServing
                    ? [
                        BoxShadow(
                          color: AppColors.primaryContainer.withOpacity(0.5),
                          blurRadius: blur,
                          offset: Offset.zero,
                        ),
                      ]
                    : [],
              ),
            );
          },
        ),
      ),
    );
  }
}
