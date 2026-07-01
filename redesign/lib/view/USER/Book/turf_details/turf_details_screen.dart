import 'package:flutter/material.dart';
import 'package:redesign/view/USER/Book/booking_details/booking_details_screen.dart';

import 'widgets/cancellation_policy_banner.dart';
import 'widgets/recent_bookings_social.dart';
import 'widgets/recommended_venues_list.dart';
import 'widgets/venue_about_section.dart';
import 'widgets/venue_amenities_grid.dart';
import 'widgets/venue_booking_bar.dart';
import 'widgets/venue_image_slider.dart';
import 'widgets/venue_reviews_section.dart';
import 'widgets/venue_title_section.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TurfDetailScreen extends StatefulWidget {
  TurfDetailScreen({super.key});

  @override
  State<TurfDetailScreen> createState() => _TurfDetailScreenState();
}

class _TurfDetailScreenState extends State<TurfDetailScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _expanded = false;

  final List<String> images = [
    'https://images.unsplash.com/photo-1571902943202-507ec2618e8f',
    'https://images.unsplash.com/photo-1554284126-aa88f22d8b74',
    'https://images.unsplash.com/photo-1599058917212-d750089bc07d',
  ];

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return SafeArea(
      top: false,
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.black,
        body: CustomScrollView(
          slivers: [
            /// IMAGE SLIDER HEADER
            SliverToBoxAdapter(
              child: VenueImageSlider(
                images: images,
                pageController: _pageController,
                currentPage: _currentPage,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
              ),
            ),

            /// CONTENT
            SliverPadding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 80),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  VenueTitleSection(),
                  SizedBox(height: 24),
                  VenueAboutSection(
                    isExpanded: _expanded,
                    onToggleExpand: () => setState(() => _expanded = !_expanded),
                  ),
                  SizedBox(height: 24),
                  VenueAmenitiesGrid(),
                  SizedBox(height: 24),
                  CancellationPolicyBanner(),
                  SizedBox(height: 24),
                  RecentBookingsSocial(),
                  SizedBox(height: 24),
                  VenueReviewsSection(),
                  SizedBox(height: 24),
                  RecommendedVenuesList(images: images),
                ]),
              ),
            ),
          ],
        ),

        /// STICKY BOOK NOW BAR
        bottomNavigationBar: VenueBookingBar(
          onBookNow: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ConfirmSlotScreen(),
              ),
            );
          },
        ),
      ),
    );
  }
}
