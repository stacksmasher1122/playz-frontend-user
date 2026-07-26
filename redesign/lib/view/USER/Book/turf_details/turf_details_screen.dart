import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Booking_Controller/booking_controller.dart';
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

  final _bookingController = Get.find<BookingController>();

  @override
  void initState() {
    super.initState();
    // Fetch grounds for the selected turf
    final turf = _bookingController.selectedTurf.value;
    if (turf != null) {
      _bookingController.fetchTurfGrounds(turf.ownerId, turf.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Obx(() {
      final turf = _bookingController.selectedTurf.value;
      final images = turf?.allImages ?? [];
      final lowestPrice = _bookingController.grounds.isNotEmpty
          ? _bookingController.lowestGroundPrice
          : turf?.lowestPrice ?? 0;

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
                  sports: turf?.sports ?? [],
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
                    VenueTitleSection(
                      turfName: turf?.turfName ?? '',
                      location: turf?.displayLocation ?? '',
                      isOpen: turf?.isCurrentlyOpen ?? false,
                    ),
                    SizedBox(height: 24),
                    VenueAboutSection(
                      description: turf?.description ?? '',
                      isExpanded: _expanded,
                      onToggleExpand: () => setState(() => _expanded = !_expanded),
                    ),
                    SizedBox(height: 24),
                    VenueAmenitiesGrid(
                      amenities: turf?.amenities ?? [],
                    ),
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
            price: lowestPrice,
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
    });
  }
}
