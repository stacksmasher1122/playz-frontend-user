import 'package:flutter/material.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_state_models.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class AdvancedActionsGrid extends StatelessWidget {
  final Player? striker;
  final Player? nonStriker;
  final VoidCallback onRetireBowler;
  final VoidCallback onVideoRefer;
  final VoidCallback onRetireBatter;
  final VoidCallback onMatchBreak;
  final bool allowSubstitutes;

  const AdvancedActionsGrid({
    super.key,
    required this.striker,
    required this.nonStriker,
    required this.onRetireBowler,
    required this.onVideoRefer,
    required this.onRetireBatter,
    required this.onMatchBreak,
    this.allowSubstitutes = false,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final retireSub = allowSubstitutes ? 'Hurt / Substitute' : 'Injured / Hurt';

    return Container(
      margin: EdgeInsets.all(ResponsiveHelper.w(16)),
      child: Column(
        children: [
          Row(
            children: [
              _advBtn(
                Icons.person_off_outlined,
                'Retire Bowler',
                retireSub,
                onRetireBowler,
              ),
              SizedBox(width: ResponsiveHelper.w(8)),
              _advBtn(
                Icons.videocam,
                'Video Refer',
                'Third Umpire',
                onVideoRefer,
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(8)),
          Row(
            children: [
              _advBtn(Icons.person_off, 'Retire Batter', retireSub, () {
                if (striker != null || nonStriker != null) {
                  onRetireBatter();
                }
              }),
              SizedBox(width: ResponsiveHelper.w(8)),
              _advBtn(
                Icons.pause_circle_outline,
                'Match Break',
                'Drinks / Rain',
                onMatchBreak,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _advBtn(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(16)),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.muted, size: 22),
              SizedBox(width: ResponsiveHelper.w(8)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: ResponsiveHelper.sp(13),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(color: AppColors.muted, fontSize: ResponsiveHelper.sp(12)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
