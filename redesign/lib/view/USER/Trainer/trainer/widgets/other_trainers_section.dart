import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/view/USER/Trainer/trainer_info/trainer_info_screen.dart';
import '../trainer_models.dart';
import 'package:redesign/theme/responsive_helper.dart';

class OtherTrainersSection extends StatelessWidget {
  const OtherTrainersSection({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: context.heightPct(1.5))),
        const SliverToBoxAdapter(child: _FilterChips()),
        SliverToBoxAdapter(child: SizedBox(height: context.heightPct(2))),
        _DiscoveryGrid(),
      ],
    );
  }
}

class _FilterChips extends StatefulWidget {
  const _FilterChips();

  @override
  State<_FilterChips> createState() => _FilterChipsState();
}

class _FilterChipsState extends State<_FilterChips> {
  int selected = 0;
  final chips = const ['All', 'Cricket', 'Fitness', 'Football', 'Yoga'];

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final barHeight = context.heightPct(5).clamp(38.0, 44.0);

    return SizedBox(
      height: barHeight,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (_, __) => SizedBox(width: context.widthPct(2.5)),
        itemBuilder: (_, i) {
          final active = selected == i;
          return GestureDetector(
            onTap: () => setState(() => selected = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? AppColors.accent : AppColors.surface,
                borderRadius: BorderRadius.circular(context.minDimensionPct(6)),
              ),
              child: Text(
                chips[i],
                style: AppTypography.headlineSm.copyWith(
                  color: active ? AppColors.background : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: context.responsiveFont(13),
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
  ];

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final width = MediaQuery.of(context).size.width;
    final columns = width >= 900 ? 3 : 2;

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (_, i) => _DiscoveryCard(item: items[i]),
          childCount: items.length,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisSpacing: context.widthPct(3),
          crossAxisSpacing: context.widthPct(3),
          childAspectRatio: 0.68,
        ),
      ),
    );
  }
}

class _DiscoveryCard extends StatefulWidget {
  final DiscoveryItem item;
  const _DiscoveryCard({required this.item});

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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// IMAGE
              Expanded(
                flex: 6,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    PageView.builder(
                      itemCount: item.images.length,
                      onPageChanged: (i) => setState(() => index = i),
                      itemBuilder: (_, i) => CachedNetworkImage(
                        imageUrl: item.images[i],
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Shimmer.fromColors(
                          baseColor: AppColors.surfaceElevated.withValues(alpha: 0.6),
                          highlightColor: AppColors.borderDark.withValues(alpha: 0.8),
                          child: Container(color: AppColors.card),
                        ),
                        errorWidget: (_, __, ___) => const Icon(
                          Icons.broken_image,
                          color: AppColors.muted,
                        ),
                      ),
                    ),

                    /// TYPE BADGE
                    Positioned(
                      top: context.heightPct(1),
                      left: context.widthPct(2),
                      child: _Pill(
                        item.type == EntityType.trainer ? 'TRAINER' : 'ACADEMY',
                      ),
                    ),

                    /// SPORTS ICONS
                    Positioned(
                      top: context.heightPct(1),
                      right: context.widthPct(2),
                      child: Row(
                        children: item.sports.take(2).map((icon) {
                          return Container(
                            margin: EdgeInsets.only(left: context.widthPct(1.5)),
                            padding: EdgeInsets.all(context.widthPct(1.5)),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.54),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(icon, size: 14, color: AppColors.textPrimary),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              /// INFO
              Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.all(context.widthPct(2.5)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.headlineSm.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          _Rating(item.rating),
                        ],
                      ),
                      SizedBox(height: context.heightPct(0.3)),
                      Text(
                        item.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.muted,
                          fontSize: context.responsiveFont(12),
                        ),
                      ),
                      SizedBox(height: context.heightPct(0.8)),
                      Wrap(
                        spacing: context.widthPct(1.5),
                        runSpacing: context.heightPct(0.5),
                        children: item.tags.map((t) => _TagChip(t)).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  const _Pill(this.text);

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(2.5),
        vertical: context.heightPct(0.5),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
        border: Border.all(color: AppColors.textSecondary),
        color: Colors.black.withValues(alpha: 0.54),
      ),
      child: Text(
        text,
        style: AppTypography.labelCaps10.copyWith(
          fontSize: context.responsiveFont(10),
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _Rating extends StatelessWidget {
  final double rating;
  const _Rating(this.rating);

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(1.5),
        vertical: context.heightPct(0.3),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.minDimensionPct(2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.star, size: 12, color: AppColors.accent),
          SizedBox(width: context.widthPct(0.5)),
          Text(
            rating.toString(),
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(11),
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
  const _TagChip(this.text);

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(2),
        vertical: context.heightPct(0.4),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
      ),
      child: Text(
        text,
        style: AppTypography.bodySm.copyWith(
          fontSize: context.responsiveFont(11),
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
