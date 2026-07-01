import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../home_screen.dart';
import 'home_section_header.dart';
import 'home_shimmer.dart';

/* ============================================================
   POPULAR VENUES
   ============================================================ */
class HomePopularVenues extends StatelessWidget {
  const HomePopularVenues({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: Column(
        children: const [
          HomeSectionHeader('Popular Venues'),
          SizedBox(height: 14),
          HomeVenueTile(
            title: 'Urban Kick Turf',
            location: 'Indiranagar • 2.5km',
            price: '₹1200/hr',
            rating: '4.8',
            status: 'Open till 11 PM',
          ),
          SizedBox(height: 12),
          HomeVenueTile(
            title: 'Skyline Arena',
            location: 'Koramangala • 4.1km',
            price: '₹900/hr',
            rating: '4.6',
            status: 'Filling Fast',
          ),
        ],
      ),
    );
  }
}

class HomeVenueTile extends StatelessWidget {
  final String title;
  final String location;
  final String price;
  final String rating;
  final String status;

  const HomeVenueTile({super.key, 
    required this.title,
    required this.location,
    required this.price,
    required this.rating,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: UserHomePage.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
      ),
      child: Row(
        children: [
          /// ✅ IMAGE WITH CACHE + SHIMMER
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl:
                  'https://images.unsplash.com/photo-1546519638-68e109498ffc',
              cacheKey:
                  'https://images.unsplash.com/photo-1546519638-68e109498ffc',
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              placeholder: (_, __) =>
                  const HomeShimmer(width: 70, height: 70, borderRadius: 12),
              errorWidget: (_, __, ___) =>
                  const Icon(Icons.broken_image, color: Colors.white54),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: UserHomePage.muted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  price,
                  style: const TextStyle(
                    color: UserHomePage.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, size: 14, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(rating, style: const TextStyle(color: Colors.white)),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                status,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: UserHomePage.muted, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
