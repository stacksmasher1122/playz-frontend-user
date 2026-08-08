import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/common/app_back_button.dart';

import '../../../../controller/User_Controller/Tournament_Controller/venue_selection_controller.dart';
import 'widgets/bottom_navigation.dart';
import 'widgets/map_preview.dart';
import 'widgets/progress_header.dart';
import 'widgets/venue_card.dart';
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
        leading: Padding(
          padding: EdgeInsets.only(left: ResponsiveHelper.w(8.0)),
          child: const AppBackButton(),
        ),
        title: Text(
          "Create Tournament",
          style: AppTypography.headlineMd.copyWith(
            color: AppColors.primary,
            fontSize: ResponsiveHelper.sp(18.0),
            fontWeight: FontWeight.w900,
          ).responsive(context),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: ResponsiveHelper.w(12.0)),
            child: InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(20.0)),
              child: Container(
                width: ResponsiveHelper.w(36.0),
                height: ResponsiveHelper.w(36.0),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.card,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.close_rounded,
                  color: AppColors.primaryGreen,
                  size: ResponsiveHelper.w(20.0),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable Content Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: ResponsiveHelper.h(8.0)),

                    // Progress Header (Step 2 of 5)
                    const ProgressHeader(
                      currentStep: 2,
                      totalSteps: 5,
                      title: "Step 2 of 5: Venue Selection",
                    ),
                    SizedBox(height: ResponsiveHelper.h(20.0)),

                    // Venue Selection Toggle Tabbar
                    Obx(() => VenueTabbar(
                          selectedTab: controller.selectedTab.value,
                          onTabChanged: controller.changeTab,
                        )),
                    SizedBox(height: ResponsiveHelper.h(20.0)),

                    // Dynamic Content based on Active Tab
                    Obx(() {
                      final isPlayZTab = controller.selectedTab.value == "PlayZ Venues";

                      if (isPlayZTab) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Search Bar for PlayZ Real Venues
                            VenueSearchBar(
                              controller: controller.searchController,
                              onLocationTap: () => controller.onLocationTap(context),
                            ),
                            SizedBox(height: ResponsiveHelper.h(20.0)),

                            // 2. Section Header: Nearby Venues
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveHelper.w(16.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Nearby Venues",
                                    style: AppTypography.headlineSm.copyWith(
                                      color: AppColors.textPrimary,
                                      fontSize: ResponsiveHelper.sp(16.0),
                                      fontWeight: FontWeight.w900,
                                    ).responsive(context),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: ResponsiveHelper.w(10.0),
                                      vertical: ResponsiveHelper.h(4.0),
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(
                                        ResponsiveHelper.w(20.0),
                                      ),
                                    ),
                                    child: Text(
                                      "${controller.activeSportName} • ${controller.filteredVenues.length} Venues",
                                      style: AppTypography.bodySm.copyWith(
                                        color: AppColors.primary,
                                        fontSize: ResponsiveHelper.sp(12.0),
                                        fontWeight: FontWeight.w700,
                                      ).responsive(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: ResponsiveHelper.h(14.0)),

                            // 3. Real Firebase Venues List / Empty State / Loading State
                            if (controller.isLoading.value)
                              Container(
                                padding: EdgeInsets.all(ResponsiveHelper.w(32.0)),
                                alignment: Alignment.center,
                                child: const CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              )
                            else if (controller.venues.isEmpty)
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ResponsiveHelper.w(16.0),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ResponsiveHelper.w(20.0),
                                    vertical: ResponsiveHelper.h(28.0),
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.card,
                                    borderRadius: BorderRadius.circular(
                                      ResponsiveHelper.w(16.0),
                                    ),
                                    border: Border.all(color: AppColors.borderDark),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(
                                          ResponsiveHelper.w(16.0),
                                        ),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primary.withValues(alpha: 0.1),
                                        ),
                                        child: Icon(
                                          Icons.stadium_outlined,
                                          color: AppColors.primary,
                                          size: ResponsiveHelper.w(36.0),
                                        ),
                                      ),
                                      SizedBox(height: ResponsiveHelper.h(14.0)),
                                      Text(
                                        'No turfs found for ${controller.activeSportName}',
                                        style: AppTypography.headlineSm.copyWith(
                                          color: AppColors.textPrimary,
                                          fontSize: ResponsiveHelper.sp(16.0),
                                          fontWeight: FontWeight.bold,
                                        ).responsive(context),
                                      ),
                                      SizedBox(height: ResponsiveHelper.h(6.0)),
                                      Text(
                                        'No verified turfs for ${controller.activeSportName} are available in Firebase yet.\nSwitch to "Other Venue" to specify a custom location or pick on map.',
                                        textAlign: TextAlign.center,
                                        style: AppTypography.bodySm.copyWith(
                                          color: AppColors.mutedText,
                                          fontSize: ResponsiveHelper.sp(13.0),
                                          height: 1.4,
                                        ).responsive(context),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else if (controller.filteredVenues.isEmpty)
                              Container(
                                padding: EdgeInsets.all(ResponsiveHelper.w(32.0)),
                                alignment: Alignment.center,
                                child: Text(
                                  'No venues found matching "${controller.searchController.text}"',
                                  textAlign: TextAlign.center,
                                  style: AppTypography.bodySm.copyWith(
                                    color: AppColors.mutedText,
                                    fontSize: ResponsiveHelper.sp(13.0),
                                    fontStyle: FontStyle.italic,
                                  ).responsive(context),
                                ),
                              )
                            else
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                  horizontal: ResponsiveHelper.w(16.0),
                                ),
                                itemCount: controller.filteredVenues.length,
                                itemBuilder: (context, index) {
                                  final venue = controller.filteredVenues[index];
                                  return VenueCard(
                                    venue: venue,
                                    onSelect: () => controller.selectVenue(venue.id),
                                  );
                                },
                              ),
                            SizedBox(height: ResponsiveHelper.h(20.0)),
                          ],
                        );
                      } else {
                        // ─── Other Venue / Custom Location Tab ───
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.w(16.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Specify Custom Location",
                                style: AppTypography.headlineSm.copyWith(
                                  color: AppColors.textPrimary,
                                  fontSize: ResponsiveHelper.sp(16.0),
                                  fontWeight: FontWeight.w900,
                                ).responsive(context),
                              ),
                              SizedBox(height: ResponsiveHelper.h(4.0)),
                              Text(
                                "Search any address or pick your exact match location on map",
                                style: AppTypography.bodySm.copyWith(
                                  color: AppColors.mutedText,
                                  fontSize: ResponsiveHelper.sp(13.0),
                                ).responsive(context),
                              ),
                              SizedBox(height: ResponsiveHelper.h(16.0)),

                              // 1. Custom Location Search Bar
                              Container(
                                height: ResponsiveHelper.h(48.0),
                                decoration: BoxDecoration(
                                  color: AppColors.card,
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveHelper.w(14.0),
                                  ),
                                  border: Border.all(
                                    color: AppColors.borderDark,
                                    width: 1.0,
                                  ),
                                ),
                                child: TextField(
                                  controller: controller.customSearchController,
                                  style: AppTypography.bodyMd.copyWith(
                                    color: AppColors.textPrimary,
                                    fontSize: ResponsiveHelper.sp(14.0),
                                  ).responsive(context),
                                  decoration: InputDecoration(
                                    hintText: 'Search address or location name...',
                                    hintStyle: AppTypography.bodySm.copyWith(
                                      color: AppColors.mutedText,
                                      fontSize: ResponsiveHelper.sp(13.0),
                                    ).responsive(context),
                                    prefixIcon: Icon(
                                      Icons.search_rounded,
                                      color: AppColors.primary,
                                      size: ResponsiveHelper.w(20.0),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.my_location_rounded,
                                        color: AppColors.primary,
                                        size: ResponsiveHelper.w(20.0),
                                      ),
                                      onPressed: () => controller.onLocationTap(context),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: ResponsiveHelper.h(12.0),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: ResponsiveHelper.h(16.0)),

                              // 2. Dynamic Map Preview (rendered when lat & lng are selected via map picker)
                              Obx(() {
                                final lat = controller.selectedVenueLatitude.value;
                                final lng = controller.selectedVenueLongitude.value;
                                if (lat != null && lng != null) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: ResponsiveHelper.h(16.0),
                                    ),
                                    child: MapPreview(latitude: lat, longitude: lng),
                                  );
                                }
                                return const SizedBox.shrink();
                              }),

                              // 3. Map Picker Card (No hardcoded location)
                              InkWell(
                                onTap: () => controller.onLocationTap(context),
                                borderRadius: BorderRadius.circular(
                                  ResponsiveHelper.w(14.0),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(ResponsiveHelper.w(16.0)),
                                  decoration: BoxDecoration(
                                    color: AppColors.card,
                                    borderRadius: BorderRadius.circular(
                                      ResponsiveHelper.w(14.0),
                                    ),
                                    border: Border.all(
                                      color: AppColors.borderDark,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: ResponsiveHelper.w(44.0),
                                        height: ResponsiveHelper.w(44.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primary.withValues(alpha: 0.15),
                                        ),
                                        child: Icon(
                                          Icons.location_on_rounded,
                                          color: AppColors.primary,
                                          size: ResponsiveHelper.w(22.0),
                                        ),
                                      ),
                                      SizedBox(width: ResponsiveHelper.w(14.0)),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              controller.selectedVenueName.value ??
                                                  "Select Location on Map",
                                              style: AppTypography.headlineSm.copyWith(
                                                color: AppColors.textPrimary,
                                                fontSize: ResponsiveHelper.sp(14.0),
                                                fontWeight: FontWeight.bold,
                                              ).responsive(context),
                                            ),
                                            SizedBox(height: ResponsiveHelper.h(4.0)),
                                            Text(
                                              controller.selectedVenueAddress.value ??
                                                  "Search above or tap here to pick map location",
                                              style: AppTypography.bodySm.copyWith(
                                                color: AppColors.mutedText,
                                                fontSize: ResponsiveHelper.sp(12.0),
                                              ).responsive(context),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.chevron_right_rounded,
                                        color: AppColors.mutedText,
                                        size: ResponsiveHelper.w(24.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: ResponsiveHelper.h(24.0)),
                            ],
                          ),
                        );
                      }
                    }),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Bar (Back & Next Buttons)
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
