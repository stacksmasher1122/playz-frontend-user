import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Booking_Controller/booking_controller.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/model/User_Models/Booking_Models/turf_model.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:shimmer/shimmer.dart';
import '../turf_details_screen.dart';

class RecommendedVenuesList extends StatelessWidget {
  final String currentTurfId;
  final List<String> currentSports;

  const RecommendedVenuesList({
    super.key,
    required this.currentTurfId,
    required this.currentSports,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final cardWidth = context.widthPct(42).clamp(150.0, 190.0);
    final imageHeight = context.heightPct(14).clamp(100.0, 130.0);
    final listHeight = context.heightPct(26).clamp(190.0, 230.0);

    final bookingCtrl = Get.isRegistered<BookingController>()
        ? Get.find<BookingController>()
        : Get.put(BookingController());

    final mapsCtrl = Get.isRegistered<MapsController>() ? Get.find<MapsController>() : null;

    return Obx(() {
      final userLoc = mapsCtrl?.currentLocation.value;
      final allTurfs = bookingCtrl.allTurfs;
      final currentSportsLower = currentSports.map((s) => s.toLowerCase().trim()).toSet();

      // Filter turfs sharing AT LEAST ONE matching sport, excluding current turf
      final List<TurfModel> matchingTurfs = allTurfs.where((t) {
        if (t.id == currentTurfId) return false;
        if (currentSportsLower.isEmpty) return true;
        return t.sports.any((s) => currentSportsLower.contains(s.toLowerCase().trim()));
      }).toList();

      // If less than 2 matching turfs found, append other available turfs to fill recommendations
      if (matchingTurfs.length < 2) {
        final existingIds = matchingTurfs.map((t) => t.id).toSet();
        final otherTurfs = allTurfs.where((t) => t.id != currentTurfId && !existingIds.contains(t.id));
        matchingTurfs.addAll(otherTurfs);
      }

      // Deduplicate matching turfs by ID to prevent Hero tag collisions
      final Map<String, TurfModel> uniqueTurfsMap = {};
      for (final t in matchingTurfs) {
        uniqueTurfsMap[t.id] = t;
      }
      final List<TurfModel> uniqueMatchingTurfs = uniqueTurfsMap.values.toList();

      if (uniqueMatchingTurfs.isEmpty) {
        return const SizedBox.shrink();
      }

      final displayCount = uniqueMatchingTurfs.length > 10 ? 10 : uniqueMatchingTurfs.length;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
            child: Text(
              'You Might Also Like',
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(18),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: context.heightPct(1.2)),
          SizedBox(
            height: listHeight,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
              scrollDirection: Axis.horizontal,
              itemCount: displayCount,
              itemBuilder: (context, index) {
                final turf = uniqueMatchingTurfs[index];
                final distanceStr = turf.getFormattedDistance(userLoc?.lat, userLoc?.lng);
                final displayPrice = turf.lowestPrice?.toInt() ?? 0;
                final heroTag = 'recommended_turf_${turf.id}';

                final firstImage = turf.allImages.firstWhere(
                  (img) => img.trim().isNotEmpty,
                  orElse: () => '',
                );

                return GestureDetector(
                  onTap: () {
                    bookingCtrl.setSelectedTurf(turf);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TurfDetailScreen(
                          heroTag: heroTag,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: cardWidth,
                    margin: EdgeInsets.only(right: context.widthPct(3)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// TURF IMAGE WITH HERO & SHIMMER
                        ClipRRect(
                          borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                          child: firstImage.isNotEmpty
                              ? Hero(
                                  tag: heroTag,
                                  transitionOnUserGestures: true,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: CachedNetworkImage(
                                      imageUrl: firstImage,
                                      height: imageHeight,
                                      width: cardWidth,
                                      fit: BoxFit.cover,
                                      placeholder: (_, __) => Shimmer.fromColors(
                                        baseColor: AppColors.surfaceElevated,
                                        highlightColor: AppColors.borderDark,
                                        child: Container(
                                          height: imageHeight,
                                          width: cardWidth,
                                          color: AppColors.card,
                                        ),
                                      ),
                                      errorWidget: (_, __, ___) => Container(
                                        height: imageHeight,
                                        width: cardWidth,
                                        color: AppColors.card,
                                        child: const Icon(Icons.sports, color: AppColors.muted),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  height: imageHeight,
                                  width: cardWidth,
                                  color: AppColors.card,
                                  child: const Icon(Icons.sports, color: AppColors.muted),
                                ),
                        ),
                        SizedBox(height: context.heightPct(0.8)),

                        /// TURF NAME
                        Text(
                          turf.turfName,
                          style: AppTypography.headlineSm.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: context.responsiveFont(14),
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: context.heightPct(0.3)),

                        /// DISTANCE & PRICE
                        Text(
                          '$distanceStr • ${displayPrice > 0 ? '₹$displayPrice/hr' : '₹--/hr'}',
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.muted,
                            fontSize: context.responsiveFont(12),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
