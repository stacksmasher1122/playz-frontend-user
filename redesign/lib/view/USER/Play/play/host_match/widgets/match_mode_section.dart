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
            const Icon(Icons.emoji_events, color: AppColors.accent, size: 18),
            SizedBox(width: context.widthPct(2)),
            Text(
              'Match Mode',
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: context.responsiveFont(14),
              ),
            ),
          ],
        ),
        SizedBox(height: context.heightPct(1)),
        Row(
          children: [
            Expanded(
              child: _ModeCard(
                title: 'Casual Match',
                subtitle: 'Friendly, low-stakes game',
                icon: Icons.sports_soccer,
                isSelected: !isCompetitive,
                onTap: () => onModeChanged(false),
              ),
            ),
            SizedBox(width: context.widthPct(3)),
            Expanded(
              child: _ModeCard(
                title: 'Competitive',
                subtitle: 'High intensity & rank XP',
                icon: Icons.emoji_events,
                isSelected: isCompetitive,
                onTap: () => onModeChanged(true),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ModeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardHeight = context.heightPct(11).clamp(84.0, 100.0);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: cardHeight,
        padding: EdgeInsets.all(context.widthPct(3)),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accent.withValues(alpha: 0.15)
              : AppColors.card,
          borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.borderDark,
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? AppColors.accent : AppColors.textSecondary,
                  size: 22,
                ),
                const Spacer(),
                if (isSelected)
                  const Icon(Icons.check_circle, color: AppColors.accent, size: 18),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: context.responsiveFont(13),
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: context.responsiveFont(10),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
