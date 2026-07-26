import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/view/USER/Play/match_detail/match_detail_screen.dart';
import 'package:redesign/controller/User_Controller/Match_Controller/match_controller.dart';
import 'package:redesign/view/USER/Play/play/play_models.dart';
import 'xp_avatar_ring.dart';
import 'package:redesign/theme/responsive_helper.dart';
import '../host_match/host_match_screen.dart';

class GameList extends StatelessWidget {
  const GameList({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final matchCtrl = Get.isRegistered<MatchController>()
        ? Get.find<MatchController>()
        : Get.put(MatchController());

    return Obx(() {
      if (matchCtrl.isLoading.value) {
        return Padding(
          padding: EdgeInsets.all(ResponsiveHelper.w(32)),
          child: const Center(
            child: CircularProgressIndicator(color: AppColors.accent),
          ),
        );
      }

      final games = matchCtrl.filteredMatches;

      if (games.isEmpty) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.w(20),
            vertical: ResponsiveHelper.h(32),
          ),
          child: Column(
            children: [
              Icon(Icons.sports_soccer_outlined, size: 48, color: Colors.white38),
              SizedBox(height: 12),
              Text(
                'No Matches Found',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(16),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Try expanding your radius slider or host your own match!',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.white54,
                  fontSize: ResponsiveHelper.sp(13),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const HostMatchScreen()),
                  );
                },
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Host a Match Now', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20)),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: games.length,
        itemBuilder: (_, i) => GameCard(data: games[i]),
      );
    });
  }
}

class GameCard extends StatelessWidget {
  final GameData data;
  const GameCard({super.key, required this.data});

  Color _typeBgColor(String type) {
    switch (type.toLowerCase()) {
      case 'casual':
        return AppColors.accent.withValues(alpha: 0.15);
      case 'competitive':
        return const Color(0xFF7C3AED).withValues(alpha: 0.2);
      case 'tournament':
        return const Color(0xFFEA580C).withValues(alpha: 0.2);
      default:
        return Colors.white.withValues(alpha: 0.08);
    }
  }

  Color _typeTextColor(String type) {
    switch (type.toLowerCase()) {
      case 'casual':
        return AppColors.accent;
      case 'competitive':
        return const Color(0xFFA855F7);
      case 'tournament':
        return const Color(0xFFFB923C);
      default:
        return Colors.white70;
    }
  }

  Color _typeBorderColor(String type) {
    switch (type.toLowerCase()) {
      case 'casual':
        return AppColors.accent.withValues(alpha: 0.3);
      case 'competitive':
        return const Color(0xFF7C3AED).withValues(alpha: 0.4);
      case 'tournament':
        return const Color(0xFFEA580C).withValues(alpha: 0.4);
      default:
        return Colors.transparent;
    }
  }

  String _shortName(String name) {
    final parts = name.trim().split(' ');
    if (parts.length < 2) return name;
    return '${parts.first} ${parts.last[0]}.';
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final progress = (data.currentPlayers / (data.maxPlayers > 0 ? data.maxPlayers : 1)).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MatchDetailScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(ResponsiveHelper.w(16)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
          color: AppColors.surface,
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// SECTION 1: TAGS & PRICE
            Row(
              children: [
                _Tag(
                  data.type.toUpperCase(),
                  bgColor: _typeBgColor(data.type),
                  textColor: _typeTextColor(data.type),
                  borderColor: _typeBorderColor(data.type),
                ),
                SizedBox(width: 8),
                _Tag(
                  data.sport.toUpperCase(),
                  bgColor: Colors.white.withValues(alpha: 0.08),
                  textColor: Colors.white70,
                ),
                if (data.locationType == 'playz_turf') ...[
                  SizedBox(width: 8),
                  _Tag(
                    'VERIFIED TURF',
                    bgColor: const Color(0xFF059669).withValues(alpha: 0.2),
                    textColor: const Color(0xFF34D399),
                    borderColor: const Color(0xFF059669).withValues(alpha: 0.4),
                  ),
                ],
                const Spacer(),
                Text(
                  data.price,
                  style: GoogleFonts.inter(
                    color: AppColors.accent,
                    fontSize: ResponsiveHelper.sp(18),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            /// SECTION 2: HOST INFO (WITH DYNAMIC XP RING) & PLAYER COUNT
            Row(
              children: [
                /// DYNAMIC XP RING AVATAR
                XpAvatarRing(
                  imageUrl: data.avatarUrl,
                  xp: data.hostXp,
                  radius: 22,
                ),
                SizedBox(width: 12),

                /// Name and Time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _shortName(data.hostName),
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.sp(15),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: Colors.white54,
                            size: 13,
                          ),
                          SizedBox(width: 4),
                          Text(
                            data.time,
                            style: GoogleFonts.inter(
                              color: Colors.white54,
                              fontSize: ResponsiveHelper.sp(12.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /// Player Count Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(12),
                    vertical: ResponsiveHelper.h(6),
                  ),
                  decoration: BoxDecoration(
                    color: data.isFull
                        ? const Color(0xFF450A0A)
                        : AppColors.accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
                    border: Border.all(
                      color: data.isFull
                          ? Colors.redAccent.withValues(alpha: 0.4)
                          : AppColors.accent.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.group,
                        color: data.isFull ? Colors.redAccent : AppColors.accent,
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${data.currentPlayers}/${data.maxPlayers}',
                        style: GoogleFonts.inter(
                          color: data.isFull ? Colors.redAccent : AppColors.accent,
                          fontSize: ResponsiveHelper.sp(13),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            /// SECTION 3: PROGRESS BAR
            Stack(
              children: [
                Container(
                  height: ResponsiveHelper.h(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(3)),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    height: ResponsiveHelper.h(6),
                    decoration: BoxDecoration(
                      color: data.isFull ? Colors.redAccent : AppColors.accent,
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(3)),
                      boxShadow: [
                        BoxShadow(
                          color: (data.isFull ? Colors.redAccent : AppColors.accent).withValues(alpha: 0.4),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            /// SECTION 4: LOCATION & DISTANCE
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: AppColors.accent.withValues(alpha: 0.8),
                  size: 15,
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    data.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: ResponsiveHelper.sp(12),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  data.distance,
                  style: GoogleFonts.inter(
                    color: AppColors.muted,
                    fontSize: ResponsiveHelper.sp(12),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Color textColor;
  final Color? borderColor;

  const _Tag(
    this.text, {
    required this.bgColor,
    required this.textColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(10),
        vertical: ResponsiveHelper.h(4),
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
        border: borderColor != null ? Border.all(color: borderColor!) : null,
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: textColor,
          fontSize: ResponsiveHelper.sp(10.5),
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
