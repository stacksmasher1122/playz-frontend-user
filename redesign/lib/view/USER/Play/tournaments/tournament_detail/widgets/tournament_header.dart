import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TournamentHeader extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onBack;

  const TournamentHeader({super.key, required this.data, required this.onBack});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final String coverUrl = data['coverImageUrl'] ?? '';
    final String name = data['name'] ?? 'Tournament';
    final String venueName = data['venue']?['name'] ?? 'TBD';

    final Timestamp? start = data['startDate'];
    final Timestamp? end = data['endDate'];
    String dateStr = "TBD";
    if (start != null && end != null) {
      final formatter = DateFormat('MMM d, yyyy');
      dateStr = "${formatter.format(start.toDate())} - ${formatter.format(end.toDate())}";
    }

    return SliverAppBar(
      expandedHeight: context.heightPct(30).clamp(220.0, 280.0),
      pinned: true,
      backgroundColor: AppColors.background,
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(context.widthPct(2)),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.6),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 18),
        ),
        onPressed: onBack,
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (coverUrl.isNotEmpty)
              CachedNetworkImage(
                imageUrl: coverUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: AppColors.card),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.card,
                  child: const Icon(Icons.image, color: AppColors.muted),
                ),
              )
            else
              Container(
                color: AppColors.card,
                child: const Icon(Icons.emoji_events_rounded, size: 64, color: AppColors.muted),
              ),

            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.background.withValues(alpha: 0.8),
                    AppColors.background,
                  ],
                ),
              ),
            ),

            Positioned(
              bottom: context.heightPct(2),
              left: context.widthPct(4),
              right: context.widthPct(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTypography.displayLg.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: context.responsiveFont(22),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: context.heightPct(1)),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, color: AppColors.accent, size: 16),
                      SizedBox(width: context.widthPct(1.5)),
                      Expanded(
                        child: Text(
                          dateStr,
                          style: AppTypography.bodyMd.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: context.responsiveFont(13),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.heightPct(0.5)),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, color: AppColors.accent, size: 16),
                      SizedBox(width: context.widthPct(1.5)),
                      Expanded(
                        child: Text(
                          venueName,
                          style: AppTypography.bodyMd.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: context.responsiveFont(13),
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
          ],
        ),
      ),
    );
  }
}
