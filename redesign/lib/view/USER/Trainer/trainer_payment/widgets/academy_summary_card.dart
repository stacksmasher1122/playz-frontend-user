import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

const kCard = Color(0xFF1A1A1A);
const kMuted = Color(0xFFA7A7A7);
const kYellow = Color(0xFFFFC107);

class AcademySummaryCard extends StatelessWidget {
  const AcademySummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl:
                  'https://images.unsplash.com/photo-1546519638-68e109498ffc',
              width: 52,
              height: 52,
              fit: BoxFit.cover,
              placeholder: (_, __) => Shimmer.fromColors(
                baseColor: Colors.grey.shade900,
                highlightColor: Colors.grey.shade800,
                child: Container(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'PowerPlay Cricket Academy',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, color: kMuted, size: 14),
                    SizedBox(width: 4),
                    Text('Baner, Pune',
                        style: TextStyle(color: kMuted, fontSize: 12)),
                    SizedBox(width: 10),
                    Icon(Icons.star, color: kYellow, size: 14),
                    SizedBox(width: 4),
                    Text('4.9',
                        style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
