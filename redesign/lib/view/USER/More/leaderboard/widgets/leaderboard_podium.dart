import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/model/User_Models/More_Models/leaderboard_model.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_dimensions.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LeaderboardPodium extends StatelessWidget {
  final List<LeaderboardPlayerModel> top3;

  const LeaderboardPodium({super.key, required this.top3});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    if (top3.isEmpty) return const SizedBox.shrink();

    final rank1 = top3.firstWhere((p) => p.rank == 1, orElse: () => top3[0]);
    final rank2 = top3.length > 1
        ? top3.firstWhere((p) => p.rank == 2, orElse: () => top3[1])
        : null;
    final rank3 = top3.length > 2
        ? top3.firstWhere((p) => p.rank == 3, orElse: () => top3[2])
        : null;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Rank 2 (Left)
          Expanded(
            child: rank2 != null
                ? _PodiumColumn(
                    player: rank2,
                    podiumHeight: context.heightPct(9).clamp(60.0, 80.0),
                    isFirst: false,
                  )
                : const SizedBox.shrink(),
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
            child: rank3 != null
                ? _PodiumColumn(
                    player: rank3,
                    podiumHeight: context.heightPct(7).clamp(45.0, 60.0),
                    isFirst: false,
                  )
                : const SizedBox.shrink(),
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
                color: isFirst ? AppColors.accent : AppColors.borderDark,
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
              child: _buildAvatar(player.avatarUrl, avatarRadius),
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
            fontSize: context.responsiveFont(isFirst ? 13 : 12),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: context.heightPct(0.3)),

        // Points (formatted k/m)
        Text(
          '${player.formattedPoints} pts',
          style: AppTypography.bodySm.copyWith(
            color: AppColors.accent,
            fontSize: context.responsiveFont(isFirst ? 12 : 10),
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        SizedBox(height: context.heightPct(1.2)),

        // Pedestal Block
        Container(
          width: double.infinity,
          height: podiumHeight,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          ),
        ),
      ],
    );
  }

  bool _isValidHttpUrl(String? url) {
    if (url == null || url.trim().isEmpty) return false;
    final clean = url.trim();
    if (!clean.startsWith('http://') && !clean.startsWith('https://')) return false;
    try {
      final uri = Uri.parse(clean);
      return uri.host.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Widget _buildAvatar(String url, double radius) {
    if (!_isValidHttpUrl(url)) {
      return _buildGreyProfileAvatarImage(radius);
    }
    return CachedNetworkImage(
      imageUrl: url.trim(),
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: radius,
        backgroundImage: imageProvider,
      ),
      placeholder: (_, __) => _buildGreyProfileAvatarImage(radius),
      errorWidget: (_, __, ___) => _buildGreyProfileAvatarImage(radius),
    );
  }

  Widget _buildGreyProfileAvatarImage(double radius) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: const BoxDecoration(
        color: Color(0xFF2C2C2E),
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: radius * 0.35,
              child: Container(
                width: radius * 0.72,
                height: radius * 0.72,
                decoration: const BoxDecoration(
                  color: Color(0xFF7C7C80),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -radius * 0.15,
              child: Container(
                width: radius * 1.35,
                height: radius * 0.9,
                decoration: const BoxDecoration(
                  color: Color(0xFF7C7C80),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(50),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
