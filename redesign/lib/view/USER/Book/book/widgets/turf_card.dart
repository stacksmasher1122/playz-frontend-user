import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_dimensions.dart';
import 'package:redesign/view/USER/Book/turf_details/turf_details_screen.dart';
import '../book_screen.dart';
import 'image_shimmer.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TurfCard extends StatefulWidget {
  final TurfData data;
  TurfCard({super.key, required this.data});

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
        return Icons.shower;
      case 'ac':
      case 'air conditioning':
        return Icons.ac_unit;
      case 'football':
      case 'soccer':
        return Icons.sports_soccer;
      case 'cricket':
        return Icons.sports_cricket;
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

    final data = widget.data;
    final width = MediaQuery.of(context).size.width;
    final imageHeight = width * 0.48;

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
                  child: PageView.builder(
                    itemCount: data.images.length,
                    onPageChanged: (i) => setState(() => _pageIndex = i),
                    itemBuilder: (_, i) => CachedNetworkImage(
                      imageUrl: data.images[i],
                      cacheKey: data.images[i],
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
                  ),
                ),

                /// PAGE INDICATOR
                if (data.images.length > 1)
                  Positioned(
                    bottom: ResponsiveHelper.h(10),
                    left: ResponsiveHelper.w(0),
                    right: ResponsiveHelper.w(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        data.images.length,
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
                          data.name,
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
                          data.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: AppColors.muted,
                            fontSize: ResponsiveHelper.sp(12),
                          ),
                        ),
                        SizedBox(height: 8),

                        Row(
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(text: '⭐ '),
                                  TextSpan(
                                    text: '4.6',
                                    style: GoogleFonts.inter(
                                      fontSize: ResponsiveHelper.sp(13),
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                '(128 reviews) • 2.4 km away',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  color: AppColors.muted,
                                  fontSize: ResponsiveHelper.sp(12),
                                ),
                              ),
                            ),
                          ],
                        ),

                        /// AMENITY TAGS ROW
                        if (data.amenities.isNotEmpty) ...[
                          SizedBox(height: ResponsiveHelper.h(10)),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: data.amenities.map((amenity) {
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
                                  text: '₹${data.price}',
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
                          if (data.discount != null) ...[
                            SizedBox(height: ResponsiveHelper.h(4)),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.local_offer,
                                  size: ResponsiveHelper.sp(12),
                                  color: AppColors.accent,
                                ),
                                SizedBox(width: ResponsiveHelper.w(4)),
                                Text(
                                  data.discount!,
                                  style: GoogleFonts.inter(
                                    color: AppColors.accent,
                                    fontSize: ResponsiveHelper.sp(11),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        // 👉 booking flow only
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
