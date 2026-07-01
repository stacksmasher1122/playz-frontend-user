import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../home_screen.dart';
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const HomeSectionHeader('Featured Events'),
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;

            final cardHeight = (w * 0.42).clamp(140.0, 170.0);
            final padding = (w * 0.045).clamp(12.0, 16.0);
            final titleSize = (w * 0.045).clamp(14.0, 16.0);
            final subtitleSize = (w * 0.035).clamp(11.0, 12.0);
            final tagSize = (w * 0.032).clamp(10.0, 11.0);

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
                      left: index == 0 ? 20 : 0,
                      right: index == _events.length - 1 ? 20 : 16,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          /// ✅ CACHED IMAGE WITH SHIMMER
                          CachedNetworkImage(
                            imageUrl: event['image']!,
                            fit: BoxFit.cover,
                            cacheKey: event['image'],
                            placeholder: (context, _) => const HomeShimmer(),
                            errorWidget: (context, _, __) => const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.white54,
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
                                    horizontal: (w * 0.03).clamp(8.0, 12.0),
                                    vertical: (w * 0.012).clamp(4.0, 6.0),
                                  ),
                                  decoration: BoxDecoration(
                                    color: UserHomePage.accent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    event['tag']!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: tagSize,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),

                                const Spacer(),

                                /// TITLE
                                Text(
                                  event['title']!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: titleSize,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                /// SUBTITLE
                                Text(
                                  event['subtitle']!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: UserHomePage.muted,
                                    fontSize: subtitleSize,
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
