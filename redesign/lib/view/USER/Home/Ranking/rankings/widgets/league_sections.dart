import 'package:flutter/material.dart';
import 'package:redesign/model/User_Models/More_Models/leaderboard_model.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_dimensions.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class DynamicLeagueSections extends StatelessWidget {
  final List<LeaderboardPlayerModel> players;

  const DynamicLeagueSections({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    // Group players by Tier
    final Map<PlayerTier, List<LeaderboardPlayerModel>> tieredPlayers = {
      PlayerTier.legend: [],
      PlayerTier.elite: [],
      PlayerTier.prime: [],
      PlayerTier.rising: [],
      PlayerTier.rookie: [],
    };

    for (final player in players) {
      tieredPlayers[player.tier]?.add(player);
    }

    final activeTiers = PlayerTier.values.where((t) => (tieredPlayers[t] ?? []).isNotEmpty).toList();

    if (activeTiers.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(context.widthPct(6)),
        child: Center(
          child: Text(
            'No players found in this ranking scope.',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textSecondary,
              fontSize: context.responsiveFont(13),
            ),
          ),
        ),
      );
    }

    return Column(
      children: activeTiers.map((tier) {
        final tierList = tieredPlayers[tier]!;
        return _SingleLeagueSection(
          tier: tier,
          players: tierList,
        );
      }).toList(),
    );
  }
}

class _SingleLeagueSection extends StatelessWidget {
  final PlayerTier tier;
  final List<LeaderboardPlayerModel> players;

  const _SingleLeagueSection({
    required this.tier,
    required this.players,
  });

  Color get _tierColor {
    switch (tier) {
      case PlayerTier.legend:
        return AppColors.legendGold;
      case PlayerTier.elite:
        return AppColors.elitePurple;
      case PlayerTier.prime:
        return AppColors.primeTeal;
      case PlayerTier.rising:
        return AppColors.risingBlue;
      case PlayerTier.rookie:
        return AppColors.rookieSlate;
    }
  }

  IconData get _tierIcon {
    switch (tier) {
      case PlayerTier.legend:
        return Icons.stars;
      case PlayerTier.elite:
        return Icons.workspace_premium;
      case PlayerTier.prime:
        return Icons.emoji_events;
      case PlayerTier.rising:
        return Icons.trending_up;
      case PlayerTier.rookie:
        return Icons.shield_outlined;
    }
  }

  String get _tierTitle => '${tier.name.toUpperCase()} LEAGUE';

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.widthPct(4),
        context.heightPct(1.5),
        context.widthPct(4),
        context.heightPct(0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// SECTION HEADER
          Row(
            children: [
              Icon(_tierIcon, color: _tierColor, size: 20),
              SizedBox(width: context.widthPct(2)),
              Text(
                _tierTitle,
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(14),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.6,
                ),
              ),
              const Spacer(),
              Text(
                '${players.length} Players',
                style: AppTypography.bodyXs.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: context.responsiveFont(11),
                ),
              ),
            ],
          ),

          SizedBox(height: context.heightPct(1)),

          /// PLAYER ROWS
          ...players.map((player) => _RankRowItem(player: player)),
        ],
      ),
    );
  }
}

class _RankRowItem extends StatelessWidget {
  final LeaderboardPlayerModel player;

  const _RankRowItem({required this.player});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final isMe = player.isCurrentUser;
    final avatarRadius = context.minDimensionPct(4.0).clamp(14.0, 18.0);

    return Container(
      margin: EdgeInsets.only(bottom: context.heightPct(0.8)),
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(3.5),
        vertical: context.heightPct(1.2),
      ),
      decoration: BoxDecoration(
        color: isMe ? AppColors.accent.withValues(alpha: 0.15) : AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: isMe ? AppColors.accent.withValues(alpha: 0.6) : AppColors.borderDark,
          width: isMe ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          // Rank Number
          SizedBox(
            width: context.widthPct(8).clamp(26.0, 36.0),
            child: Text(
              player.formattedRank,
              style: AppTypography.headlineSm.copyWith(
                color: isMe ? AppColors.accent : AppColors.textPrimary,
                fontSize: context.responsiveFont(13),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: context.widthPct(2)),

          // Avatar Image
          CircleAvatar(
            radius: avatarRadius,
            backgroundColor: AppColors.surface,
            backgroundImage: NetworkImage(player.avatarUrl),
          ),
          SizedBox(width: context.widthPct(3)),

          // Name
          Expanded(
            child: Text(
              player.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.headlineSm.copyWith(
                color: isMe ? AppColors.accent : AppColors.textPrimary,
                fontSize: context.responsiveFont(13),
                fontWeight: isMe ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ),

          // Points
          Text(
            '${player.formattedPoints} pts',
            style: AppTypography.headlineSm.copyWith(
              color: isMe ? AppColors.accent : AppColors.textPrimary,
              fontSize: context.responsiveFont(13),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
