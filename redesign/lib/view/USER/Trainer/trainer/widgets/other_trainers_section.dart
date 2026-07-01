import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/view/USER/Trainer/trainer_info/trainer_info_screen.dart';
import '../trainer_models.dart';
import 'package:redesign/theme/responsive_helper.dart';

class OtherTrainersSection extends StatelessWidget {
  OtherTrainersSection({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      children: [
        SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverToBoxAdapter(child: _FilterChips()),
        SliverToBoxAdapter(child: SizedBox(height: 16)),
        _DiscoveryGrid(),
      ],
    );
  }
}

class _FilterChips extends StatefulWidget {
  _FilterChips();

  @override
  State<_FilterChips> createState() => _FilterChipsState();
}

class _FilterChipsState extends State<_FilterChips> {
  int selected = 0;
  final chips = ['All', 'Cricket', 'Fitness', 'Football', 'Yoga'];

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return SizedBox(
      height: ResponsiveHelper.h(42),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (_, __) => SizedBox(width: 10),
        itemBuilder: (_, i) {
          final active = selected == i;
          return GestureDetector(
            onTap: () => setState(() => selected = i),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? AppColors.accent : AppColors.surface,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
              ),
              child: Text(
                chips[i],
                style: GoogleFonts.inter(
                  color: active ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DiscoveryGrid extends StatelessWidget {
  _DiscoveryGrid();

  final items = [
    DiscoveryItem(
      name: 'Rahul Sharma',
      subtitle: 'FitCore Gym, Pune',
      rating: 4.8,
      type: EntityType.trainer,
      images: ['https://images.unsplash.com/photo-1599058917212-d750089bc07c'],
      tags: ['Adults', 'Strength'],
      sports: [Icons.fitness_center],
    ),
    DiscoveryItem(
      name: 'PowerPlay Cricket',
      subtitle: 'Kothrud, Pune',
      rating: 4.9,
      type: EntityType.academy,
      images: ['https://images.unsplash.com/photo-1521412644187-c49fa049e84d'],
      tags: ['Kids', 'Camp'],
      sports: [Icons.sports_cricket, Icons.groups],
    ),
    DiscoveryItem(
      name: 'Anjali Deshmukh',
      subtitle: 'Viman Nagar',
      rating: 5.0,
      type: EntityType.trainer,
      images: ['https://images.unsplash.com/photo-1599058917212-d750089bc07c'],
      tags: ['Women', 'Yoga'],
      sports: [Icons.self_improvement],
    ),
    DiscoveryItem(
      name: 'Smash Zone',
      subtitle: 'Baner, Pune',
      rating: 4.5,
      type: EntityType.academy,
      images: ['https://images.unsplash.com/photo-1546519638-68e109498ffc'],
      tags: ['Pro', 'Coaching'],
      sports: [Icons.sports_tennis],
    ),
    DiscoveryItem(
      name: 'Anjali Deshmukh',
      subtitle: 'Viman Nagar',
      rating: 5.0,
      type: EntityType.trainer,
      images: ['https://images.unsplash.com/photo-1599058917212-d750089bc07c'],
      tags: ['Women', 'Yoga'],
      sports: [Icons.self_improvement],
    ),
    DiscoveryItem(
      name: 'Smash Zone',
      subtitle: 'Baner, Pune',
      rating: 4.5,
      type: EntityType.academy,
      images: ['https://images.unsplash.com/photo-1546519638-68e109498ffc'],
      tags: ['Pro', 'Coaching'],
      sports: [Icons.sports_tennis],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final width = MediaQuery.of(context).size.width;
    final columns = width >= 900 ? 3 : 2;

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (_, i) => _DiscoveryCard(item: items[i]),
          childCount: items.length,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.68,
        ),
      ),
    );
  }
}

class _DiscoveryCard extends StatefulWidget {
  final DiscoveryItem item;
  _DiscoveryCard({required this.item});

  @override
  State<_DiscoveryCard> createState() => _DiscoveryCardState();
}

class _DiscoveryCardState extends State<_DiscoveryCard> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final item = widget.item;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return AcademyDetailScreen();
            },
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(ResponsiveHelper.w(16)),
              ),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1.08,
                    child: PageView.builder(
                      itemCount: item.images.length,
                      onPageChanged: (i) => setState(() => index = i),
                      itemBuilder: (_, i) => CachedNetworkImage(
                        imageUrl: item.images[i],
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Shimmer.fromColors(
                          baseColor: Colors.grey.shade800,
                          highlightColor: Colors.grey.shade700,
                          child: Container(color: Colors.grey.shade800),
                        ),
                        errorWidget: (_, __, ___) =>
                            Icon(Icons.broken_image),
                      ),
                    ),
                  ),

                  /// TYPE BADGE
                  Positioned(
                    top: ResponsiveHelper.h(8),
                    left: ResponsiveHelper.w(8),
                    child: _Pill(
                      item.type == EntityType.trainer ? 'TRAINER' : 'ACADEMY',
                    ),
                  ),

                  /// SPORTS ICONS
                  Positioned(
                    top: ResponsiveHelper.h(8),
                    right: ResponsiveHelper.w(8),
                    child: Row(
                      children: item.sports.take(2).map((icon) {
                        return Container(
                          margin: EdgeInsets.only(left: 6),
                          padding: EdgeInsets.all(ResponsiveHelper.w(6)),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(icon, size: 14, color: Colors.white),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            /// INFO
            Padding(
              padding: EdgeInsets.all(ResponsiveHelper.w(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      _Rating(item.rating),
                    ],
                  ),
                  SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: AppColors.muted,
                      fontSize: ResponsiveHelper.sp(12),
                    ),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: item.tags.map(_TagChip.new).toList(),
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

class _Pill extends StatelessWidget {
  final String text;
  _Pill(this.text);

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(10), vertical: ResponsiveHelper.h(4)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
        border: Border.all(color: Colors.white70),
        color: Colors.black54,
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: ResponsiveHelper.sp(10),
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _Rating extends StatelessWidget {
  final double rating;
  _Rating(this.rating);

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(6), vertical: ResponsiveHelper.h(2)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
      ),
      child: Row(
        children: [
          Icon(Icons.star, size: 12, color: AppColors.accent),
          SizedBox(width: 2),
          Text(
            rating.toString(),
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(11),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String text;
  _TagChip(this.text);

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(8), vertical: ResponsiveHelper.h(4)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(fontSize: ResponsiveHelper.sp(11), color: Colors.white),
      ),
    );
  }
}
