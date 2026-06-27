import 'package:flutter/material.dart';
import '../book_screen.dart';
import 'trending_tile.dart';

class TrendingList extends StatelessWidget {
  const TrendingList({super.key});

  static final _trending = [
    TrendingData(
      'Metro Futsal',
      '4.9',
      '2km',
      'https://images.unsplash.com/photo-1546519638-68e109498ffc',
    ),
    TrendingData(
      'Pro Cricket Arena',
      '4.7',
      '3.5km',
      'https://images.unsplash.com/photo-1521412644187-c49fa049e84d',
    ),
    TrendingData(
      'Smash Badminton',
      '4.8',
      '1.8km',
      'https://images.unsplash.com/photo-1574629810360-7efbbe195018',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _trending.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) => TrendingTile(data: _trending[i]),
      ),
    );
  }
}
