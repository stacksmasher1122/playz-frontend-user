import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Badminton/live_match/match_stats/match_stats_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Tennis/live_scoring/live_scoring_screen.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';

class SmBottomNavWidget extends StatelessWidget {
  const SmBottomNavWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withValues(alpha: 0.9),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 16,
              top: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTab(
                  icon: Icons.settings_applications,
                  label: 'Setup',
                  isActive: true,
                  onTap: () {
                    // Current screen, do nothing or pop to it if deep
                  },
                ),
                _buildTab(
                  icon: Icons.sports_tennis,
                  label: 'Live',
                  isActive: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LiveScoringScreen(),
                      ),
                    );
                  },
                ),
                _buildTab(
                  icon: Icons.equalizer,
                  label: 'Stats',
                  isActive: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MatchStatsScreen(),
                      ),
                    );
                  },
                ),
                _buildTab(
                  icon: Icons.description,
                  label: 'Summary',
                  isActive: false,
                  onTap: () {
                    print("Navigate to Summary");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      hoverColor: AppColors.surfaceBright.withValues(alpha: 0.1),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          if (isActive)
            Positioned(
              top: 0,
              left: -10,
              right: -10,
              child: Container(height: 2, color: AppColors.primaryContainer),
            ),
          Padding(
            padding: const EdgeInsets.only(
              top: 8,
              left: 16,
              right: 16,
              bottom: 8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: isActive
                      ? AppColors.primaryContainer
                      : AppColors.onSurfaceVariant,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: AppTypography.labelCaps.copyWith(
                    color: isActive
                        ? AppColors.primaryContainer
                        : AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
