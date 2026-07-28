import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Booking_Controller/booking_controller.dart';
import 'package:redesign/model/User_Models/Booking_Models/turf_model.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_dimensions.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/view/USER/Book/turf_details/turf_details_screen.dart';
import 'image_shimmer.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TurfCard extends StatefulWidget {
  final TurfModel turf;
  const TurfCard({super.key, required this.turf});

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
    final imageHeight = context.widthPct(48).clamp(160.0, 240.0);
    final displayPrice = turf.lowestPrice?.toInt() ?? 0;
    final favoriteBtnSize = context.minDimensionPct(9).clamp(32.0, 40.0);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
        border: Border.all(color: AppColors.borderDark, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE PAGE VIEW (CACHED + SHIMMER)
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(context.minDimensionPct(4)),
            ),
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
                            errorWidget: (_, __, ___) => const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: AppColors.muted,
                                size: 32,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          color: AppColors.card,
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: AppColors.muted,
                              size: 40,
                            ),
                          ),
                        ),
                ),

                /// PAGE INDICATOR
                if (images.length > 1)
                  Positioned(
                    bottom: context.heightPct(1.2),
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        images.length,
                        (i) => Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: context.widthPct(0.8),
                          ),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i == _pageIndex
                                ? AppColors.textPrimary
                                : AppColors.textSecondary.withValues(
                                    alpha: 0.5,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),

                /// FAVORITE BUTTON
                Positioned(
                  top: context.heightPct(1.2),
                  right: context.widthPct(3),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                    },
                    child: Container(
                      width: favoriteBtnSize,
                      height: favoriteBtnSize,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite
                            ? AppColors.accent
                            : AppColors.textPrimary,
                        size: favoriteBtnSize * 0.52,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// DETAILS
          Padding(
            padding: EdgeInsets.all(context.widthPct(3.5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// NAVIGABLE CONTENT ONLY
                InkWell(
                  borderRadius: BorderRadius.circular(
                    context.minDimensionPct(3),
                  ),
                  onTap: () {
                    // Set selected turf in controller before navigating
                    final bookingCtrl = Get.find<BookingController>();
                    bookingCtrl.setSelectedTurf(turf);

                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => TurfDetailScreen()),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: context.heightPct(1.2)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          turf.turfName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.headlineSm.copyWith(
                            color: AppColors.accent,
                            fontSize: context.responsiveFont(16),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: context.heightPct(0.4)),
                        Text(
                          turf.displayLocation,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: context.responsiveFont(12),
                          ),
                        ),
                        SizedBox(height: context.heightPct(0.8)),

                        /// Sports tags
                        if (turf.sports.isNotEmpty)
                          Wrap(
                            spacing: context.widthPct(1.5),
                            runSpacing: context.heightPct(0.4),
                            children: [
                              ...turf.sports
                                  .take(3)
                                  .map(
                                    (sport) => Text(
                                      sport,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypography.bodySm.copyWith(
                                        fontSize: context.responsiveFont(12),
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                              if (turf.sports.length > 3)
                                Text(
                                  '+${turf.sports.length - 3} more',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.bodySm.copyWith(
                                    fontSize: context.responsiveFont(12),
                                    color: AppColors.accent,
                                  ),
                                ),
                            ],
                          ),

                        /// AMENITY TAGS ROW
                        if (turf.amenities.isNotEmpty) ...[
                          SizedBox(height: context.heightPct(1.2)),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: turf.amenities.map((amenity) {
                                return Container(
                                  margin: EdgeInsets.only(
                                    right: context.widthPct(2),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: context.widthPct(2.5),
                                    vertical: context.heightPct(0.6),
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.card,
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.radiusMd,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _getAmenityIcon(amenity),
                                        size: context.responsiveFont(13),
                                        color: AppColors.textSecondary,
                                      ),
                                      SizedBox(width: context.widthPct(1)),
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
                SizedBox(height: context.heightPct(1.2)),

                /// PRICE + BOOK BUTTON
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
                              style: AppTypography.bodySm.copyWith(
                                fontSize: context.responsiveFont(13),
                                color: AppColors.textSecondary,
                              ),
                              children: [
                                const TextSpan(text: 'Starts from '),
                                TextSpan(
                                  text: displayPrice > 0
                                      ? '₹$displayPrice'
                                      : '₹--',
                                  style: AppTypography.headlineSm.copyWith(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.w700,
                                    fontSize: context.responsiveFont(18),
                                  ),
                                ),
                                const TextSpan(text: '/hr'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: context.widthPct(2.5)),
                    ElevatedButton(
                      onPressed: () {
                        final bookingCtrl = Get.find<BookingController>();
                        bookingCtrl.setSelectedTurf(turf);
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => TurfDetailScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.background,
                        padding: EdgeInsets.symmetric(
                          horizontal: context.widthPct(4.5),
                          vertical: context.heightPct(1),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            context.minDimensionPct(5),
                          ),
                        ),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Book',
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.background,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
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
