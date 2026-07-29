import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/view/USER/Play/play/widgets/xp_avatar_ring.dart';

class PlayerProfile {
  final String id;
  final String name;
  final String avatarUrl;
  final int xp;

  PlayerProfile({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.xp,
  });
}

class PlayerPoolSection extends StatelessWidget {
  final String hostId;
  final String hostName;
  final String hostAvatar;
  final int hostXp;
  final List<String> playerIds;

  const PlayerPoolSection({
    super.key,
    this.hostId = '',
    this.hostName = 'Host Player',
    this.hostAvatar = 'https://i.pravatar.cc/150?img=1',
    this.hostXp = 2500,
    this.playerIds = const [],
  });

  Future<List<PlayerProfile>> _fetchPlayerProfiles() async {
    final List<PlayerProfile> profiles = [];

    // Ensure host is included as the first profile
    final effectiveIds = playerIds.isNotEmpty
        ? playerIds
        : [hostId.isNotEmpty ? hostId : 'host_default'];

    for (int i = 0; i < effectiveIds.length; i++) {
      final pid = effectiveIds[i];

      if (pid == hostId || pid == 'host_default' || (i == 0 && hostId.isEmpty)) {
        profiles.add(PlayerProfile(
          id: pid,
          name: hostName,
          avatarUrl: hostAvatar,
          xp: hostXp,
        ));
        continue;
      }

      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(pid).get();
        if (doc.exists) {
          final data = doc.data() ?? {};
          profiles.add(PlayerProfile(
            id: pid,
            name: (data['userName'] ?? data['name'] ?? data['displayName'] ?? 'Player ${i + 1}').toString(),
            avatarUrl: (data['profileImageUrl'] ?? data['avatarUrl'] ?? 'https://i.pravatar.cc/150?img=${(i % 10) + 1}').toString(),
            xp: (data['xp'] as num?)?.toInt() ?? 1000,
          ));
        } else {
          profiles.add(PlayerProfile(
            id: pid,
            name: 'Player ${i + 1}',
            avatarUrl: 'https://i.pravatar.cc/150?img=${(i % 10) + 1}',
            xp: 800,
          ));
        }
      } catch (_) {
        profiles.add(PlayerProfile(
          id: pid,
          name: 'Player ${i + 1}',
          avatarUrl: 'https://i.pravatar.cc/150?img=${(i % 10) + 1}',
          xp: 800,
        ));
      }
    }

    return profiles;
  }

  void _showAllPlayersBottomSheet(BuildContext context, List<PlayerProfile> players) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(context.minDimensionPct(6))),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            context.widthPct(5),
            context.heightPct(2),
            context.widthPct(5),
            context.heightPct(4),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: context.widthPct(10).clamp(36.0, 44.0),
                  height: 4,
                  margin: EdgeInsets.only(bottom: context.heightPct(2)),
                  decoration: BoxDecoration(
                    color: AppColors.muted.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "All Joined Players (${players.length})",
                    style: AppTypography.headlineSm.copyWith(
                      fontSize: context.responsiveFont(17),
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textSecondary),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              SizedBox(height: context.heightPct(1.5)),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: players.length,
                  separatorBuilder: (_, __) => const Divider(color: AppColors.borderDark),
                  itemBuilder: (context, index) {
                    final player = players[index];
                    final isHost = index == 0 || player.id == hostId;
                    final displayName = isHost ? "${player.name} (Host)" : player.name;

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: context.heightPct(0.8)),
                      child: Row(
                        children: [
                          XpAvatarRing(
                            imageUrl: player.avatarUrl,
                            xp: player.xp,
                            radius: 22,
                          ),
                          SizedBox(width: context.widthPct(3.5)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayName,
                                  style: AppTypography.headlineSm.copyWith(
                                    fontSize: context.responsiveFont(14),
                                    fontWeight: isHost ? FontWeight.bold : FontWeight.w600,
                                    color: isHost ? AppColors.accent : AppColors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: context.heightPct(0.3)),
                                Text(
                                  "${player.xp} XP",
                                  style: AppTypography.bodySm.copyWith(
                                    fontSize: context.responsiveFont(11.5),
                                    color: AppColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isHost)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.widthPct(2.5),
                                vertical: context.heightPct(0.5),
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(context.minDimensionPct(2)),
                                border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
                              ),
                              child: Text(
                                "HOST 👑",
                                style: AppTypography.labelCaps10.copyWith(
                                  fontSize: context.responsiveFont(10.5),
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.accent,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return FutureBuilder<List<PlayerProfile>>(
      future: _fetchPlayerProfiles(),
      builder: (context, snapshot) {
        final players = snapshot.data ?? [
          PlayerProfile(
            id: hostId,
            name: hostName,
            avatarUrl: hostAvatar,
            xp: hostXp,
          )
        ];

        return Container(
          padding: EdgeInsets.all(context.widthPct(4.5)),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(context.minDimensionPct(4.5)),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Joined Player Pool",
                    style: AppTypography.headlineSm.copyWith(
                      fontSize: context.responsiveFont(15),
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  InkWell(
                    onTap: () => _showAllPlayersBottomSheet(context, players),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.widthPct(1.5),
                        vertical: context.heightPct(0.5),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Show All (${players.length})",
                            style: AppTypography.headlineSm.copyWith(
                              fontSize: context.responsiveFont(12.5),
                              fontWeight: FontWeight.bold,
                              color: AppColors.accent,
                            ),
                          ),
                          SizedBox(width: context.widthPct(1)),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.accent),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.heightPct(2)),
              SizedBox(
                height: context.heightPct(12).clamp(88.0, 108.0),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: players.length,
                  separatorBuilder: (_, __) => SizedBox(width: context.widthPct(3.5)),
                  itemBuilder: (context, index) {
                    final player = players[index];
                    final isHost = index == 0 || player.id == hostId;
                    final displayName = isHost ? "${player.name} (Host)" : player.name;

                    return GestureDetector(
                      onTap: () => _showAllPlayersBottomSheet(context, players),
                      child: Column(
                        children: [
                          XpAvatarRing(
                            imageUrl: player.avatarUrl,
                            xp: player.xp,
                            radius: 24,
                          ),
                          SizedBox(height: context.heightPct(0.8)),
                          SizedBox(
                            width: context.widthPct(18).clamp(64.0, 76.0),
                            child: Text(
                              displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: AppTypography.bodySm.copyWith(
                                fontSize: context.responsiveFont(11),
                                fontWeight: isHost ? FontWeight.bold : FontWeight.w500,
                                color: isHost ? AppColors.accent : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
