import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchDetailHero extends StatefulWidget {
  final List<String>? images;
  final String? sport;
  final String? type;
  final String? time;

  const MatchDetailHero({
    super.key,
    this.images,
    this.sport = 'Football',
    this.type = 'Casual',
    this.time = 'Today, 18:00',
  });

  @override
  State<MatchDetailHero> createState() => _MatchDetailHeroState();
}

class _MatchDetailHeroState extends State<MatchDetailHero> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<String> _fallbackImages = [
    "https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?q=80&w=1200",
    "https://images.unsplash.com/photo-1517649763962-0c623066013b?q=80&w=1200",
    "https://images.unsplash.com/photo-1521412644187-c49fa049e84d?q=80&w=1200",
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final height = MediaQuery.of(context).size.height * 0.38;
    final imageList = (widget.images != null && widget.images!.isNotEmpty)
        ? widget.images!
        : _fallbackImages;

    final safeType = (widget.type ?? 'Casual').toString();
    final safeSport = (widget.sport ?? 'Football').toString();
    final safeTime = (widget.time ?? 'Today, 18:00').toString();

    final isCompetitive = safeType.toLowerCase() == 'competitive';

    return SliverAppBar(
      expandedHeight: height,
      backgroundColor: Colors.black,
      pinned: true,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.black45,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      actions: [
        CircleAvatar(
          backgroundColor: Colors.black45,
          child: IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.white, size: 20),
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 12),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            /// MULTIPLE SCROLLABLE TURF IMAGES CAROUSEL
            PageView.builder(
              controller: _pageController,
              itemCount: imageList.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                return Image.network(
                  imageList[index],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade900,
                    child: const Icon(Icons.sports_soccer, color: Colors.white38, size: 48),
                  ),
                );
              },
            ),

            /// GRADIENT OVERLAY
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.background,
                    AppColors.background.withValues(alpha: 0.5),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),

            /// PAGE INDICATOR DOTS
            if (imageList.length > 1)
              Positioned(
                top: ResponsiveHelper.h(50),
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    imageList.length,
                    (idx) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: _currentPage == idx ? 18 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _currentPage == idx ? AppColors.accent : Colors.white38,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),

            /// BOTTOM TAGS & TIME INDICATOR
            Positioned(
              bottom: ResponsiveHelper.h(16),
              left: ResponsiveHelper.w(20),
              right: ResponsiveHelper.w(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _HeroTag(
                        safeType.toUpperCase(),
                        bgColor: isCompetitive
                            ? const Color(0xFF7C3AED).withValues(alpha: 0.3)
                            : AppColors.accent.withValues(alpha: 0.2),
                        textColor: isCompetitive
                            ? const Color(0xFFA855F7)
                            : AppColors.accent,
                        borderColor: isCompetitive
                            ? const Color(0xFF7C3AED)
                            : AppColors.accent,
                      ),
                      const SizedBox(width: 8),
                      _HeroTag(
                        safeSport.toUpperCase(),
                        bgColor: Colors.white.withValues(alpha: 0.15),
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        safeTime,
                        style: GoogleFonts.inter(
                          fontSize: ResponsiveHelper.sp(16),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroTag extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;
  final Color? borderColor;

  const _HeroTag(
    this.label, {
    required this.bgColor,
    required this.textColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(12),
        vertical: ResponsiveHelper.h(5),
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        border: borderColor != null ? Border.all(color: borderColor!) : null,
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: ResponsiveHelper.sp(11),
          fontWeight: FontWeight.bold,
          color: textColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
