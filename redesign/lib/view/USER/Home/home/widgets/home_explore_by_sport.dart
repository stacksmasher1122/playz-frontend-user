import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'home_section_header.dart';
import 'home_shimmer.dart';

/* ============================================================
   EXPLORE BY SPORT
   ============================================================ */
class HomeExploreBySport extends StatelessWidget {
  const HomeExploreBySport({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final sports = const ['Cricket', 'Football', 'Badminton', 'Tennis'];

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.widthPct(5)),
          child: const HomeSectionHeader('Explore by Sport'),
        ),
        SizedBox(height: context.heightPct(1.5)),
        LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final cardWidth = (w * 0.32).clamp(100.0, 140.0);
            final cardHeight = (cardWidth * 1.15).clamp(120.0, 150.0);
            final padding = context.widthPct(3.5).clamp(10.0, 14.0);

            return SizedBox(
              height: cardHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(
                  left: context.widthPct(5),
                  right: context.widthPct(3.5),
                ),
                itemCount: sports.length,
                separatorBuilder: (_, __) => SizedBox(width: context.widthPct(3.5)),
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: cardWidth,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        context.minDimensionPct(4).clamp(12.0, 18.0),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          /// IMAGE WITH CACHE + SHIMMER
                          CachedNetworkImage(
                            imageUrl:
                                'https://images.unsplash.com/photo-1521412644187-c49fa049e84d',
                            cacheKey:
                                'https://images.unsplash.com/photo-1521412644187-c49fa049e84d',
                            fit: BoxFit.cover,
                            placeholder: (_, __) => const HomeShimmer(),
                            errorWidget: (_, __, ___) => const Icon(
                              Icons.broken_image,
                              color: AppColors.muted,
                            ),
                          ),

                          Container(color: Colors.black.withValues(alpha: 0.25)),

                          Padding(
                            padding: EdgeInsets.all(padding),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  sports[index],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.headlineSm.copyWith(
                                    color: AppColors.textPrimary,
                                    fontSize: context.responsiveFont(13),
                                    fontWeight: FontWeight.w600,
                                  ),
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
