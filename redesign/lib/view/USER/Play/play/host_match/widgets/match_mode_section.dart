import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchModeSection extends StatelessWidget {
  final bool isCompetitive;
  final ValueChanged<bool> onModeChanged;

  const MatchModeSection({
    super.key,
    required this.isCompetitive,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.tune_rounded, color: AppColors.accent, size: 18),
            SizedBox(width: context.widthPct(2)),
            Text(
              'Match Type & Mode',
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: context.responsiveFont(14),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        SizedBox(height: context.heightPct(1)),

        Row(
          children: [
            Expanded(
              child: _buildModeCard(
                context: context,
                title: 'Casual Match',
                subtitle: 'Friendly, open to all skill levels',
                icon: Icons.emoji_events_outlined,
                isSelected: !isCompetitive,
                activeColor: AppColors.accent,
                onTap: () => onModeChanged(false),
              ),
            ),
            SizedBox(width: context.widthPct(2.5)),
            Expanded(
              child: _buildModeCard(
                context: context,
                title: 'Competitive',
                subtitle: 'Ranked, XP points & leaderboard',
                icon: Icons.workspace_premium_rounded,
                isSelected: isCompetitive,
                activeColor: const Color(0xFFA855F7),
                onTap: () => onModeChanged(true),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModeCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.all(context.widthPct(3.5)),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withValues(alpha: 0.12) : AppColors.card,
          borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
          border: Border.all(
            color: isSelected ? activeColor : AppColors.borderDark,
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: isSelected ? activeColor : AppColors.muted, size: 22),
            SizedBox(height: context.heightPct(1)),
            Text(
              title,
              style: AppTypography.headlineSm.copyWith(
                color: isSelected ? activeColor : AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: context.responsiveFont(13),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: context.heightPct(0.3)),
            Text(
              subtitle,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.muted,
                fontSize: context.responsiveFont(11),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
