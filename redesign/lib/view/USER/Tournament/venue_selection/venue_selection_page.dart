import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

import '../../../../controller/User_Controller/Tournament_Controller/venue_selection_controller.dart';
import 'widgets/bottom_navigation.dart';
import 'widgets/map_preview.dart';
import 'widgets/progress_header.dart';
import 'widgets/venue_card.dart';
import 'widgets/venue_filter_chip.dart';
import 'widgets/venue_search_bar.dart';
import 'widgets/venue_tabbar.dart';

class VenueSelectionPage extends StatefulWidget {
  const VenueSelectionPage({super.key});

  @override
  State<VenueSelectionPage> createState() => _VenueSelectionPageState();
}

class _VenueSelectionPageState extends State<VenueSelectionPage> {
  late final VenueSelectionController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(VenueSelectionController());
  }

  @override
  void dispose() {
    Get.delete<VenueSelectionController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
            size: context.responsiveFont(20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "Create Tournament",
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.accent,
              fontSize: context.responsiveFont(18),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.close_rounded,
              color: AppColors.textPrimary,
              size: context.responsiveFont(22),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: context.heightPct(1)),
                    const ProgressHeader(
                      currentStep: 2,
                      totalSteps: 5,
                      title: "Step 2 of 5: Venue Selection",
                    ),
                    SizedBox(height: context.heightPct(2.5)),
                    
                    Obx(() => VenueTabbar(
                      selectedTab: controller.selectedTab.value,
                      onTabChanged: controller.changeTab,
                    )),
                    SizedBox(height: context.heightPct(2.5)),
                    
                    Obx(() {
                      final lat = controller.selectedVenueLatitude.value;
                      final lng = controller.selectedVenueLongitude.value;
                      if (lat != null && lng != null) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: context.heightPct(2.5)),
                          child: MapPreview(latitude: lat, longitude: lng),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                    
                    VenueSearchBar(
                      controller: controller.searchController,
                      onLocationTap: () => controller.onLocationTap(context),
                    ),
                    SizedBox(height: context.heightPct(2.5)),
                    
                    // Filter Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
                      child: Obx(() => Row(
                        children: controller.availableFilters.map((filter) {
                          return VenueFilterChip(
                            label: filter,
                            isSelected: controller.selectedFilter.value == filter,
                            onTap: () => controller.changeFilter(filter),
                          );
                        }).toList(),
                      )),
                    ),
                    SizedBox(height: context.heightPct(2.5)),
                    
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
                      child: Text(
                        "Recommended Venues",
                        style: AppTypography.headlineMd.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: context.responsiveFont(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: context.heightPct(1.8)),
                    
                    // Venue List
                    Obx(() => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
                      itemCount: controller.filteredVenues.length,
                      itemBuilder: (context, index) {
                        final venue = controller.filteredVenues[index];
                        return VenueCard(
                          venue: venue,
                          onSelect: () => controller.selectVenue(venue.id),
                        );
                      },
                    )),
                    SizedBox(height: context.heightPct(2.5)),
                  ],
                ),
              ),
            ),
            
            // Bottom Navigation
            BottomNavigation(
              onBack: () => controller.goBack(context),
              onNext: () => controller.goNext(context),
            ),
          ],
        ),
      ),
    );
  }
}
