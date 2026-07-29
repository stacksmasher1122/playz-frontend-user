import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PlayerCounterSection extends StatelessWidget {
  final int maxPlayers;
  final ValueChanged<int> onPlayersChanged;

  const PlayerCounterSection({
    super.key,
    required this.maxPlayers,
    required this.onPlayersChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final presets = const [4, 6, 10, 12, 14, 16, 22];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.people_outline_rounded, color: AppColors.accent, size: 18),
            SizedBox(width: context.widthPct(2)),
            Text(
              'Total Required Players',
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
        SizedBox(height: context.heightPct(1.2)),

        Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.widthPct(4),
            vertical: context.heightPct(1.5),
          ),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Maximum Players',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.muted,
                      fontSize: context.responsiveFont(12),
                    ),
                  ),
                  SizedBox(height: context.heightPct(0.3)),
                  Text(
                    '$maxPlayers Players',
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: context.responsiveFont(18),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.textPrimary.withValues(alpha: 0.08),
                      shape: const CircleBorder(),
                    ),
                    icon: const Icon(Icons.remove, color: AppColors.textPrimary, size: 18),
                    onPressed: () {
                      if (maxPlayers > 2) {
                        onPlayersChanged(maxPlayers - 1);
                      }
                    },
                  ),
                  SizedBox(width: context.widthPct(2)),
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      shape: const CircleBorder(),
                    ),
                    icon: const Icon(Icons.add, color: AppColors.background, size: 18),
                    onPressed: () {
                      if (maxPlayers < 50) {
                        onPlayersChanged(maxPlayers + 1);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: context.heightPct(1.2)),

        SizedBox(
          height: context.heightPct(4.5).clamp(34.0, 42.0),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: presets.length,
            separatorBuilder: (_, __) => SizedBox(width: context.widthPct(2)),
            itemBuilder: (context, i) {
              final count = presets[i];
              final isSelected = maxPlayers == count;
              return ChoiceChip(
                showCheckmark: false,
                label: Text('${count}P'),
                selected: isSelected,
                selectedColor: AppColors.accent,
                backgroundColor: AppColors.card,
                labelStyle: AppTypography.bodySm.copyWith(
                  color: isSelected ? AppColors.background : AppColors.muted,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: context.responsiveFont(12),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
                  side: BorderSide(
                    color: isSelected ? AppColors.accent : AppColors.borderDark,
                  ),
                ),
                onSelected: (_) => onPlayersChanged(count),
              );
            },
          ),
        ),
      ],
    );
  }
}
