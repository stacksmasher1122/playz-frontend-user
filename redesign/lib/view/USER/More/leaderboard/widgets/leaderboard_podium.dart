import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
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
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Rank 2 (Left)
          Expanded(
            child: _PodiumColumn(
              player: rank2,
              podiumHeight: ResponsiveHelper.h(70),
              isFirst: false,
            ),
          ),
          SizedBox(width: ResponsiveHelper.w(10)),

          // Rank 1 (Center - Elevated)
          Expanded(
            child: _PodiumColumn(
              player: rank1,
              podiumHeight: ResponsiveHelper.h(100),
              isFirst: true,
            ),
          ),
          SizedBox(width: ResponsiveHelper.w(10)),

          // Rank 3 (Right)
          Expanded(
            child: _PodiumColumn(
              player: rank3,
              podiumHeight: ResponsiveHelper.h(50),
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
                radius: isFirst ? ResponsiveHelper.w(34) : ResponsiveHelper.w(28),
                backgroundColor: const Color(0xFF222222),
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
                    style: GoogleFonts.inter(
                      color: isFirst ? Colors.black : Colors.white,
                      fontSize: ResponsiveHelper.sp(isFirst ? 11 : 9),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: ResponsiveHelper.h(12)),

        // Name
        Text(
          player.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: ResponsiveHelper.sp(isFirst ? 14 : 12),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 2),

        // Points
        Text(
          '${player.points.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} pts',
          style: GoogleFonts.inter(
            color: AppColors.accent,
            fontSize: ResponsiveHelper.sp(isFirst ? 12 : 10),
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: ResponsiveHelper.h(10)),

        // Dark Gray Rounded Pedestal Block
        Container(
          width: double.infinity,
          height: podiumHeight,
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ],
    );
  }
}
