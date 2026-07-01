import 'package:flutter/material.dart';
import '../bookings_screen.dart';
import 'filter_chip.dart';

class BookingsSearchAndFilters extends StatelessWidget {
  const BookingsSearchAndFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search by venue, sport or ID…',
              hintStyle: TextStyle(color: Colors.white54),
              prefixIcon: const Icon(Icons.search, color: Colors.white54),
              filled: true,
              fillColor: MyBookingsConstants.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: const [
              BookingFilterChip('Filters', icon: Icons.tune),
              BookingFilterChip('This Week'),
              BookingFilterChip('Football'),
              BookingFilterChip('Cricket'),
              BookingFilterChip('Badminton'),
            ],
          ),
        ),
      ],
    );
  }
}
