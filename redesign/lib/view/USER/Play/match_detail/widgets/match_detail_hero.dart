import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchDetailHero extends StatefulWidget {
  final List<String>? images;
  final String? sport;
  final String? type;
  final String? time;
  final bool isHost;
  final bool isSlotBooked;
  final VoidCallback? onDeletePressed;

  const MatchDetailHero({
    super.key,
    this.images,
    this.sport = 'Football',
    this.type = 'Casual',
    this.time = 'Today, 18:00',
    this.isHost = false,
    this.isSlotBooked = false,
    this.onDeletePressed,
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
      backgroundColor: AppColors.background,
      pinned: true,
      elevation: 0,
      leading: Padding(
        padding: EdgeInsets.all(context.widthPct(2)),
        child: CircleAvatar(
          backgroundColor: AppColors.background.withValues(alpha: 0.5),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      actions: [
        if (widget.isHost && !widget.isSlotBooked && widget.onDeletePressed != null) ...[
          CircleAvatar(
            backgroundColor: AppColors.background.withValues(alpha: 0.5),
            child: IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
              onPressed: widget.onDeletePressed,
              tooltip: 'Delete Match Poll',
            ),
          ),
          SizedBox(width: context.widthPct(2)),
        ],
        CircleAvatar(
          backgroundColor: AppColors.background.withValues(alpha: 0.5),
          child: IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.textPrimary, size: 20),
            onPressed: () {},
          ),
        ),
        SizedBox(width: context.widthPct(3)),
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
                    color: AppColors.surface,
                    child: const Icon(Icons.sports_soccer, color: AppColors.muted, size: 48),
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
                top: context.heightPct(6),
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
                        color: _currentPage == idx ? AppColors.accent : AppColors.muted.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),

            /// BOTTOM TAGS & TIME INDICATOR
            Positioned(
              bottom: context.heightPct(2),
              left: context.widthPct(5),
              right: context.widthPct(5),
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
                      SizedBox(width: context.widthPct(2)),
                      _HeroTag(
                        safeSport.toUpperCase(),
                        bgColor: AppColors.textPrimary.withValues(alpha: 0.15),
                        textColor: AppColors.textPrimary,
                      ),
                    ],
                  ),
                  SizedBox(height: context.heightPct(1.5)),
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
                      SizedBox(width: context.widthPct(2)),
                      Expanded(
                        child: Text(
                          safeTime,
                          style: AppTypography.headlineSm.copyWith(
                            fontSize: context.responsiveFont(16),
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
        horizontal: context.widthPct(3),
        vertical: context.heightPct(0.6),
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
        border: borderColor != null ? Border.all(color: borderColor!) : null,
      ),
      child: Text(
        label,
        style: AppTypography.labelCaps10.copyWith(
          fontSize: context.responsiveFont(11),
          fontWeight: FontWeight.bold,
          color: textColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
