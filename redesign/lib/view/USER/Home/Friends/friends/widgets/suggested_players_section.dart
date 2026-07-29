import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SuggestedPlayersSection extends StatelessWidget {
  const SuggestedPlayersSection({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      children: const [
        SectionHeader('Suggested Players', action: 'View Map'),
        SuggestedPlayerCard(
          name: 'Rahul S.',
          level: 'Intermediate',
          meta: '500m · Football',
        ),
        SuggestedPlayerCard(
          name: 'Sneha K.',
          level: 'Pro',
          meta: '1.2km · Badminton',
        ),
      ],
    );
  }
}

class SuggestedPlayerCard extends StatelessWidget {
  final String name;
  final String level;
  final String meta;

  const SuggestedPlayerCard({
    super.key,
    required this.name,
    required this.level,
    required this.meta,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final avatarSize = context.minDimensionPct(11).clamp(38.0, 48.0);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.widthPct(4),
        context.heightPct(0.6),
        context.widthPct(4),
        context.heightPct(0.6),
      ),
      child: Container(
        padding: EdgeInsets.all(context.widthPct(3.5)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: avatarSize / 2,
              backgroundColor: AppColors.card,
              child: const Icon(Icons.person, color: AppColors.muted),
            ),
            SizedBox(width: context.widthPct(3)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.headlineSm.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: context.responsiveFont(15),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(width: context.widthPct(1.5)),
                      LevelBadge(level),
                    ],
                  ),
                  SizedBox(height: context.heightPct(0.3)),
                  Text(
                    meta,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.muted,
                      fontSize: context.responsiveFont(12),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.person_add_alt, color: AppColors.textPrimary),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class LevelBadge extends StatelessWidget {
  final String label;
  const LevelBadge(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final color = label == 'Pro' ? AppColors.accent : AppColors.muted;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(2),
        vertical: context.heightPct(0.4),
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(context.minDimensionPct(2.5)),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          style: AppTypography.labelCaps10.copyWith(
            color: color,
            fontSize: context.responsiveFont(11),
          ),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;

  const SectionHeader(this.title, {super.key, this.action});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.widthPct(4),
        context.heightPct(2),
        context.widthPct(4),
        context.heightPct(1),
      ),
      child: Row(
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(16),
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          if (action != null)
            Text(
              action!,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
                fontSize: context.responsiveFont(13),
              ),
            ),
        ],
      ),
    );
  }
}
