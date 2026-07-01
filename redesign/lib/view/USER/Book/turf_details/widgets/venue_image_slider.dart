import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:redesign/theme/responsive_helper.dart';

class VenueImageSlider extends StatelessWidget {
  final List<String> images;
  final PageController pageController;
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  VenueImageSlider({
    super.key,
    required this.images,
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        SizedBox(
          height: size.height * 0.35,
          child: PageView.builder(
            controller: pageController,
            itemCount: images.length,
            onPageChanged: onPageChanged,
            itemBuilder: (_, index) {
              return CachedNetworkImage(
                imageUrl: images[index],
                fit: BoxFit.cover,
                placeholder: (_, __) => Shimmer.fromColors(
                  baseColor: Colors.grey.shade800,
                  highlightColor: Colors.grey.shade700,
                  child: Container(color: Colors.black),
                ),
              );
            },
          ),
        ),

        /// TOP ICONS
        Positioned(
          top: ResponsiveHelper.h(35),
          left: ResponsiveHelper.w(16),
          child: _circleIcon(context, Icons.arrow_back, onTap: () => Navigator.pop(context)),
        ),
        Positioned(
          top: ResponsiveHelper.h(35),
          right: ResponsiveHelper.w(16),
          child: _circleIcon(context, Icons.favorite_border),
        ),

        /// PAGE INDICATORS
        Positioned(
          bottom: ResponsiveHelper.h(25),
          right: ResponsiveHelper.w(25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              images.length,
              (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(4)),
                width: currentPage == index ? 20 : 6,
                height: ResponsiveHelper.h(6),
                decoration: BoxDecoration(
                  color: currentPage == index
                      ? AppColors.accent
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(6)),
                ),
              ),
            ),
          ),
        ),

        Positioned(
          bottom: ResponsiveHelper.h(10),
          left: ResponsiveHelper.w(10),
          child: _greenBadge('CROSSFIT & GYM'),
        ),
      ],
    );
  }

  Widget _greenBadge(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12), vertical: ResponsiveHelper.h(6)),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _circleIcon(BuildContext context, IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: Colors.black.withValues(alpha: 0.6),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
