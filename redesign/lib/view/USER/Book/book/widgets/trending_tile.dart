import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Booking_Controller/booking_controller.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/model/User_Models/Booking_Models/turf_model.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/view/USER/Book/turf_details/turf_details_screen.dart';
import 'trending_image_shimmer.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TrendingTile extends StatelessWidget {
  final TurfModel turf;
  const TrendingTile({super.key, required this.turf});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final heroImage = turf.heroImageUrl.isNotEmpty
        ? turf.heroImageUrl
        : (turf.imageUrls.isNotEmpty ? turf.imageUrls.first : '');
    final tileWidth = context.widthPct(38).clamp(140.0, 170.0);
    final imageHeight = context.heightPct(10.5).clamp(85.0, 105.0);

    final mapsCtrl = Get.isRegistered<MapsController>() ? Get.find<MapsController>() : null;
    final userLoc = mapsCtrl?.currentLocation.value;
    final distanceStr = turf.getFormattedDistance(userLoc?.lat, userLoc?.lng);

    return GestureDetector(
      onTap: () {
        final bookingCtrl = Get.find<BookingController>();
        bookingCtrl.setSelectedTurf(turf);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TurfDetailScreen(heroTag: 'trending_turf_hero_${turf.id}'),
          ),
        );
      },
      child: SizedBox(
        width: tileWidth,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// IMAGE WITH CACHE + SHIMMER
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(context.minDimensionPct(4)),
                ),
                child: Hero(
                  tag: 'trending_turf_hero_${turf.id}',
                  transitionOnUserGestures: true,
                  child: Material(
                    color: Colors.transparent,
                    child: heroImage.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: heroImage,
                            cacheKey: heroImage,
                            height: imageHeight,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => const TrendingImageShimmer(),
                            errorWidget: (_, __, ___) => const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: AppColors.muted,
                                size: 28,
                              ),
                            ),
                          )
                        : Container(
                            height: imageHeight,
                            color: AppColors.card,
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: AppColors.muted,
                              ),
                            ),
                          ),
                  ),
                ),
              ),

              /// DETAILS
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.widthPct(2.5),
                    vertical: context.heightPct(0.8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        turf.turfName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: context.responsiveFont(13),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        turf.displayLocation,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: context.responsiveFont(11),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: context.responsiveFont(13),
                            color: Colors.amber,
                          ),
                          SizedBox(width: context.widthPct(0.8)),
                          Expanded(
                            child: Text(
                              '${turf.rating.toStringAsFixed(1)} • $distanceStr',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: context.responsiveFont(11),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
