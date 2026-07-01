import 'package:flutter/material.dart';
import '../bookings_screen.dart';
import 'filter_chip.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BookingsSearchAndFilters extends StatelessWidget {
  BookingsSearchAndFilters({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search by venue, sport or ID…',
              hintStyle: TextStyle(color: Colors.white54),
              prefixIcon: Icon(Icons.search, color: Colors.white54),
              filled: true,
              fillColor: MyBookingsConstants.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
          child: Row(
            children: [
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
