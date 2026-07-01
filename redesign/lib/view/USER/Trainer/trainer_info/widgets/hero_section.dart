import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:redesign/theme/app_colors.dart';

const Color kBg = Colors.black;
const Color kGreen = AppColors.accent;

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

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
    final double topInset = MediaQuery.of(context).padding.top;

    return SliverAppBar(
      backgroundColor: kBg,
      expandedHeight: 280,
      pinned: false,
      automaticallyImplyLeading: false,
      stretch: true,
      flexibleSpace: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            /// -------------------------------
            /// PAGE VIEW (SWIPEABLE)
            /// -------------------------------
            PageView.builder(
              controller: _pageController,
              physics: const PageScrollPhysics(),
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
                      const ColoredBox(color: Colors.black),
                );
              },
            ),

            /// -------------------------------
            /// GRADIENT OVERLAY (NON-BLOCKING)
            /// -------------------------------
            IgnorePointer(
              child: Container(
                decoration: const BoxDecoration(
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
              left: 16,
              child: _iconBtn(Icons.arrow_back, onTap: () => Navigator.pop(context)),
            ),
            Positioned(
              top: topInset + 12,
              right: 72,
              child: _iconBtn(Icons.bookmark_border),
            ),
            Positioned(
              top: topInset + 12,
              right: 16,
              child: _iconBtn(Icons.share),
            ),

            /// -------------------------------
            /// ACADEMY BADGE
            /// -------------------------------
            Positioned(
              bottom: 34,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: kGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'ACADEMY',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
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
              bottom: 36,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (index) {
                  final bool active = index == _currentIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: active ? Colors.white : Colors.white54,
                      borderRadius: BorderRadius.circular(10),
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
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
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
