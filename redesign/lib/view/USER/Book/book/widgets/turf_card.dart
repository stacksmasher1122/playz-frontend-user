import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/view/USER/Book/turf_details/turf_details_screen.dart';
import '../book_screen.dart';
import 'image_shimmer.dart';

class TurfCard extends StatefulWidget {
  final TurfData data;
  const TurfCard({super.key, required this.data});

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
    super.build(context);

    final data = widget.data;
    final width = MediaQuery.of(context).size.width;
    final imageHeight = width * 0.48;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE PAGE VIEW (CACHED + SHIMMER)
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
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
                      errorWidget: (_, __, ___) => const Center(
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
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        data.images.length,
                        (i) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: 6,
                          height: 6,
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
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔥 NAVIGABLE CONTENT ONLY
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        // builder: (_) => const UserHomePage(),
                        builder: (_) => const TurfDetailScreen(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: AppColors.accent,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: AppColors.muted,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Row(
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(text: '⭐ '),
                                  TextSpan(
                                    text: '4.6',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                '(128 reviews) • 2.4 km away',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  color: AppColors.muted,
                                  fontSize: 12,
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
                            fontSize: 13,
                            color: AppColors.muted,
                          ),
                          children: [
                            const TextSpan(text: 'Starts from '),
                            TextSpan(
                              text: '₹${data.price}',
                              style: const TextStyle(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                            const TextSpan(text: '/hr'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        // 👉 booking flow only
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Book'),
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
