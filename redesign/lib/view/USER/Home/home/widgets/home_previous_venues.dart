import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'home_section_header.dart';
import 'home_shimmer.dart';

/* ============================================================
   PREVIOUS VENUES (HOMEPAGE)
   ============================================================ */
class HomePreviousVenues extends StatelessWidget {
  const HomePreviousVenues({super.key});

  Future<List<Map<String, dynamic>>> _fetchPreviousVenues() async {
    final user = FirebaseAuth.instance.currentUser;
    final prefDocId = await UserPreferences.getDocId();
    final userId = prefDocId ?? user?.email ?? user?.uid ?? '';

    List<Map<String, dynamic>> list = [];
    Set<String> seenVenues = {};

    if (userId.isNotEmpty) {
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('User')
            .doc(userId)
            .collection('bookings')
            .orderBy('createdAt', descending: true)
            .limit(10)
            .get();

        for (var doc in snapshot.docs) {
          final data = doc.data();
          final name =
              (data['turfName'] ?? data['venueName'] ?? data['title'] ?? '')
                  .toString()
                  .trim();
          if (name.isNotEmpty && !seenVenues.contains(name)) {
            seenVenues.add(name);
            final address =
                data['turfAddress'] ?? data['address'] ?? data['location'] ?? 'Indiranagar';
            final dateStr =
                data['dateFormatted'] ?? data['date'] ?? 'Recently';
            final priceVal = data['totalAmount'] != null
                ? '₹${data['totalAmount']}/hr'
                : (data['price'] ?? '₹1200/hr');

            list.add({
              'title': name,
              'location': '$address • 2.5km',
              'price': priceVal.toString(),
              'rating': (data['rating'] ?? '4.8').toString(),
              'status': 'Booked $dateStr',
              'image': (data['turfImage'] ??
                      data['imageUrl'] ??
                      'https://images.unsplash.com/photo-1546519638-68e109498ffc')
                  .toString(),
            });
          }
        }
      } catch (e) {
        debugPrint('🔴 Error fetching previous venues: $e');
      }
    }

    return list.take(2).toList();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchPreviousVenues(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: context.widthPct(5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeSectionHeader('Previous Venues'),
                SizedBox(height: context.heightPct(1.5)),
                HomeShimmer(
                  width: double.infinity,
                  height: context.heightPct(10),
                  borderRadius: 16,
                ),
                SizedBox(height: context.heightPct(1.2)),
                HomeShimmer(
                  width: double.infinity,
                  height: context.heightPct(10),
                  borderRadius: 16,
                ),
              ],
            ),
          );
        }

        final venues = snapshot.data ?? [];
        if (venues.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: context.widthPct(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeSectionHeader('Previous Venues'),
              SizedBox(height: context.heightPct(1.5)),
              Column(
                children: [
                  for (int i = 0; i < venues.length; i++) ...[
                    if (i > 0) SizedBox(height: context.heightPct(1.2)),
                    HomePreviousVenueTile(
                      title: venues[i]['title'] ?? '',
                      location: venues[i]['location'] ?? '',
                      price: venues[i]['price'] ?? '',
                      rating: venues[i]['rating'] ?? '4.8',
                      status: venues[i]['status'] ?? '',
                      imageUrl: venues[i]['image'] ?? '',
                    ),
                  ],
                ],
              ),
              SizedBox(height: context.heightPct(3)),
            ],
          ),
        );
      },
    );
  }
}

class HomePreviousVenueTile extends StatelessWidget {
  final String title;
  final String location;
  final String price;
  final String rating;
  final String status;
  final String imageUrl;

  const HomePreviousVenueTile({
    super.key,
    required this.title,
    required this.location,
    required this.price,
    required this.rating,
    required this.status,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final imageSize = context.minDimensionPct(18).clamp(60.0, 80.0);

    return Container(
      padding: EdgeInsets.all(context.widthPct(3.5)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
        border: Border.all(color: AppColors.borderDark, width: 1),
      ),
      child: Row(
        children: [
          /// CACHED IMAGE WITH SHIMMER
          ClipRRect(
            borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
            child: CachedNetworkImage(
              imageUrl: imageUrl.isNotEmpty
                  ? imageUrl
                  : 'https://images.unsplash.com/photo-1546519638-68e109498ffc',
              cacheKey: imageUrl.isNotEmpty
                  ? imageUrl
                  : 'https://images.unsplash.com/photo-1546519638-68e109498ffc',
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
              placeholder: (_, __) => HomeShimmer(
                width: imageSize,
                height: imageSize,
                borderRadius: 12,
              ),
              errorWidget: (_, __, ___) =>
                  const Icon(Icons.broken_image, color: AppColors.muted),
            ),
          ),

          SizedBox(width: context.widthPct(3.5)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(14),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: context.heightPct(0.4)),
                Text(
                  location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: context.responsiveFont(12),
                  ),
                ),
                SizedBox(height: context.heightPct(0.6)),
                Text(
                  price,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.accent,
                    fontSize: context.responsiveFont(13),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: context.widthPct(2)),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, size: 14, color: AppColors.warning),
                  const SizedBox(width: 4),
                  Text(
                    rating,
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.heightPct(0.8)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.widthPct(2.5),
                  vertical: context.heightPct(0.4),
                ),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  borderRadius:
                      BorderRadius.circular(context.minDimensionPct(2)),
                ),
                child: Text(
                  'Book Again',
                  style: AppTypography.bodyXs.copyWith(
                    color: AppColors.accent,
                    fontSize: context.responsiveFont(11),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
