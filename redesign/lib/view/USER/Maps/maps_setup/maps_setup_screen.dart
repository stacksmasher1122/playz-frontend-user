import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/model/maps_model.dart';
import 'package:redesign/shared_preferences/maps_preferences.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/view/USER/Maps/maps_picker/maps_picker_screen.dart';
import 'package:redesign/view/USER/Maps/maps_setup/widgets/current_location_card.dart';
import 'package:redesign/view/USER/Maps/maps_setup/widgets/location_tile.dart';
import 'package:redesign/view/USER/Maps/maps_setup/widgets/map_tile.dart';
import 'package:redesign/view/USER/Maps/maps_setup/widgets/search_bar_delegate.dart';
import 'package:redesign/view/USER/Maps/maps_setup/widgets/section_header.dart';
import 'package:redesign/view/USER/Maps/maps_setup/widgets/tap_bounce_container.dart';
import 'package:redesign/view/USER/Maps/maps_setup/widgets/search_results_overlay.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LocationSelectSliverScreen extends StatefulWidget {
  const LocationSelectSliverScreen({super.key});

  @override
  State<LocationSelectSliverScreen> createState() =>
      _LocationSelectSliverScreenState();
}

class _LocationSelectSliverScreenState
    extends State<LocationSelectSliverScreen> {
  final ScrollController _scrollController = ScrollController();
  final _mapsCtrl = Get.find<MapsController>();
  final _searchController = TextEditingController();
  double _smallTitleOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load data
    _mapsCtrl.recentLocations.refresh();
    _mapsCtrl.labeledLocations.refresh();
    final loc = _mapsCtrl.currentLocation.value;
    if (loc != null) {
      _mapsCtrl.fetchNearbyPlaces(loc.lat, loc.lng);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    const expandedHeight = 130.0;
    const threshold = expandedHeight - kToolbarHeight;
    final offset = _scrollController.offset;
    final opacity = (offset / threshold).clamp(0.0, 1.0);
    if (opacity != _smallTitleOpacity) {
      setState(() => _smallTitleOpacity = opacity);
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              /// 🔥 PREMIUM COLLAPSING APP BAR
              SliverAppBar(
                backgroundColor: AppColors.background,
                expandedHeight: 130,
                pinned: true,
                floating: false,
                elevation: 0,
                leadingWidth: 40,
                titleSpacing: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.textPrimary,
                    size: 22,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Opacity(
                  opacity: _smallTitleOpacity,
                  child: Text(
                    "Select Location",
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: context.responsiveFont(18),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Container(
                    padding: EdgeInsets.only(
                      left: context.widthPct(4),
                      bottom: context.heightPct(2.5),
                    ),
                    alignment: Alignment.bottomLeft,
                    child: Opacity(
                      opacity: (1.0 - _smallTitleOpacity).clamp(0.0, 1.0),
                      child: Text(
                        "Select Location",
                        style: AppTypography.displayLg.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: context.responsiveFont(28),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              /// 🔥 INTERACTIVE SEARCH BAR
              SliverPersistentHeader(
                pinned: true,
                delegate: SearchBarDelegate(_searchController, _mapsCtrl),
              ),

              /// 🔥 CONTENT
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(context.widthPct(4)),
                  child: Column(
                    children: [
                      /// CURRENT LOCATION
                      TapBounceContainer(
                        onTap: () async {
                          HapticFeedback.lightImpact();
                          await _mapsCtrl.useCurrentLocation();
                          if (!context.mounted) return;
                          if (_mapsCtrl.isLocationResolved.value) {
                            Navigator.pop(context);
                          }
                        },
                        child: const CurrentLocationCard(),
                      ),

                      SizedBox(height: context.heightPct(2.5)),

                      /// SUBTLE DIVIDER
                      Container(
                        height: 1,
                        margin: EdgeInsets.symmetric(horizontal: context.widthPct(1)),
                        color: AppColors.textPrimary.withValues(alpha: 0.05),
                      ),

                      SizedBox(height: context.heightPct(2.5)),

                      /// LABELED LOCATIONS HEADER
                      const SectionHeader(title: "SAVED LOCATIONS"),
                      SizedBox(height: context.heightPct(1.8)),
                    ],
                  ),
                ),
              ),

              /// 🔥 LABELED LOCATIONS
              Obx(() {
                final labeled = _mapsCtrl.labeledLocations;
                if (labeled.isEmpty) {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate((_, i) {
                    final loc = labeled[i];
                    final icons = {
                      'Home': Icons.home_outlined,
                      'Work': Icons.work_outline,
                      'Gym': Icons.fitness_center,
                    };
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
                      child: TapBounceContainer(
                        onTap: () => _selectSavedLocation(loc),
                        child: LocationTile(
                          icon: icons[loc.label] ?? Icons.location_on_outlined,
                          title: loc.label ?? 'Saved',
                          subtitle: loc.fullAddress,
                          onEdit: () {
                            _mapsCtrl.currentLocation.value = loc;
                            _mapsCtrl.displayCity.value = loc.city;
                            _mapsCtrl.displayLocality.value = loc.subLocality;
                            _mapsCtrl.displayLandmark.value = loc.landmark;
                            _mapsCtrl.displayAddress.value = loc.fullAddress;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MapPickerScreen(),
                              ),
                            ).then((_) {
                              _mapsCtrl.recentLocations.refresh();
                              _mapsCtrl.labeledLocations.refresh();
                            });
                          },
                          onDelete: () {
                            HapticFeedback.mediumImpact();
                            _mapsCtrl.removeSavedLocation(loc, isRecent: false);
                          },
                        ),
                      ),
                    );
                  }, childCount: labeled.length),
                );
              }),

              /// RECENT LOCATIONS HEADER
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    context.widthPct(5),
                    context.heightPct(2.5),
                    context.widthPct(5),
                    context.heightPct(1.8),
                  ),
                  child: const SectionHeader(title: "RECENT"),
                ),
              ),

              /// 🔥 RECENT LOCATIONS LIST
              Obx(() {
                final recents = _mapsCtrl.recentLocations;
                if (recents.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.widthPct(5)),
                      child: Text(
                        "No recent locations yet",
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.muted.withValues(alpha: 0.5),
                          fontSize: context.responsiveFont(13),
                        ),
                      ),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate((_, i) {
                    final loc = recents[i];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
                      child: TapBounceContainer(
                        onTap: () => _selectSavedLocation(loc),
                        child: LocationTile(
                          icon: Icons.history,
                          title: loc.subLocality.isNotEmpty
                              ? loc.subLocality
                              : loc.city,
                          subtitle: loc.fullAddress,
                          tag: "RECENT",
                          onEdit: () {
                            _mapsCtrl.currentLocation.value = loc;
                            _mapsCtrl.displayCity.value = loc.city;
                            _mapsCtrl.displayLocality.value = loc.subLocality;
                            _mapsCtrl.displayLandmark.value = loc.landmark;
                            _mapsCtrl.displayAddress.value = loc.fullAddress;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MapPickerScreen(),
                              ),
                            ).then((_) {
                              _mapsCtrl.recentLocations.refresh();
                              _mapsCtrl.labeledLocations.refresh();
                            });
                          },
                          onDelete: () {
                            HapticFeedback.mediumImpact();
                            _mapsCtrl.removeSavedLocation(loc, isRecent: true);
                          },
                        ),
                      ),
                    );
                  }, childCount: recents.length.clamp(0, 5)),
                );
              }),

              /// NEARBY HEADER
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    context.widthPct(5),
                    context.heightPct(2.5),
                    context.widthPct(5),
                    context.heightPct(1.8),
                  ),
                  child: const SectionHeader(title: "NEARBY"),
                ),
              ),

              /// 🔥 NEARBY PLACES
              Obx(() {
                final nearby = _mapsCtrl.nearbyPlaces;
                if (nearby.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.widthPct(5)),
                      child: Text(
                        "No nearby places found",
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.muted.withValues(alpha: 0.5),
                          fontSize: context.responsiveFont(13),
                        ),
                      ),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate((_, i) {
                    final place = nearby[i];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
                      child: TapBounceContainer(
                        onTap: () => _selectNearbyPlace(place),
                        child: LocationTile(
                          icon: Icons.place_outlined,
                          title: place.name,
                          subtitle: place.address,
                          tag: "NEARBY",
                        ),
                      ),
                    );
                  }, childCount: nearby.length.clamp(0, 5)),
                );
              }),

              /// MAP TILE
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    context.widthPct(4),
                    context.heightPct(2.5),
                    context.widthPct(4),
                    context.heightPct(4),
                  ),
                  child: TapBounceContainer(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MapPickerScreen(),
                        ),
                      );
                      // Refresh after returning from picker
                      _mapsCtrl.recentLocations.refresh();
                      _mapsCtrl.labeledLocations.refresh();
                    },
                    child: const MapTile(),
                  ),
                ),
              ),
            ],
          ),

          // ─── SEARCH RESULTS OVERLAY ────────────────────────
          SearchResultsOverlay(
            searchController: _searchController,
            mapsCtrl: _mapsCtrl,
          ),
        ],
      ),
    );
  }

  void _selectSavedLocation(LocationData loc) {
    HapticFeedback.lightImpact();
    _mapsCtrl.currentLocation.value = loc;
    _mapsCtrl.displayCity.value = loc.city;
    _mapsCtrl.displayLocality.value = loc.subLocality;
    _mapsCtrl.displayLandmark.value = loc.landmark;
    _mapsCtrl.displayAddress.value = loc.fullAddress;
    _mapsCtrl.isLocationResolved.value = true;
    MapsPreferences.saveCurrentLocation(loc);
    _mapsCtrl.saveLocationToFirebase(loc);
    Navigator.pop(context);
  }

  void _selectNearbyPlace(NearbyPlace place) {
    HapticFeedback.lightImpact();
    final loc = LocationData(
      lat: place.lat,
      lng: place.lng,
      city: '',
      subLocality: place.name,
      street: place.address,
      landmark: place.name,
      fullAddress: place.address,
    );
    _mapsCtrl.currentLocation.value = loc;
    _mapsCtrl.displayCity.value = '';
    _mapsCtrl.displayLocality.value = place.name;
    _mapsCtrl.displayAddress.value = place.address;
    _mapsCtrl.isLocationResolved.value = true;
    MapsPreferences.saveCurrentLocation(loc);
    _mapsCtrl.saveLocationToFirebase(loc);
    Navigator.pop(context);
  }
}
