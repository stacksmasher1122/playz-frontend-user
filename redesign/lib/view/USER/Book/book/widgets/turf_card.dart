import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Booking_Controller/booking_controller.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/model/User_Models/Booking_Models/turf_model.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_dimensions.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/view/USER/Book/booking_details/booking_details_screen.dart';
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
  bool _isPressed = false;

  IconData _getSportIcon(String sport) {
    switch (sport.toLowerCase().trim()) {
      case 'football':
      case 'soccer':
        return Icons.sports_soccer;
      case 'cricket':
        return Icons.sports_cricket;
      case 'basketball':
        return Icons.sports_basketball;
      case 'tennis':
      case 'badminton':
      case 'pickleball':
      case 'table tennis':
      case 'squash':
        return Icons.sports_tennis;
      case 'volleyball':
        return Icons.sports_volleyball;
      case 'golf':
        return Icons.sports_golf;
      case 'baseball':
        return Icons.sports_baseball;
      default:
        return Icons.sports;
    }
  }

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

  void _navigateToTurfDetail(BuildContext context, TurfModel turf) {
    final bookingCtrl = Get.find<BookingController>();
    bookingCtrl.setSelectedTurf(turf);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TurfDetailScreen(heroTag: 'available_turf_hero_${turf.id}'),
      ),
    );
  }

  void _navigateToBookingDetails(BuildContext context, TurfModel turf) {
    final bookingCtrl = Get.find<BookingController>();
    bookingCtrl.setSelectedTurf(turf);
    bookingCtrl.fetchTurfGrounds(turf.ownerId, turf.id);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ConfirmSlotScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    super.build(context);

    final turf = widget.turf;
    final images = turf.allImages;
    final imageHeight = context.widthPct(48).clamp(160.0, 240.0);
    final displayPrice = turf.lowestPrice?.toInt() ?? 0;
    final favoriteBtnSize = context.minDimensionPct(9).clamp(32.0, 40.0);

    final mapsCtrl = Get.isRegistered<MapsController>() ? Get.find<MapsController>() : null;
    final userLoc = mapsCtrl?.currentLocation.value;
    final distanceStr = turf.getFormattedDistance(userLoc?.lat, userLoc?.lng);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () async {
        setState(() => _isPressed = false);
        await Future.delayed(const Duration(milliseconds: 60));
        if (mounted) {
          _navigateToTurfDetail(context, turf);
        }
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// IMAGE PAGE VIEW WITH HERO ANIMATION (CACHED + SHIMMER)
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
                              itemBuilder: (_, i) {
                                final imgWidget = CachedNetworkImage(
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
                                );

                                if (i == 0) {
                                  return Hero(
                                    tag: 'available_turf_hero_${turf.id}',
                                    transitionOnUserGestures: true,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: imgWidget,
                                    ),
                                  );
                                }
                                return imgWidget;
                              },
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
                              margin: EdgeInsets.symmetric(horizontal: context.widthPct(0.8)),
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: i == _pageIndex
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary.withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                        ),
                      ),

                    /// FAVORITE BUTTON (REACTIVELY SYNCED WITH FIREBASE)
                    Positioned(
                      top: context.heightPct(1.2),
                      right: context.widthPct(3),
                      child: Obx(() {
                        final bookingCtrl = Get.find<BookingController>();
                        final isFav = bookingCtrl.isTurfFavorite(turf.id);

                        return GestureDetector(
                          onTap: () {
                            bookingCtrl.toggleFavoriteTurf(turf.id);
                          },
                          child: Container(
                            width: favoriteBtnSize,
                            height: favoriteBtnSize,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.55),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? AppColors.accent : AppColors.textPrimary,
                              size: favoriteBtnSize * 0.52,
                            ),
                          ),
                        );
                      }),
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
                    Padding(
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

                          /// RATING • DISTANCE • SPORTS LOGOS ROW
                          Row(
                            children: [
                              // Rating
                              const Icon(Icons.star, color: Colors.amber, size: 14),
                              const SizedBox(width: 3),
                              Text(
                                turf.rating.toStringAsFixed(1),
                                style: AppTypography.bodySm.copyWith(
                                  fontSize: context.responsiveFont(12),
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              // Bullet Separator
                              Text(
                                '  •  ',
                                style: AppTypography.bodySm.copyWith(
                                  fontSize: context.responsiveFont(12),
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              // Distance
                              Text(
                                distanceStr,
                                style: AppTypography.bodySm.copyWith(
                                  fontSize: context.responsiveFont(12),
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              // Bullet Separator & Sports Logos
                              if (turf.sports.isNotEmpty) ...[
                                Text(
                                  '  •  ',
                                  style: AppTypography.bodySm.copyWith(
                                    fontSize: context.responsiveFont(12),
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ...turf.sports.take(2).map((sport) {
                                      return Container(
                                        margin: const EdgeInsets.only(right: 4),
                                        padding: const EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          color: AppColors.card,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.borderDark,
                                            width: 1,
                                          ),
                                        ),
                                        child: Icon(
                                          _getSportIcon(sport),
                                          size: 13,
                                          color: AppColors.accent,
                                        ),
                                      );
                                    }),
                                    if (turf.sports.length > 2)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.card,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: AppColors.accent.withValues(alpha: 0.4),
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          '+${turf.sports.length - 2}',
                                          style: AppTypography.bodySm.copyWith(
                                            color: AppColors.accent,
                                            fontSize: context.responsiveFont(10),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ],
                          ),

                          /// AMENITY TAGS ROW (SHOW MAX 3 + TRUNCATED COUNT "+N")
                          if (turf.amenities.isNotEmpty) ...[
                            SizedBox(height: context.heightPct(1.2)),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  ...turf.amenities.take(3).map((amenity) {
                                    return Container(
                                      margin: EdgeInsets.only(right: context.widthPct(2)),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: context.widthPct(2.5),
                                        vertical: context.heightPct(0.6),
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.card,
                                        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
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
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTypography.bodySm.copyWith(
                                              color: AppColors.textPrimary,
                                              fontSize: context.responsiveFont(11),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                  if (turf.amenities.length > 3)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: context.widthPct(2.5),
                                        vertical: context.heightPct(0.6),
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.card,
                                        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                                        border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
                                      ),
                                      child: Text(
                                        '+${turf.amenities.length - 3}',
                                        style: AppTypography.bodySm.copyWith(
                                          color: AppColors.accent,
                                          fontSize: context.responsiveFont(11),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    /// HORIZONTAL DIVIDER LINE
                    const Divider(
                      color: AppColors.divider,
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
                          onPressed: () => _navigateToBookingDetails(context, turf),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: AppColors.background,
                            padding: EdgeInsets.symmetric(
                              horizontal: context.widthPct(4.5),
                              vertical: context.heightPct(1),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
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
        ),
      ),
    );
  }
}
