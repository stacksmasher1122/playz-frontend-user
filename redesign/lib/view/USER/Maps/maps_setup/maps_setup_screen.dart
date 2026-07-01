import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/model/maps_model.dart';
import 'package:redesign/shared_preferences/maps_preferences.dart';
import 'package:redesign/view/USER/Maps/maps_picker/maps_picker_screen.dart';
import 'package:redesign/view/USER/Maps/maps_setup/widgets/current_location_card.dart';
import 'package:redesign/view/USER/Maps/maps_setup/widgets/location_tile.dart';
import 'package:redesign/view/USER/Maps/maps_setup/widgets/map_tile.dart';
import 'package:redesign/view/USER/Maps/maps_setup/widgets/search_bar_delegate.dart';
import 'package:redesign/view/USER/Maps/maps_setup/widgets/section_header.dart';
import 'package:redesign/view/USER/Maps/maps_setup/widgets/tap_bounce_container.dart';
import 'package:redesign/view/USER/Maps/maps_setup/widgets/search_results_overlay.dart';

import 'package:redesign/view/USER/Maps/maps_constants.dart';
import 'package:redesign/theme/responsive_helper.dart';


class LocationSelectSliverScreen extends StatefulWidget {
  LocationSelectSliverScreen({super.key});

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
      backgroundColor: kBg,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              /// 🔥 PREMIUM COLLAPSING APP BAR
              SliverAppBar(
                backgroundColor: kBg,
                expandedHeight: 130,
                pinned: true,
                floating: false,
                elevation: 0,
                leadingWidth: 40,
                titleSpacing: 0,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 22,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Opacity(
                  opacity: _smallTitleOpacity,
                  child: Text(
                    "Select Location",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.sp(18),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Container(
                    padding: EdgeInsets.only(left: ResponsiveHelper.w(16), bottom: 20),
                    alignment: Alignment.bottomLeft,
                    child: Opacity(
                      opacity: (1.0 - _smallTitleOpacity).clamp(0.0, 1.0),
                      child: Text(
                        "Select Location",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.sp(28),
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
                  padding: EdgeInsets.all(ResponsiveHelper.w(16)),
                  child: Column(
                    children: [
                      /// CURRENT LOCATION
                      TapBounceContainer(
                        onTap: () async {
                          HapticFeedback.lightImpact();
                          await _mapsCtrl.useCurrentLocation();
                          if (mounted && _mapsCtrl.isLocationResolved.value) {
                            Navigator.pop(context);
                          }
                        },
                        child: CurrentLocationCard(),
                      ),

                      SizedBox(height: 24),

                      /// SUBTLE DIVIDER
                      Container(
                        height: ResponsiveHelper.h(1),
                        margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(4)),
                        color: Colors.white.withValues(alpha: 0.05),
                      ),

                      SizedBox(height: 24),

                      /// LABELED LOCATIONS HEADER
                      SectionHeader(title: "SAVED LOCATIONS"),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              /// 🔥 LABELED LOCATIONS
              Obx(() {
                final labeled = _mapsCtrl.labeledLocations;
                if (labeled.isEmpty) {
                  return SliverToBoxAdapter(child: SizedBox.shrink());
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
                      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
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
                                builder: (context) => MapPickerScreen(),
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
                  padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
                  child: SectionHeader(title: "RECENT"),
                ),
              ),

              /// 🔥 RECENT LOCATIONS LIST
              Obx(() {
                final recents = _mapsCtrl.recentLocations;
                if (recents.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20)),
                      child: Text(
                        "No recent locations yet",
                        style: TextStyle(
                          color: kMuted.withValues(alpha: 0.5),
                          fontSize: ResponsiveHelper.sp(13),
                        ),
                      ),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate((_, i) {
                    final loc = recents[i];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
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
                                builder: (context) => MapPickerScreen(),
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
                  padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
                  child: SectionHeader(title: "NEARBY"),
                ),
              ),

              /// 🔥 NEARBY PLACES
              Obx(() {
                final nearby = _mapsCtrl.nearbyPlaces;
                if (nearby.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20)),
                      child: Text(
                        "No nearby places found",
                        style: TextStyle(
                          color: kMuted.withValues(alpha: 0.5),
                          fontSize: ResponsiveHelper.sp(13),
                        ),
                      ),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate((_, i) {
                    final place = nearby[i];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
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
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 40),
                  child: TapBounceContainer(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapPickerScreen(),
                        ),
                      );
                      // Refresh after returning from picker
                      _mapsCtrl.recentLocations.refresh();
                      _mapsCtrl.labeledLocations.refresh();
                    },
                    child: MapTile(),
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
