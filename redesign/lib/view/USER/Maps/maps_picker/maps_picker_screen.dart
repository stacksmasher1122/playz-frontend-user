import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/model/maps_model.dart';
import 'package:redesign/shared_preferences/maps_preferences.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';

import 'widgets/animated_center_pin.dart';
import 'widgets/top_bar.dart';
import 'widgets/map_search_bar.dart';
import 'widgets/search_results_list.dart';
import 'widgets/gps_button.dart';
import 'widgets/bottom_card.dart';
import 'widgets/address_preview.dart';
import 'widgets/confirm_button.dart';
import 'widgets/error_overlay.dart';
import 'package:redesign/theme/responsive_helper.dart';

/// Dark Map Style JSON
String _darkMapStyle = '''
[
  {"elementType":"geometry","stylers":[{"color":"#212121"}]},
  {"elementType":"labels.icon","stylers":[{"visibility":"off"}]},
  {"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},
  {"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},
  {"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#757575"}]},
  {"featureType":"administrative.country","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},
  {"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},
  {"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},
  {"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},
  {"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#181818"}]},
  {"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},
  {"featureType":"poi.park","elementType":"labels.text.stroke","stylers":[{"color":"#1b1b1b"}]},
  {"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#2c2c2c"}]},
  {"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8a8a8a"}]},
  {"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#373737"}]},
  {"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3c3c3c"}]},
  {"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#4e4e4e"}]},
  {"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},
  {"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},
  {"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]},
  {"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]}
]
''';

class MapPickerScreen extends StatefulWidget {
  final bool isSelectOnly;

  const MapPickerScreen({
    super.key,
    this.isSelectOnly = false,
  });

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen>
    with TickerProviderStateMixin {
  final _mapsCtrl = Get.find<MapsController>();
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();

  LatLng _lastCameraPos = const LatLng(18.5204, 73.8567); // Default: Pune
  LocationData? _originalUserLocation;

  @override
  void initState() {
    super.initState();
    if (widget.isSelectOnly) {
      _mapsCtrl.isSelectOnlyMode = true;
    }
    final cur = _mapsCtrl.currentLocation.value;
    if (cur != null) {
      _originalUserLocation = LocationData.fromMap(cur.toMap());
      _lastCameraPos = LatLng(cur.lat, cur.lng);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.isSelectOnly) {
        _mapsCtrl.detectCurrentLocation();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    _mapsCtrl.mapController = null;
    if (widget.isSelectOnly) {
      _mapsCtrl.isSelectOnlyMode = false;
      if (_originalUserLocation != null) {
        _mapsCtrl.currentLocation.value = _originalUserLocation;
        _mapsCtrl.updateDisplayFields(_originalUserLocation!);
        MapsPreferences.saveCurrentLocation(_originalUserLocation!);
      }
    }
    super.dispose();
  }

  // ─── LABEL DIALOG ───────────────────────────────────────────
  Future<void> _showLabelDialog() async {
    final labels = ['Home', 'Work', 'Gym', 'Other'];
    String? selected;

    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(context.minDimensionPct(6))),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            context.widthPct(5),
            context.heightPct(2),
            context.widthPct(5),
            context.heightPct(3.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: context.widthPct(10),
                height: context.heightPct(0.5),
                margin: EdgeInsets.only(bottom: context.heightPct(2.5)),
                decoration: BoxDecoration(
                  color: AppColors.borderDark,
                  borderRadius: BorderRadius.circular(context.minDimensionPct(2)),
                ),
              ),
              Text(
                'Save Location As',
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: context.heightPct(2.5)),
              Wrap(
                spacing: context.widthPct(3),
                runSpacing: context.heightPct(1.5),
                children: labels.map((label) {
                  final icons = {
                    'Home': Icons.home_outlined,
                    'Work': Icons.work_outline,
                    'Gym': Icons.fitness_center,
                    'Other': Icons.location_on_outlined,
                  };
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      selected = label;
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      width: context.widthPct(20).clamp(70.0, 90.0),
                      padding: EdgeInsets.symmetric(vertical: context.heightPct(2)),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
                        border: Border.all(color: AppColors.borderDark),
                      ),
                      child: Column(
                        children: [
                          Icon(icons[label], color: AppColors.accent, size: 28),
                          SizedBox(height: context.heightPct(1)),
                          Text(
                            label,
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: context.responsiveFont(12),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: context.heightPct(2)),
              GestureDetector(
                onTap: () {
                  selected = null;
                  Navigator.pop(ctx);
                },
                child: Text(
                  'Skip',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(14),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    // Confirm regardless of label choice
    await _mapsCtrl.confirmLocation(label: selected);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // ─── GOOGLE MAP ─────────────────────────────────────
          Obx(() {
            final loc = _mapsCtrl.currentLocation.value;
            final initialPos = loc != null
                ? LatLng(loc.lat, loc.lng)
                : _lastCameraPos;
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: initialPos,
                zoom: 16,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              compassEnabled: false,
              mapToolbarEnabled: false,
              style: _darkMapStyle,
              onMapCreated: (controller) {
                _mapsCtrl.mapController = controller;
              },
              onCameraMoveStarted: () {
                _mapsCtrl.onCameraMoveStarted();
              },
              onCameraMove: (pos) {
                _lastCameraPos = pos.target;
              },
              onCameraIdle: () {
                _mapsCtrl.onCameraIdle(_lastCameraPos);
              },
            );
          }),

          // ─── CENTER PIN + LABEL ─────────────────────────────
          const Center(child: AnimatedCenterPin()),

          // ─── TOP BAR + SEARCH ───────────────────────────────
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const MapPickerTopBar(),
                SizedBox(height: context.heightPct(1.5)),
                MapPickerSearchBar(
                  searchController: _searchController,
                  searchFocus: _searchFocus,
                ),
                // Inline search results overlay
                MapPickerSearchResults(
                  searchController: _searchController,
                  searchFocus: _searchFocus,
                ),
              ],
            ),
          ),

          // ─── GPS BUTTON ─────────────────────────────────────
          Positioned(
            right: context.widthPct(4),
            bottom: context.heightPct(26),
            child: const GpsButton(),
          ),

          // ─── BOTTOM SHEET ───────────────────────────────────
          Align(
            alignment: Alignment.bottomCenter,
            child: MapPickerBottomCard(
              addressPreview: const AddressPreview(),
              confirmButton: ConfirmButton(
                onConfirm: () async {
                  if (widget.isSelectOnly) {
                    final selectedLoc = _mapsCtrl.currentLocation.value;
                    if (_originalUserLocation != null) {
                      _mapsCtrl.currentLocation.value = _originalUserLocation;
                      _mapsCtrl.updateDisplayFields(_originalUserLocation!);
                      await MapsPreferences.saveCurrentLocation(_originalUserLocation!);
                    }
                    _mapsCtrl.isSelectOnlyMode = false;
                    if (!context.mounted) return;
                    Navigator.pop(context, selectedLoc);
                  } else {
                    await _showLabelDialog();
                  }
                },
              ),
            ),
          ),

          // ─── ERROR OVERLAY ──────────────────────────────────
          const ErrorOverlay(),
        ],
      ),
    );
  }
}
