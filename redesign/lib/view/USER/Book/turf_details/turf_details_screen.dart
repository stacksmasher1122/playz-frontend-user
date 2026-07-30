import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Booking_Controller/booking_controller.dart';
import 'package:redesign/view/USER/Book/booking_details/booking_details_screen.dart';

import 'widgets/cancellation_policy_banner.dart';
import 'widgets/recommended_venues_list.dart';
import 'widgets/venue_about_section.dart';
import 'widgets/venue_amenities_grid.dart';
import 'widgets/venue_booking_bar.dart';
import 'widgets/venue_image_slider.dart';
import 'widgets/venue_reviews_section.dart';
import 'widgets/venue_title_section.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TurfDetailScreen extends StatefulWidget {
  final String heroTag;
  const TurfDetailScreen({super.key, this.heroTag = ''});

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
      if (turf == null) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: const Center(
            child: CircularProgressIndicator(color: AppColors.accent),
          ),
        );
      }

      final images = turf.allImages;
      final lowestPrice = _bookingController.grounds.isNotEmpty
          ? _bookingController.lowestGroundPrice
          : turf.lowestPrice ?? 0;

      final effectiveHeroTag = widget.heroTag.isNotEmpty
          ? widget.heroTag
          : 'available_turf_hero_${turf.id}';

      // Check real dynamic active status & operating hours from TurfModel
      final bool isTurfActive = turf.isAvailableForBooking;
      final String statusText = turf.statusDisplayText;
      final bool isOpenNow = isTurfActive && turf.isCurrentlyOpen;

      return SafeArea(
        top: false,
        child: Scaffold(
          extendBody: true,
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              /// IMAGE SLIDER HEADER WITH SPORT LOGOS & SYNCED FAVORITES
              SliverToBoxAdapter(
                child: VenueImageSlider(
                  heroTag: effectiveHeroTag,
                  turfId: turf.id,
                  images: images,
                  sports: turf.sports,
                  pageController: _pageController,
                  currentPage: _currentPage,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                ),
              ),

              /// MAIN DETAILS CONTENT
              SliverPadding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, context.heightPct(10)),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    VenueTitleSection(
                      turfId: turf.id,
                      turfName: turf.turfName,
                      location: turf.displayLocation,
                      isOpen: isOpenNow,
                      statusText: statusText,
                      rating: turf.rating,
                    ),
                    SizedBox(height: context.heightPct(2.5)),
                    VenueAboutSection(
                      description: turf.description,
                      latitude: turf.latitude,
                      longitude: turf.longitude,
                      fullAddress: turf.fullAddress,
                      isExpanded: _expanded,
                      onToggleExpand: () => setState(() => _expanded = !_expanded),
                    ),
                    SizedBox(height: context.heightPct(2.5)),
                    VenueAmenitiesGrid(
                      amenities: turf.amenities,
                    ),
                    SizedBox(height: context.heightPct(2.5)),
                    const CancellationPolicyBanner(),
                    SizedBox(height: context.heightPct(2.5)),
                    VenueReviewsSection(
                      turfId: turf.id,
                      turfName: turf.turfName,
                      rating: turf.rating,
                    ),
                    SizedBox(height: context.heightPct(2.5)),
                    RecommendedVenuesList(
                      currentTurfId: turf.id,
                      currentSports: turf.sports,
                    ),
                  ]),
                ),
              ),
            ],
          ),

          /// STICKY BOOK NOW BAR WITH DYNAMIC STATUS ENFORCEMENT
          bottomNavigationBar: VenueBookingBar(
            price: lowestPrice,
            isActive: isOpenNow,
            onBookNow: () {
              if (!isTurfActive) {
                Get.snackbar(
                  'Turf Closed',
                  'This turf is currently set closed by owner.',
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 3),
                );
                return;
              }
              if (!turf.isCurrentlyOpen) {
                Get.snackbar(
                  'Turf Closed',
                  'This turf is currently closed for the day.',
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 3),
                );
                return;
              }
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ConfirmSlotScreen(),
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
