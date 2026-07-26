import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/controller/User_Controller/Booking_Controller/booking_controller.dart';
import 'package:redesign/model/User_Models/Booking_Models/turf_model.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/view/USER/Book/turf_details/turf_details_screen.dart';
import 'trending_image_shimmer.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TrendingTile extends StatelessWidget {
  final TurfModel turf;
  TrendingTile({super.key, required this.turf});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final heroImage = turf.heroImageUrl.isNotEmpty
        ? turf.heroImageUrl
        : (turf.imageUrls.isNotEmpty ? turf.imageUrls.first : '');

    return GestureDetector(
      onTap: () {
        final bookingCtrl = Get.find<BookingController>();
        bookingCtrl.setSelectedTurf(turf);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => TurfDetailScreen()),
        );
      },
      child: SizedBox(
        width: ResponsiveHelper.w(150),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ✅ IMAGE WITH CACHE + SHIMMER
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(ResponsiveHelper.w(16)),
                ),
                child: heroImage.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: heroImage,
                        cacheKey: heroImage,
                        height: ResponsiveHelper.h(100),
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => TrendingImageShimmer(),
                        errorWidget: (_, __, ___) => Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.white54,
                            size: 28,
                          ),
                        ),
                      )
                    : Container(
                        height: ResponsiveHelper.h(100),
                        color: Colors.grey.shade900,
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.white38,
                          ),
                        ),
                      ),
              ),

              Padding(
                padding: EdgeInsets.all(ResponsiveHelper.w(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      turf.turfName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      turf.displayLocation,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: AppColors.muted,
                        fontSize: ResponsiveHelper.sp(12),
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
