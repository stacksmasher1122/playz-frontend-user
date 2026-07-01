import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

Color kBg = Colors.black;
Color kGreen = AppColors.accent;

class HeroSection extends StatefulWidget {
  HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<String> images = [
    'https://images.unsplash.com/photo-1593341646782-e0b495cff86d',
    'https://images.unsplash.com/photo-1508609349937-5ec4ae374ebf',
    'https://images.unsplash.com/photo-1517649763962-0c623066013b',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final double topInset = MediaQuery.of(context).padding.top;

    return SliverAppBar(
      backgroundColor: kBg,
      expandedHeight: 280,
      pinned: false,
      automaticallyImplyLeading: false,
      stretch: true,
      flexibleSpace: ClipRRect(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(ResponsiveHelper.w(24))),
        child: Stack(
          fit: StackFit.expand,
          children: [
            /// -------------------------------
            /// PAGE VIEW (SWIPEABLE)
            /// -------------------------------
            PageView.builder(
              controller: _pageController,
              physics: PageScrollPhysics(),
              itemCount: images.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (_, index) {
                return CachedNetworkImage(
                  imageUrl: images[index],
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade900,
                    highlightColor: Colors.grey.shade800,
                    child: Container(color: Colors.black),
                  ),
                  errorWidget: (_, __, ___) =>
                      ColoredBox(color: Colors.black),
                );
              },
            ),

            /// -------------------------------
            /// GRADIENT OVERLAY (NON-BLOCKING)
            /// -------------------------------
            IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black54, Colors.black87],
                  ),
                ),
              ),
            ),

            /// -------------------------------
            /// TOP ICONS
            /// -------------------------------
            Positioned(
              top: topInset + 12,
              left: ResponsiveHelper.w(16),
              child: _iconBtn(Icons.arrow_back, onTap: () => Navigator.pop(context)),
            ),
            Positioned(
              top: topInset + 12,
              right: ResponsiveHelper.w(72),
              child: _iconBtn(Icons.bookmark_border),
            ),
            Positioned(
              top: topInset + 12,
              right: ResponsiveHelper.w(16),
              child: _iconBtn(Icons.share),
            ),

            /// -------------------------------
            /// ACADEMY BADGE
            /// -------------------------------
            Positioned(
              bottom: ResponsiveHelper.h(34),
              left: ResponsiveHelper.w(16),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: kGreen,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
                ),
                child: Text(
                  'ACADEMY',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: ResponsiveHelper.sp(12),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ),

            /// -------------------------------
            /// PAGE INDICATORS
            /// -------------------------------
            Positioned(
              bottom: ResponsiveHelper.h(36),
              left: ResponsiveHelper.w(0),
              right: ResponsiveHelper.w(0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (index) {
                  final bool active = index == _currentIndex;
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(4)),
                    width: active ? 18 : 6,
                    height: ResponsiveHelper.h(6),
                    decoration: BoxDecoration(
                      color: active ? Colors.white : Colors.white54,
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// -------------------------------
  /// ICON BUTTON
  /// -------------------------------
  Widget _iconBtn(IconData icon, {VoidCallback? onTap}) {
    return Material(
      color: Colors.black.withValues(alpha: 0.55),
      shape: CircleBorder(),
      child: InkWell(
        customBorder: CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: ResponsiveHelper.w(40),
          height: ResponsiveHelper.h(40),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}
