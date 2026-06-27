import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

import 'widgets/bookings_header.dart';
import 'widgets/search_and_filters.dart';
import 'widgets/bookings_tabs.dart';
import 'widgets/upcoming_bookings.dart';
import 'widgets/past_bookings.dart';
import 'widgets/cancelled_bookings.dart';
import 'widgets/empty_state.dart';

class MyBookingsConstants {
  static const Color bg = AppColors.background;
  static const Color surface = Color(0xFF0E0E0E);
  static const Color green = AppColors.accent;
  static const Color muted = Colors.white70;
  static const Color red = Color(0xFFE53935);
  static const Color amber = Color(0xFFFFB300);
}

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyBookingsConstants.bg,
      body: SafeArea(
        child: Column(
          children: [
            const BookingsHeader(),
            const BookingsSearchAndFilters(),
            BookingsTabs(controller: _tabController),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  UpcomingBookingsWidget(),
                  PastBookingsWidget(),
                  CancelledBookingsWidget(),
                  BookingsEmptyState(
                    icon: Icons.timer_off,
                    text: 'No waitlisted bookings',
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
