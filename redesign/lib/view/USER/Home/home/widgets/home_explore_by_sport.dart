import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'home_section_header.dart';
import 'home_shimmer.dart';

/* ============================================================
   EXPLORE BY SPORT
   ============================================================ */
class HomeExploreBySport extends StatelessWidget {
  const HomeExploreBySport({super.key});

  @override
  Widget build(BuildContext context) {
    final sports = ['Cricket', 'Football', 'Badminton', 'Tennis'];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const HomeSectionHeader('Explore by Sport'),
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final cardWidth = (w * 0.32).clamp(100.0, 140.0);
            final cardHeight = (cardWidth * 1.15).clamp(120.0, 150.0);
            final textSize = (w * 0.04).clamp(12.0, 14.0);
            final padding = (w * 0.035).clamp(10.0, 14.0);

            return SizedBox(
              height: cardHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20, right: 14),
                itemCount: sports.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: cardWidth,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          /// ✅ IMAGE WITH CACHE + SHIMMER
                          CachedNetworkImage(
                            imageUrl:
                                'https://images.unsplash.com/photo-1521412644187-c49fa049e84d',
                            cacheKey:
                                'https://images.unsplash.com/photo-1521412644187-c49fa049e84d',
                            fit: BoxFit.cover,
                            placeholder: (_, __) => const HomeShimmer(),
                            errorWidget: (_, __, ___) => const Icon(
                              Icons.broken_image,
                              color: Colors.white24,
                            ),
                          ),

                          Container(color: Colors.black.withOpacity(0.25)),

                          Padding(
                            padding: EdgeInsets.all(padding),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                sports[index],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: textSize,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
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
