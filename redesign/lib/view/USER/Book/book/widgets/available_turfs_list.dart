import 'package:flutter/material.dart';
import '../book_screen.dart';
import 'turf_card.dart';

class AvailableTurfsList extends StatelessWidget {
  const AvailableTurfsList({super.key});

  static final _turfs = [
    TurfData(
      name: 'CrossFit Arena',
      location: 'Narhe, Pune',
      price: 1000,
      images: [
        'https://images.unsplash.com/photo-1529900948632-6aed3065b756',
        'https://images.unsplash.com/photo-1546519638-68e109498ffc',
      ],
    ),
    TurfData(
      name: 'Greenfield Turf',
      location: 'Baner, Pune',
      price: 1200,
      images: [
        'https://images.unsplash.com/photo-1521412644187-c49fa049e84d',
        'https://images.unsplash.com/photo-1546519638-68e109498ffc',
      ],
    ),
    TurfData(
      name: 'Urban Sports Hub',
      location: 'Wakad, Pune',
      price: 900,
      images: [
        'https://images.unsplash.com/photo-1546519638-68e109498ffc',
        'https://images.unsplash.com/photo-1529900948632-6aed3065b756',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: _turfs
            .map(
              (turf) => Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: TurfCard(data: turf),
              ),
            )
            .toList(),
      ),
    );
  }
}
