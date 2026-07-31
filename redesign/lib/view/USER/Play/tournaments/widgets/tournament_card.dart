import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

import '../tournament_detail/tournament_detail_screen.dart';

class TournamentCard extends StatelessWidget {
  final String tournamentId;
  final Map<String, dynamic> data;
  final String currentUserId;

  const TournamentCard({
    super.key,
    required this.tournamentId,
    required this.data,
    required this.currentUserId,
  });

  String _getCoverImage(Map<String, dynamic> data) {
    for (final key in ['coverImage', 'coverImageUrl', 'imageUrl', 'image', 'bannerUrl', 'thumbnailUrl']) {
      final val = data[key];
      if (val is String && val.trim().isNotEmpty) return val.trim();
    }
    final sportLower = (data['sport'] ?? '').toString().toLowerCase();
    if (sportLower.contains('cricket')) {
      return 'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e';
    } else if (sportLower.contains('football') || sportLower.contains('futsal')) {
      return 'https://images.unsplash.com/photo-1517927033932-b3d18e61fb3a';
    } else if (sportLower.contains('badminton')) {
      return 'https://images.unsplash.com/photo-1626248801379-51a0748a5f96';
    } else if (sportLower.contains('basketball')) {
      return 'https://images.unsplash.com/photo-1546519638-68e109498ffc';
    }
    return 'https://images.unsplash.com/photo-1511886929837-354d827aae26';
  }

