import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/leaderboard_model.dart';

class LeaderboardPodium extends StatelessWidget {
  final List<LeaderboardPlayerModel> top3;

  const LeaderboardPodium({super.key, required this.top3});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    if (top3.length < 3) return const SizedBox.shrink();

    final rank1 = top3.firstWhere((p) => p.rank == 1, orElse: () => top3[0]);
    final rank2 = top3.firstWhere((p) => p.rank == 2, orElse: () => top3[1]);
    final rank3 = top3.firstWhere((p) => p.rank == 3, orElse: () => top3[2]);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Rank 2 (Left)
          Expanded(
            child: _PodiumColumn(
              player: rank2,
              podiumHeight: context.heightPct(9).clamp(60.0, 80.0),
              isFirst: false,
            ),
          ),
          SizedBox(width: context.widthPct(2.5)),

          // Rank 1 (Center - Elevated)
          Expanded(
            child: _PodiumColumn(
              player: rank1,
              podiumHeight: context.heightPct(13).clamp(90.0, 115.0),
              isFirst: true,
            ),
          ),
          SizedBox(width: context.widthPct(2.5)),

          // Rank 3 (Right)
          Expanded(
            child: _PodiumColumn(
              player: rank3,
              podiumHeight: context.heightPct(7).clamp(45.0, 60.0),
              isFirst: false,
            ),
          ),
        ],
      ),
    );
  }
}

class _PodiumColumn extends StatelessWidget {
  final LeaderboardPlayerModel player;
  final double podiumHeight;
  final bool isFirst;

  const _PodiumColumn({
    required this.player,
    required this.podiumHeight,
    required this.isFirst,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final avatarRadius = isFirst ? context.widthPct(8.5).clamp(30.0, 38.0) : context.widthPct(7).clamp(24.0, 32.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar + Rank Badge Overlay
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Glowing border for Rank 1
            Container(
              padding: EdgeInsets.all(isFirst ? 3.5 : 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isFirst ? AppColors.accent : Colors.white24,
                boxShadow: isFirst
                    ? [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.5),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: CircleAvatar(
                radius: avatarRadius,
                backgroundColor: AppColors.card,
                backgroundImage: NetworkImage(player.avatarUrl),
              ),
            ),

            // Rank Badge Number Circle at bottom
            Positioned(
              bottom: -6,
              child: Container(
                width: isFirst ? 22 : 18,
                height: isFirst ? 22 : 18,
                decoration: BoxDecoration(
                  color: isFirst ? AppColors.accent : const Color(0xFF333333),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.background,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${player.rank}',
                    style: AppTypography.labelCaps10.copyWith(
                      color: isFirst ? AppColors.background : AppColors.textPrimary,
                      fontSize: context.responsiveFont(isFirst ? 11 : 9),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: context.heightPct(1.5)),

        // Name
        Text(
          player.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.responsiveFont(isFirst ? 14 : 12),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: context.heightPct(0.3)),

        // Points
        Text(
          '${player.points.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} pts',
          style: AppTypography.bodySm.copyWith(
            color: AppColors.accent,
            fontSize: context.responsiveFont(isFirst ? 12 : 10),
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        SizedBox(height: context.heightPct(1.2)),

        // Dark Gray Rounded Pedestal Block
        Container(
          width: double.infinity,
          height: podiumHeight,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
          ),
        ),
      ],
    );
  }
}
