import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
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
                        // builder: (_) => UserHomePage(),
                        builder: (_) => TurfDetailScreen(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 12),
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
                      ],
                    ),
                  ),
                ),

                /// 🔥 PRICE + BOOK (NOT NAVIGABLE)
                Row(
                  children: [
                    Expanded(
                      child: RichText(
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