  Widget _buildSpotifyStatusPill(
    BuildContext context,
    String status,
    bool isCompleted,
    bool isInProgress,
    Timestamp? start,
  ) {
    Color bgColor;
    Color textColor;
    String text;
    IconData icon;

    if (isCompleted) {
      bgColor = const Color(0xFF1DB954); // Spotify Green
      textColor = Colors.black;
      text = "COMPLETED";
      icon = Icons.check_circle_rounded;
    } else if (isInProgress) {
      bgColor = const Color(0xFFFF3B30); // Spotify Live Red
      textColor = Colors.white;
      text = "LIVE NOW";
      icon = Icons.fiber_manual_record_rounded;
    } else if (start != null && DateTime.now().isAfter(start.toDate())) {
      bgColor = const Color(0xFF282828); // Spotify Dark Slate
      textColor = Colors.white70;
      text = "CLOSED";
      icon = Icons.lock_rounded;
    } else {
      bgColor = const Color(0xFF1DB954); // Spotify Green
      textColor = Colors.black;
      text = "REG. OPEN";
      icon = Icons.bolt_rounded;
    }

    return Container(
      margin: EdgeInsets.only(right: context.widthPct(1.5)),
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(2.8),
        vertical: context.heightPct(0.5),
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20), // Spotify Pill Shape
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 12),
          SizedBox(width: context.widthPct(1.2)),
          Text(
            text,
            style: AppTypography.labelCaps10.copyWith(
              color: textColor,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.6,
              fontSize: context.responsiveFont(10),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final String name = data['name'] ?? data['tournamentName'] ?? 'Tournament';
    final String sport = data['sport'] ?? 'Sport';
    final Timestamp? start = data['startDate'];
    final Timestamp? end = data['endDate'];
    final String venueName = data['venue']?['name'] ?? data['address'] ?? data['locality'] ?? 'TBD';
    final Map<String, dynamic>? entryFee = data['entryFee'];
    final bool isFree = entryFee?['isFree'] ?? (data['isFree'] ?? true);
    final num? amount = entryFee?['amount'] ?? data['entryFeeAmount'];
    final int teamCount = data['teamCount'] ?? 0;
    final int maxTeams = (data['format']?['maxTeams'] as num?)?.toInt() ??
        (data['format']?['participantCount'] as num?)?.toInt() ??
        (data['format']?['totalTeams'] as num?)?.toInt() ??
        0;
    final String status = (data['status'] ?? '').toString();

    String dateStr = "TBD";
    if (start != null && end != null) {
      final formatter = DateFormat('MMM d');
      dateStr = "${formatter.format(start.toDate())} - ${formatter.format(end.toDate())}";
    } else if (start != null) {
      final formatter = DateFormat('MMM d');
      dateStr = formatter.format(start.toDate());
    }

    String feeStr = isFree ? "Free Entry" : "₹$amount";

    final bool isCompleted = status == 'completed';
    final bool isInProgress = status == 'in_progress';
    final coverImage = _getCoverImage(data);

    return GestureDetector(
      onTap: () {
        Get.to(() => TournamentDetailScreen(
          tournamentId: tournamentId,
          data: data,
          currentUserId: currentUserId,
        ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: context.heightPct(2)),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
          border: Border.all(
            color: isCompleted
                ? const Color(0xFF1DB954).withValues(alpha: 0.6)
                : (isInProgress ? const Color(0xFFFF3B30).withValues(alpha: 0.6) : AppColors.borderDark),
            width: isCompleted || isInProgress ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Tournament Image Banner Header ──
              SizedBox(
                height: context.heightPct(15).clamp(110.0, 145.0),
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: coverImage,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        color: AppColors.surface,
                        child: const Center(
                          child: CircularProgressIndicator(color: AppColors.accent, strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.surface,
                        child: const Icon(Icons.emoji_events_outlined, color: AppColors.muted, size: 36),
                      ),
                    ),

                    // Dark Gradient Overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.0, 0.4, 1.0],
                          colors: [
                            Colors.black.withValues(alpha: 0.4),
                            Colors.black.withValues(alpha: 0.25),
                            Colors.black.withValues(alpha: 0.8),
                          ],
                        ),
                      ),
                    ),

                    // Top Row: Sport Badge & Status / Fee Badges (Spotify Pill Style)
                    Positioned(
                      top: 10,
                      left: 10,
                      right: 10,
                      child: Row(
                        children: [
                          // Sport Pill
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.widthPct(2.8),
                              vertical: context.heightPct(0.5),
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF121212).withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white24, width: 0.8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.4),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.emoji_events_rounded, color: Color(0xFF1DB954), size: 13),
                                SizedBox(width: context.widthPct(1.2)),
                                Text(
                                  sport.toUpperCase(),
                                  style: AppTypography.bodySm.copyWith(
                                    color: Colors.white,
                                    fontSize: context.responsiveFont(10.5),
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),

                          // Spotify Status Pill
                          _buildSpotifyStatusPill(context, status, isCompleted, isInProgress, start),

                          // Entry Fee Pill
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.widthPct(2.8),
                              vertical: context.heightPct(0.5),
                            ),
                            decoration: BoxDecoration(
                              color: isFree ? const Color(0xFF1DB954) : const Color(0xFF121212).withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(20),
                              border: isFree ? null : Border.all(color: Colors.white24, width: 0.8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.4),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              feeStr.toUpperCase(),
                              style: AppTypography.labelCaps10.copyWith(
                                color: isFree ? Colors.black : Colors.white,
                                fontSize: context.responsiveFont(10.5),
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bottom Image Overlay: Tournament Title
                    Positioned(
                      bottom: 10,
                      left: 12,
                      right: 12,
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: context.responsiveFont(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Details Footer ──
              Padding(
                padding: EdgeInsets.all(context.widthPct(3.5)),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_month_rounded, color: AppColors.accent, size: 14),
                              SizedBox(width: context.widthPct(1.5)),
                              Expanded(
                                child: Text(
                                  dateStr,
                                  style: AppTypography.bodySm.copyWith(
                                    color: AppColors.textPrimary,
                                    fontSize: context.responsiveFont(12),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: context.heightPct(0.6)),
                          Row(
                            children: [
                              const Icon(Icons.location_on_rounded, color: AppColors.muted, size: 14),
                              SizedBox(width: context.widthPct(1.5)),
                              Expanded(
                                child: Text(
                                  venueName,
                                  style: AppTypography.bodySm.copyWith(
                                    color: AppColors.muted,
                                    fontSize: context.responsiveFont(12),
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
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.widthPct(3),
                        vertical: context.heightPct(0.8),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.groups_rounded, color: AppColors.accent, size: 16),
                          SizedBox(width: context.widthPct(1.5)),
                          Text(
                            maxTeams > 0 ? "$teamCount/$maxTeams" : "$teamCount Teams",
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.bold,
                              fontSize: context.responsiveFont(12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
