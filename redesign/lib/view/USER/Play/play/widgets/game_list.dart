import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/view/USER/Play/match_detail/match_detail_screen.dart';
import 'package:redesign/controller/User_Controller/Match_Controller/match_controller.dart';
import 'package:redesign/controller/maps_controller.dart';
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
          padding: EdgeInsets.all(context.widthPct(8)),
          child: const Center(
            child: CircularProgressIndicator(color: AppColors.accent),
          ),
        );
      }

      final games = matchCtrl.filteredMatches;

      if (games.isEmpty) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.widthPct(5),
            vertical: context.heightPct(4),
          ),
          child: Column(
            children: [
              const Icon(Icons.sports_soccer_outlined, size: 48, color: AppColors.muted),
              SizedBox(height: context.heightPct(1.5)),
              Text(
                'No Matches Found',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(16),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: context.heightPct(0.8)),
              Text(
                'Try expanding your radius slider or host your own match!',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: context.responsiveFont(13),
                ),
              ),
              SizedBox(height: context.heightPct(2)),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const HostMatchScreen()),
                  );
                },
                icon: const Icon(Icons.add_circle_outline),
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Host a Match Now',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.background,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: context.widthPct(5)),
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
        return AppColors.card;
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
        return AppColors.textSecondary;
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

  String _getCalculatedDistance() {
    if (Get.isRegistered<MapsController>()) {
      final mapsCtrl = Get.find<MapsController>();
      final userLoc = mapsCtrl.currentLocation.value;
      if (userLoc != null && data.latitude != 0.0 && data.longitude != 0.0) {
        final distM = Geolocator.distanceBetween(
          userLoc.lat,
          userLoc.lng,
          data.latitude,
          data.longitude,
        );
        final km = distM / 1000.0;
        return '${km.toStringAsFixed(1)} km away';
      }
    }
    return data.distance.contains('away') ? data.distance : '${data.distance} away';
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final progress = (data.currentPlayers / (data.maxPlayers > 0 ? data.maxPlayers : 1)).clamp(0.0, 1.0);
    final calculatedDistance = _getCalculatedDistance();
    final avatarRadius = context.minDimensionPct(5.5).clamp(18.0, 24.0);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MatchDetailScreen(gameData: data),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: context.heightPct(2)),
        padding: EdgeInsets.all(context.widthPct(4)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
          color: AppColors.surface,
          border: Border.all(color: AppColors.borderDark),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: context.widthPct(1.5),
                    runSpacing: context.heightPct(0.5),
                    children: [
                      if (data.locationType == 'playz_turf')
                        const Tooltip(
                          message: 'Verified PlayZ Turf',
                          child: Padding(
                            padding: EdgeInsets.only(right: 2),
                            child: Icon(
                              Icons.verified_rounded,
                              color: Color(0xFF34D399),
                              size: 20,
                            ),
                          ),
                        )
                      else
                        const Tooltip(
                          message: 'Unofficial / Custom Location Ground',
                          child: Padding(
                            padding: EdgeInsets.only(right: 2),
                            child: Icon(
                              Icons.edit_location_alt_rounded,
                              color: AppColors.textSecondary,
                              size: 19,
                            ),
                          ),
                        ),
                      _Tag(
                        data.type.toUpperCase(),
                        bgColor: _typeBgColor(data.type),
                        textColor: _typeTextColor(data.type),
                        borderColor: _typeBorderColor(data.type),
                      ),
                      _Tag(
                        data.sport.toUpperCase(),
                        bgColor: AppColors.card,
                        textColor: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: context.widthPct(2)),
                Text(
                  data.price,
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.accent,
                    fontSize: context.responsiveFont(18),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.heightPct(1.8)),

            /// SECTION 2: HOST INFO & PLAYER COUNT
            Row(
              children: [
                /// DYNAMIC XP RING AVATAR
                XpAvatarRing(
                  imageUrl: data.avatarUrl,
                  xp: data.hostXp,
                  radius: avatarRadius,
                ),
                SizedBox(width: context.widthPct(3)),

                /// Name and Time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _shortName(data.hostName),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: context.responsiveFont(15),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: context.heightPct(0.3)),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: AppColors.textSecondary,
                            size: 13,
                          ),
                          SizedBox(width: context.widthPct(1)),
                          Expanded(
                            child: Text(
                              data.time,
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: context.responsiveFont(12.5),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
                    horizontal: context.widthPct(3),
                    vertical: context.heightPct(0.6),
                  ),
                  decoration: BoxDecoration(
                    color: data.isFull
                        ? AppColors.error.withValues(alpha: 0.15)
                        : AppColors.accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                    border: Border.all(
                      color: data.isFull
                          ? AppColors.error.withValues(alpha: 0.4)
                          : AppColors.accent.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.group,
                        color: data.isFull ? AppColors.error : AppColors.accent,
                        size: 14,
                      ),
                      SizedBox(width: context.widthPct(1)),
                      Text(
                        '${data.currentPlayers}/${data.maxPlayers}',
                        style: AppTypography.bodySm.copyWith(
                          color: data.isFull ? AppColors.error : AppColors.accent,
                          fontSize: context.responsiveFont(13),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: context.heightPct(1.8)),

            /// SECTION 3: PROGRESS BAR
            Stack(
              children: [
                Container(
                  height: context.heightPct(0.7).clamp(4.0, 8.0),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    height: context.heightPct(0.7).clamp(4.0, 8.0),
                    decoration: BoxDecoration(
                      color: data.isFull ? AppColors.error : AppColors.accent,
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [
                        BoxShadow(
                          color: (data.isFull ? AppColors.error : AppColors.accent).withValues(alpha: 0.4),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.heightPct(1.8)),

            /// SECTION 4: LOCATION & CALCULATED DISTANCE
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: AppColors.accent.withValues(alpha: 0.8),
                  size: 15,
                ),
                SizedBox(width: context.widthPct(1)),
                Expanded(
                  child: Text(
                    data.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: context.responsiveFont(12),
                    ),
                  ),
                ),
                SizedBox(width: context.widthPct(2)),
                Text(
                  calculatedDistance,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(12),
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
        horizontal: context.widthPct(2.5),
        vertical: context.heightPct(0.4),
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(context.minDimensionPct(2)),
        border: borderColor != null ? Border.all(color: borderColor!) : null,
      ),
      child: Text(
        text,
        style: AppTypography.labelCaps10.copyWith(
          color: textColor,
          fontSize: context.responsiveFont(10.5),
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
