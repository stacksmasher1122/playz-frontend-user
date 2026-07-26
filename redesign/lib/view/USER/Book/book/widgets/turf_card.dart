import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/controller/User_Controller/Booking_Controller/booking_controller.dart';
import 'package:redesign/model/User_Models/Booking_Models/turf_model.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_dimensions.dart';
import 'package:redesign/view/USER/Book/turf_details/turf_details_screen.dart';
import 'image_shimmer.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TurfCard extends StatefulWidget {
  final TurfModel turf;
  TurfCard({super.key, required this.turf});

  @override
  State<TurfCard> createState() => _TurfCardState();
}

class _TurfCardState extends State<TurfCard>
    with AutomaticKeepAliveClientMixin {
  int _pageIndex = 0;
  bool _isFavorite = false;

  IconData _getAmenityIcon(String amenity) {
    switch (amenity.toLowerCase()) {
      case 'basketball':
        return Icons.sports_basketball;
      case 'parking':
        return Icons.local_parking;
      case 'shower':
      case 'washroom':
        return Icons.shower;
      case 'ac':
      case 'air conditioning':
        return Icons.ac_unit;
      case 'football':
      case 'soccer':
        return Icons.sports_soccer;
      case 'cricket':
        return Icons.sports_cricket;
      case 'lighting':
        return Icons.lightbulb;
      case 'wifi':
      case 'free wifi':
        return Icons.wifi;
      case 'drinking water':
        return Icons.water_drop;
      case 'change room':
        return Icons.meeting_room;
      case 'equipment':
        return Icons.fitness_center;
      case 'trainers':
        return Icons.people;
      default:
        return Icons.sports;
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    super.build(context);

    final turf = widget.turf;
    final images = turf.allImages;
    final width = MediaQuery.of(context).size.width;
    final imageHeight = width * 0.48;
    final displayPrice = turf.lowestPrice?.toInt() ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE PAGE VIEW (CACHED + SHIMMER)
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(18))),
            child: Stack(
              children: [
                SizedBox(
                  height: imageHeight,
                  child: images.isNotEmpty
                      ? PageView.builder(
                          itemCount: images.length,
                          onPageChanged: (i) => setState(() => _pageIndex = i),
                          itemBuilder: (_, i) => CachedNetworkImage(
                            imageUrl: images[i],
                            cacheKey: images[i],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            placeholder: (_, __) =>
                                ImageShimmer(height: imageHeight),
                            errorWidget: (_, __, ___) => Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.white54,
                                size: 32,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.grey.shade900,
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.white38,
                              size: 40,
                            ),
                          ),
                        ),
                ),

                /// PAGE INDICATOR
                if (images.length > 1)
                  Positioned(
                    bottom: ResponsiveHelper.h(10),
                    left: ResponsiveHelper.w(0),
                    right: ResponsiveHelper.w(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        images.length,
                        (i) => Container(
                          margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(3)),
                          width: ResponsiveHelper.w(6),
                          height: ResponsiveHelper.h(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i == _pageIndex
                                ? Colors.white
                                : Colors.white38,
                          ),
                        ),
                      ),
                    ),
                  ),

                /// FAVORITE BUTTON
                Positioned(
                  top: ResponsiveHelper.h(12),
                  right: ResponsiveHelper.w(12),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                    },
                    child: Container(
                      width: ResponsiveHelper.w(34),
                      height: ResponsiveHelper.w(34),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? AppColors.accent : Colors.white,
                        size: ResponsiveHelper.w(18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// DETAILS
          Padding(
            padding: EdgeInsets.all(ResponsiveHelper.w(14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔥 NAVIGABLE CONTENT ONLY
                InkWell(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                  onTap: () {
                    // Set selected turf in controller before navigating
                    final bookingCtrl = Get.find<BookingController>();
                    bookingCtrl.setSelectedTurf(turf);

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TurfDetailScreen(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: ResponsiveHelper.h(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          turf.turfName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: AppColors.accent,
                            fontSize: ResponsiveHelper.sp(16),
                            fontWeight: FontWeight.w700,
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
                        SizedBox(height: 8),

                        /// Sports tags
                        if (turf.sports.isNotEmpty)
                          Row(
                            children: [
                              ...turf.sports.take(3).map((sport) => Padding(
                                padding: EdgeInsets.only(right: 6),
                                child: Text(
                                  sport,
                                  style: GoogleFonts.inter(
                                    fontSize: ResponsiveHelper.sp(12),
                                    color: AppColors.muted,
                                  ),
                                ),
                              )),
                              if (turf.sports.length > 3)
                                Text(
                                  '+${turf.sports.length - 3} more',
                                  style: GoogleFonts.inter(
                                    fontSize: ResponsiveHelper.sp(12),
                                    color: AppColors.accent,
                                  ),
                                ),
                            ],
                          ),

                        /// AMENITY TAGS ROW
                        if (turf.amenities.isNotEmpty) ...[
                          SizedBox(height: ResponsiveHelper.h(10)),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: turf.amenities.map((amenity) {
                                return Container(
                                  margin: EdgeInsets.only(right: ResponsiveHelper.w(8)),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ResponsiveHelper.w(10),
                                    vertical: ResponsiveHelper.h(6),
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.card,
                                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(AppDimensions.radiusMd)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _getAmenityIcon(amenity),
                                        size: ResponsiveHelper.sp(13),
                                        color: Colors.white70,
                                      ),
                                      SizedBox(width: ResponsiveHelper.w(4)),
                                      Text(
                                        amenity,
                                        style: GoogleFonts.inter(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: ResponsiveHelper.sp(11),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                /// HORIZONTAL DIVIDER LINE
                Divider(
                  color: Colors.white.withOpacity(0.08),
                  thickness: 1,
                  height: 1,
                ),
                SizedBox(height: ResponsiveHelper.h(12)),

                /// 🔥 PRICE + BOOK (NOT NAVIGABLE)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              style: GoogleFonts.inter(
                                fontSize: ResponsiveHelper.sp(13),
                                color: AppColors.muted,
                              ),
                              children: [
                                TextSpan(text: 'Starts from '),
                                TextSpan(
                                  text: displayPrice > 0
                                      ? '₹$displayPrice'
                                      : '₹--',
                                  style: TextStyle(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.w700,
                                    fontSize: ResponsiveHelper.sp(18),
                                  ),
                                ),
                                TextSpan(text: '/hr'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        final bookingCtrl = Get.find<BookingController>();
                        bookingCtrl.setSelectedTurf(turf);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => TurfDetailScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
                        ),
                      ),
                      child: Text('Book'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
