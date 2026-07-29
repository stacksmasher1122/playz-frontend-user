import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Booking_Controller/booking_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/view/USER/Navigation/user_navigation.dart';
import 'home_section_header.dart';
import 'home_shimmer.dart';

/* ============================================================
   EXPLORE BY SPORT (DYNAMIC)
   ============================================================ */
class HomeExploreBySport extends StatelessWidget {
  const HomeExploreBySport({super.key});

  static const Map<String, String> _sportImageMap = {
    'Football': 'https://images.unsplash.com/photo-1579952363873-27f3bade9f55',
    'Cricket': 'https://images.unsplash.com/photo-1531415074968-036ba1b575da',
    'Badminton': 'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea',
    'Tennis': 'https://images.unsplash.com/photo-1595435934249-5df7ed86e1c0',
    'Basketball': 'https://images.unsplash.com/photo-1546519638-68e109498ffc',
    'Pickleball': 'https://images.unsplash.com/photo-1511067007398-7e4b90cfa4bc',
    'Volleyball': 'https://images.unsplash.com/photo-1612872087720-bb876e2e67d1',
    'Table Tennis': 'https://images.unsplash.com/photo-1534158914592-062992fbe900',
    'Squash': 'https://images.unsplash.com/photo-1554068865-24cecd4e34b8',
    'Golf': 'https://images.unsplash.com/photo-1535131749006-b7f58c99034b',
  };

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final bookingCtrl = Get.isRegistered<BookingController>()
        ? Get.find<BookingController>()
        : Get.put(BookingController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.widthPct(5)),
          child: const HomeSectionHeader('Explore by Sport'),
        ),
        SizedBox(height: context.heightPct(1.5)),
        Obx(() {
          // Dynamic list of sports combining core sports + fetched turfs
          final turfSports = bookingCtrl.allTurfs
              .expand((t) => t.sports)
              .map((s) => s.trim())
              .where((s) => s.isNotEmpty)
              .toSet();

          final sports = <String>{
            'Football',
            'Badminton',
            'Basketball',
            'Pickleball',
            'Cricket',
            'Tennis',
            'Volleyball',
            'Table Tennis',
            ...turfSports,
          }.toList();

          return LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final cardWidth = (w * 0.32).clamp(100.0, 140.0);
              final cardHeight = (cardWidth * 1.15).clamp(120.0, 150.0);
              final padding = context.widthPct(3.5).clamp(10.0, 14.0);

              return SizedBox(
                height: cardHeight,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(
                    left: context.widthPct(5),
                    right: context.widthPct(3.5),
                  ),
                  itemCount: sports.length,
                  separatorBuilder: (_, __) =>
                      SizedBox(width: context.widthPct(3.5)),
                  itemBuilder: (context, index) {
                    final sportName = sports[index];
                    final imageUrl = _sportImageMap[sportName] ??
                        'https://images.unsplash.com/photo-1521412644187-c49fa049e84d';

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(
                          context.minDimensionPct(4).clamp(12.0, 18.0),
                        ),
                        onTap: () {
                          // Apply filter by selected sport
                          bookingCtrl.filterTurfsBySport(sportName);

                          // Switch to Book section tab
                          if (Get.isRegistered<UserNavController>()) {
                            Get.find<UserNavController>().changeTab(1);
                          } else {
                            Get.to(() => const UserAppNavShell(initialIndex: 1));
                          }
                        },
                        child: SizedBox(
                          width: cardWidth,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              context.minDimensionPct(4).clamp(12.0, 18.0),
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                /// CACHED IMAGE WITH SHIMMER
                                CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  cacheKey: imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => const HomeShimmer(),
                                  errorWidget: (_, __, ___) => const Icon(
                                    Icons.sports_soccer,
                                    color: AppColors.muted,
                                  ),
                                ),

                                Container(
                                  color: Colors.black.withValues(alpha: 0.35),
                                ),

                                Padding(
                                  padding: EdgeInsets.all(padding),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        sportName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            AppTypography.headlineSm.copyWith(
                                          color: AppColors.textPrimary,
                                          fontSize:
                                              context.responsiveFont(13.5),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        }),
      ],
    );
  }
}
