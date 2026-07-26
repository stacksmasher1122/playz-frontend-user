import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/view/USER/Play/play/widgets/xp_avatar_ring.dart';

class PlayerPoolSection extends StatelessWidget {
  final String hostName;
  final String hostAvatar;
  final int hostXp;
  final List<String>? playerAvatars;

  const PlayerPoolSection({
    super.key,
    this.hostName = 'Host Player',
    this.hostAvatar = 'https://i.pravatar.cc/150?img=1',
    this.hostXp = 2500,
    this.playerAvatars,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final avatars = (playerAvatars != null && playerAvatars!.isNotEmpty)
        ? playerAvatars!
        : [
            hostAvatar,
            'https://i.pravatar.cc/150?img=2',
            'https://i.pravatar.cc/150?img=3',
            'https://i.pravatar.cc/150?img=4',
            'https://i.pravatar.cc/150?img=5',
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
              Text(
                "${avatars.length} Joined",
                style: GoogleFonts.inter(
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          SizedBox(
            height: ResponsiveHelper.h(90),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: avatars.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final isHost = index == 0;
                return Column(
                  children: [
                    XpAvatarRing(
                      imageUrl: avatars[index],
                      xp: isHost ? hostXp : 1200 - (index * 200),
                      radius: 24,
                    ),
                    SizedBox(height: 6),
                    Text(
                      isHost ? "Host 👑" : "Player ${index + 1}",
                      style: GoogleFonts.inter(
                        fontSize: ResponsiveHelper.sp(11),
                        fontWeight: isHost ? FontWeight.bold : FontWeight.w500,
                        color: isHost ? AppColors.accent : Colors.white70,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
