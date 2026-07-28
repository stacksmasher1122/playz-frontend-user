import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'home_section_header.dart';
import 'home_shimmer.dart';

/* ============================================================
   FEATURED EVENTS
   ============================================================ */
class HomeFeaturedEvents extends StatefulWidget {
  const HomeFeaturedEvents({super.key});

  @override
  State<HomeFeaturedEvents> createState() => _HomeFeaturedEventsState();
}

class _HomeFeaturedEventsState extends State<HomeFeaturedEvents> {
  late final PageController _controller;
  int _index = 0;

  static const _events = [
    {
      'image': 'https://images.unsplash.com/photo-1547347298-4074fc3086f0',
      'title': 'Prime Energy Cup 2024',
      'subtitle': 'Starts Aug 12 • Entry ₹500',
      'tag': 'SPONSORED',
    },
    {
      'image': 'https://images.unsplash.com/photo-1521412644187-c49fa049e84d',
      'title': 'Weekend Football Bash',
      'subtitle': 'Open slots available',
      'tag': 'HOT',
    },
    {
      'image': 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2',
      'title': 'Community Badminton',
      'subtitle': 'Free entry • All levels',
      'tag': 'COMMUNITY',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.86);

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 5));
      if (!mounted) return false;

      _index = (_index + 1) % _events.length;
      _controller.animateToPage(
        _index,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
      return true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.widthPct(5)),
          child: const HomeSectionHeader('Featured Events'),
        ),
        SizedBox(height: context.heightPct(1.5)),
        LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;

            final cardHeight = (w * 0.42).clamp(140.0, 170.0);
            final padding = context.widthPct(4.5).clamp(12.0, 16.0);

            return SizedBox(
              height: cardHeight,
              child: PageView.builder(
                controller: _controller,
                padEnds: false,
                itemCount: _events.length,
                itemBuilder: (context, index) {
                  final event = _events[index];

                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? context.widthPct(5) : 0,
                      right: index == _events.length - 1 ? context.widthPct(5) : context.widthPct(4),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        context.minDimensionPct(5).clamp(14.0, 20.0),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          /// CACHED IMAGE WITH SHIMMER
                          CachedNetworkImage(
                            imageUrl: event['image']!,
                            fit: BoxFit.cover,
                            cacheKey: event['image'],
                            placeholder: (context, _) => const HomeShimmer(),
                            errorWidget: (context, _, __) => const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: AppColors.muted,
                                size: 28,
                              ),
                            ),
                          ),

                          /// OVERLAY
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.55),
                                  Colors.black.withValues(alpha: 0.25),
                                ],
                              ),
                            ),
                          ),

                          /// CONTENT
                          Padding(
                            padding: EdgeInsets.all(padding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// TAG
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: context.widthPct(3).clamp(8.0, 12.0),
                                    vertical: context.heightPct(0.5).clamp(4.0, 6.0),
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    event['tag']!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.labelCaps.copyWith(
                                      fontSize: context.responsiveFont(10),
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.background,
                                    ),
                                  ),
                                ),

                                const Spacer(),

                                /// TITLE
                                Text(
                                  event['title']!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.headlineSm.copyWith(
                                    color: AppColors.textPrimary,
                                    fontSize: context.responsiveFont(15),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                SizedBox(height: context.heightPct(0.5)),

                                /// SUBTITLE
                                Text(
                                  event['subtitle']!,
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
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
