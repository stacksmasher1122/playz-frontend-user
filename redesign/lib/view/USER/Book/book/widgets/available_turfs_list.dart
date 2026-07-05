import 'package:flutter/material.dart';
import '../book_screen.dart';
import 'turf_card.dart';
import 'package:redesign/theme/responsive_helper.dart';

class AvailableTurfsList extends StatelessWidget {
  AvailableTurfsList({super.key});

  static final _turfs = [
    TurfData(
      name: 'CrossFit Arena',
      location: 'Narhe, Pune',
      price: 1000,
      images: [
        'https://images.unsplash.com/photo-1529900948632-6aed3065b756',
        'https://images.unsplash.com/photo-1546519638-68e109498ffc',
      ],
      amenities: ['Basketball', 'Parking', 'Shower', 'AC'],
      discount: '10% OFF on first booking',
    ),
    TurfData(
      name: 'Greenfield Turf',
      location: 'Baner, Pune',
      price: 1200,
      images: [
        'https://images.unsplash.com/photo-1521412644187-c49fa049e84d',
        'https://images.unsplash.com/photo-1546519638-68e109498ffc',
      ],
      amenities: ['Football', 'Parking', 'Shower'],
      discount: '15% OFF on weekdays',
    ),
    TurfData(
      name: 'Urban Sports Hub',
      location: 'Wakad, Pune',
      price: 900,
      images: [
        'https://images.unsplash.com/photo-1546519638-68e109498ffc',
        'https://images.unsplash.com/photo-1529900948632-6aed3065b756',
      ],
      amenities: ['Cricket', 'AC', 'Parking'],
      discount: null,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20)),
      child: Column(
        children: _turfs
            .map(
              (turf) => Padding(
                padding: EdgeInsets.only(bottom: 18),
                child: TurfCard(data: turf),
              ),
            )
            .toList(),
      ),
    );
  }
}
