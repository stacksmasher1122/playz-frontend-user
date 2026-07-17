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
          icon: Icon(Icons.arrow_back_ios, color: AppColors.onPrimary, size: ResponsiveHelper.w(20)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Create Tournament",
          style: AppTypography.headlineMd.copyWith(
            color: AppColors.accent,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: AppColors.onPrimary, size: ResponsiveHelper.w(24)),
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
                    SizedBox(height: ResponsiveHelper.h(8)),
                    const ProgressHeader(
                      currentStep: 2,
                      totalSteps: 6,
                      title: "Step 2 of 6: Venue Selection",
                    ),
                    SizedBox(height: ResponsiveHelper.h(24)),
                    
                    Obx(() => VenueTabbar(
                      selectedTab: controller.selectedTab.value,
                      onTabChanged: controller.changeTab,
                    )),
                    SizedBox(height: ResponsiveHelper.h(24)),
                    
                    const MapPreview(),
                    SizedBox(height: ResponsiveHelper.h(24)),
                    
                    VenueSearchBar(
                      controller: controller.searchController,
                      onLocationTap: controller.onLocationTap,
                    ),
                    SizedBox(height: ResponsiveHelper.h(24)),
                    
                    // Filter Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
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
                    SizedBox(height: ResponsiveHelper.h(24)),
                    
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
                      child: Text(
                        "Recommended Venues",
                        style: AppTypography.headlineMd.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.h(16)),
                    
                    // Venue List
                    Obx(() => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
                      itemCount: controller.filteredVenues.length,
                      itemBuilder: (context, index) {
                        final venue = controller.filteredVenues[index];
                        return VenueCard(
                          venue: venue,
                          onSelect: () => controller.selectVenue(venue.id),
                        );
                      },
                    )),
                    SizedBox(height: ResponsiveHelper.h(24)),
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
