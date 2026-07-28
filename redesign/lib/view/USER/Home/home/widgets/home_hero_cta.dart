import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/event_fest_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'home_shimmer.dart';

/* ============================================================
   HERO CTA CARD (AUTO SLIDING PAGE VIEW)
   ============================================================ */
class HomeHeroCTA extends StatefulWidget {
  const HomeHeroCTA({super.key});

  @override
  State<HomeHeroCTA> createState() => _HomeHeroCTAState();
}

class _HomeHeroCTAState extends State<HomeHeroCTA> {
  late final PageController _pageController;
  int _currentIndex = 0;
  final _eventFestController = Get.find<EventFestController>();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 5));
      if (!mounted) return false;

      final slides = _eventFestController.activeSlides;
      if (slides.length > 1) {
        _currentIndex = (_currentIndex + 1) % slides.length;
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
      return true;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(5)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;

          final cardHeight = (w * 0.55).clamp(160.0, 220.0);
          final radius = context.minDimensionPct(5).clamp(14.0, 22.0);
          final padding = context.widthPct(4.5).clamp(12.0, 20.0);

          return SizedBox(
            height: cardHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Obx(() {
                final slides = _eventFestController.activeSlides;
                if (slides.isEmpty) {
                  return const HomeShimmer();
                }
                return PageView.builder(
                  controller: _pageController,
                  itemCount: slides.length,
                  itemBuilder: (context, index) {
                    final slide = slides[index];

                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        /// CACHED IMAGE + SHIMMER
                        CachedNetworkImage(
                          imageUrl: slide['image']!,
                          cacheKey: slide['image'],
                          fit: BoxFit.cover,
                          placeholder: (_, __) => const HomeShimmer(),
                          errorWidget: (_, __, ___) => const Center(
                            child: Icon(
                              Icons.broken_image,
                              color: AppColors.muted,
                              size: 32,
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
                                Colors.black.withValues(alpha: 0.65),
                                Colors.black.withValues(alpha: 0.35),
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
                              /// BADGE
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.widthPct(3).clamp(8.0, 14.0),
                                  vertical: context.heightPct(0.5).clamp(4.0, 8.0),
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.muted.withValues(alpha: 0.4),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  slide['badge']!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.labelCaps.copyWith(
                                    fontSize: context.responsiveFont(11),
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.0,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),

                              const Spacer(),

                              /// TITLE
                              Text(
                                slide['title']!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.headlineLg.copyWith(
                                  fontSize: context.responsiveFont(22),
                                  fontWeight: FontWeight.w700,
                                  height: 1.15,
                                  color: AppColors.textPrimary,
                                ),
                              ),

                              const Spacer(),

                              /// CTA BUTTON
                              SizedBox(
                                height: context.heightPct(5).clamp(40.0, 46.0),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.accent,
                                    foregroundColor: AppColors.background,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: context.widthPct(5).clamp(16.0, 24.0),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        context.minDimensionPct(4),
                                      ),
                                    ),
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      slide['buttonTitle'] ??
                                          'Explore Games Near You',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypography.bodyMd.copyWith(
                                        color: AppColors.background,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
