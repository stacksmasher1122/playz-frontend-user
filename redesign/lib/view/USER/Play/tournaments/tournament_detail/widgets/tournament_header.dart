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
      expandedHeight: ResponsiveHelper.h(250),
      pinned: true,
      backgroundColor: AppColors.background,
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
          child: Icon(Icons.arrow_back, color: AppColors.onPrimary, size: 20),
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
                errorWidget: (context, url, error) => Container(color: AppColors.card, child: Icon(Icons.image, color: AppColors.muted)),
              )
            else
              Container(color: AppColors.card, child: Icon(Icons.emoji_events, size: 64, color: AppColors.muted)),

            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.background.withOpacity(0.8),
                    AppColors.background,
                  ],
                ),
              ),
            ),

            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTypography.displaySm.copyWith(color: AppColors.onPrimary, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: AppColors.accent, size: 16),
                      SizedBox(width: 6),
                      Text(dateStr, style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary)),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: AppColors.accent, size: 16),
                      SizedBox(width: 6),
                      Text(venueName, style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary)),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
