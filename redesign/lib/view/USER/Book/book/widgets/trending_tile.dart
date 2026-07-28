import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Booking_Controller/booking_controller.dart';
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
    final imageHeight = context.heightPct(11).clamp(90.0, 115.0);

    return GestureDetector(
      onTap: () {
        final bookingCtrl = Get.find<BookingController>();
        bookingCtrl.setSelectedTurf(turf);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => TurfDetailScreen()),
        );
      },
      child: SizedBox(
        width: tileWidth,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
            border: Border.all(color: AppColors.borderDark, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// IMAGE WITH CACHE + SHIMMER
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(context.minDimensionPct(4)),
                ),
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

              Padding(
                padding: EdgeInsets.all(context.widthPct(2.5)),
                child: Column(
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
                    SizedBox(height: context.heightPct(0.4)),
                    Text(
                      turf.displayLocation,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: context.responsiveFont(11),
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
