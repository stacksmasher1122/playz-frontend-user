import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Booking_Controller/booking_controller.dart';
import 'package:redesign/model/User_Models/Booking_Models/turf_model.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/view/USER/Book/turf_details/turf_details_screen.dart';
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

    final userIdsToQuery = <String>{};
    if (prefDocId != null && prefDocId.isNotEmpty) userIdsToQuery.add(prefDocId);
    if (user?.email != null && user!.email!.isNotEmpty) userIdsToQuery.add(user.email!);
    if (user?.uid != null && user!.uid.isNotEmpty) userIdsToQuery.add(user.uid);

    List<Map<String, dynamic>> list = [];
    Set<String> seenVenues = {};

    final bookingCtrl = Get.isRegistered<BookingController>()
        ? Get.find<BookingController>()
        : Get.put(BookingController());

    if (bookingCtrl.allTurfs.isEmpty) {
      await bookingCtrl.fetchAllTurfs();
    }

    for (var uId in userIdsToQuery) {
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('User')
            .doc(uId)
            .collection('bookings')
            .orderBy('createdAt', descending: true)
            .limit(10)
            .get();

        for (var doc in snapshot.docs) {
          final data = doc.data();
          final turfId = (data['turfId'] ?? '').toString();
          final ownerId = (data['ownerId'] ?? '').toString();
          final name = (data['turfName'] ?? data['venueName'] ?? data['title'] ?? '')
              .toString()
              .trim();

          if (name.isNotEmpty && !seenVenues.contains(name)) {
            seenVenues.add(name);

            // Find matching TurfModel from allTurfs
            TurfModel? matchedTurf;
            if (turfId.isNotEmpty) {
              matchedTurf = bookingCtrl.allTurfs.firstWhereOrNull((t) => t.id == turfId);
            }
            if (matchedTurf == null && name.isNotEmpty) {
              matchedTurf = bookingCtrl.allTurfs.firstWhereOrNull(
                  (t) => t.turfName.toLowerCase() == name.toLowerCase());
            }

            // Fetch from Firestore if not found in memory
            if (matchedTurf == null && turfId.isNotEmpty) {
              try {
                DocumentSnapshot? turfDoc;
                if (ownerId.isNotEmpty) {
                  turfDoc = await FirebaseFirestore.instance
                      .collection('owners')
                      .doc(ownerId)
                      .collection('turfs')
                      .doc(turfId)
                      .get();
                } else {
                  final groupSnap = await FirebaseFirestore.instance
                      .collectionGroup('turfs')
                      .where('id', isEqualTo: turfId)
                      .limit(1)
                      .get();
                  if (groupSnap.docs.isNotEmpty) {
                    turfDoc = groupSnap.docs.first;
                  }
                }
                if (turfDoc != null && turfDoc.exists) {
                  matchedTurf = TurfModel.fromFirestore(turfDoc);
                }
              } catch (_) {}
            }

            // Fallback TurfModel if not found anywhere
            matchedTurf ??= TurfModel(
              id: turfId.isNotEmpty ? turfId : 'turf_${doc.id}',
              ownerId: ownerId,
              turfName: name,
              fullAddress: (data['turfAddress'] ?? data['address'] ?? data['location'] ?? 'Indiranagar').toString(),
              city: (data['city'] ?? 'Bengaluru').toString(),
              state: 'Karnataka',
              pincode: '',
              latitude: 0.0,
              longitude: 0.0,
              description: 'Previous booked venue',
              sports: [(data['sport'] ?? 'Football').toString()],
              amenities: [],
              operatingHours: {},
              heroImageUrl: (data['turfImage'] ?? data['imageUrl'] ?? '').toString(),
              imageUrls: [(data['turfImage'] ?? data['imageUrl'] ?? '').toString()],
              status: 'active',
              isVerified: true,
              isPaused: false,
              isDeleted: false,
              rating: double.tryParse((data['rating'] ?? '4.8').toString()) ?? 4.8,
              lowestPrice: double.tryParse((data['amount'] ?? data['totalAmount'] ?? '1200').toString()) ?? 1200.0,
            );

            final address = matchedTurf.fullAddress.isNotEmpty
                ? matchedTurf.fullAddress
                : (data['turfAddress'] ?? data['address'] ?? 'Indiranagar').toString();
            final dateStr = (data['dateFormatted'] ?? data['date'] ?? 'Recently').toString();

            final priceVal = matchedTurf.lowestPrice != null && matchedTurf.lowestPrice! > 0
                ? '₹${matchedTurf.lowestPrice!.toInt()}/hr'
                : (data['amount'] != null ? '₹${data['amount']}/hr' : '₹1200/hr');

            final img = matchedTurf.heroImageUrl.isNotEmpty
                ? matchedTurf.heroImageUrl
                : (matchedTurf.imageUrls.isNotEmpty
                    ? matchedTurf.imageUrls.first
                    : (data['turfImage'] ?? data['imageUrl'] ?? 'https://images.unsplash.com/photo-1546519638-68e109498ffc').toString());

            list.add({
              'turf': matchedTurf,
              'title': matchedTurf.turfName,
              'location': address,
              'price': priceVal,
              'rating': matchedTurf.rating.toStringAsFixed(1),
              'status': 'Booked $dateStr',
              'image': img,
            });
          }
        }
      } catch (e) {
        debugPrint('🔴 Error fetching previous venues for $uId: $e');
      }
    }

    return list;
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
                      turf: venues[i]['turf'] as TurfModel,
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
  final TurfModel turf;
  final String title;
  final String location;
  final String price;
  final String rating;
  final String status;
  final String imageUrl;

  const HomePreviousVenueTile({
    super.key,
    required this.turf,
    required this.title,
    required this.location,
    required this.price,
    required this.rating,
    required this.status,
    required this.imageUrl,
  });

  void _navigateToTurfDetail(BuildContext context) {
    final bookingCtrl = Get.isRegistered<BookingController>()
        ? Get.find<BookingController>()
        : Get.put(BookingController());
    bookingCtrl.setSelectedTurf(turf);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TurfDetailScreen(
          heroTag: 'prev_venue_hero_${turf.id}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final imageSize = context.minDimensionPct(18).clamp(60.0, 80.0);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _navigateToTurfDetail(context),
        borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
        child: Container(
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
                mainAxisAlignment: MainAxisAlignment.center,
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
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: AppColors.muted.withValues(alpha: 0.6),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
