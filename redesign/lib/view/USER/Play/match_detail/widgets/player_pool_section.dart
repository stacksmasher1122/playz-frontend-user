import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(24))),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "All Joined Players (${players.length})",
                    style: GoogleFonts.inter(
                      fontSize: ResponsiveHelper.sp(17),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white60),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: players.length,
                  separatorBuilder: (_, __) => const Divider(color: Colors.white10),
                  itemBuilder: (context, index) {
                    final player = players[index];
                    final isHost = index == 0 || player.id == hostId;
                    final displayName = isHost ? "${player.name} (Host)" : player.name;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          XpAvatarRing(
                            imageUrl: player.avatarUrl,
                            xp: player.xp,
                            radius: 22,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayName,
                                  style: GoogleFonts.inter(
                                    fontSize: ResponsiveHelper.sp(14),
                                    fontWeight: isHost ? FontWeight.bold : FontWeight.w600,
                                    color: isHost ? AppColors.accent : Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${player.xp} XP",
                                  style: GoogleFonts.inter(
                                    fontSize: ResponsiveHelper.sp(11.5),
                                    color: Colors.white54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isHost)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
                              ),
                              child: Text(
                                "HOST 👑",
                                style: GoogleFonts.inter(
                                  fontSize: ResponsiveHelper.sp(10.5),
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
          padding: EdgeInsets.all(ResponsiveHelper.w(18)),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Joined Player Pool",
                    style: GoogleFonts.inter(
                      fontSize: ResponsiveHelper.sp(15),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  InkWell(
                    onTap: () => _showAllPlayersBottomSheet(context, players),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: Row(
                        children: [
                          Text(
                            "Show All (${players.length})",
                            style: GoogleFonts.inter(
                              fontSize: ResponsiveHelper.sp(12.5),
                              fontWeight: FontWeight.bold,
                              color: AppColors.accent,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.accent),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: ResponsiveHelper.h(95),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: players.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
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
                          const SizedBox(height: 6),
                          SizedBox(
                            width: 70,
                            child: Text(
                              displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: ResponsiveHelper.sp(11),
                                fontWeight: isHost ? FontWeight.bold : FontWeight.w500,
                                color: isHost ? AppColors.accent : Colors.white70,
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
