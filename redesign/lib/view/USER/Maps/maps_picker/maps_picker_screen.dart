import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/view/USER/Maps/maps_constants.dart';

import 'widgets/animated_center_pin.dart';
import 'widgets/top_bar.dart';
import 'widgets/map_search_bar.dart';
import 'widgets/search_results_list.dart';
import 'widgets/gps_button.dart';
import 'widgets/bottom_card.dart';
import 'widgets/address_preview.dart';
import 'widgets/confirm_button.dart';
import 'widgets/error_overlay.dart';

/// Dark Map Style JSON
const String _darkMapStyle = '''
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

  @override
  void initState() {
    super.initState();
    // Auto detect on open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loc = _mapsCtrl.currentLocation.value;
      if (loc != null) {
        _lastCameraPos = LatLng(loc.lat, loc.lng);
      }
      _mapsCtrl.detectCurrentLocation();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    _mapsCtrl.mapController = null;
    super.dispose();
  }

  // ─── LABEL DIALOG ───────────────────────────────────────────
  Future<void> _showLabelDialog() async {
    final labels = ['Home', 'Work', 'Gym', 'Other'];
    String? selected;

    await showModalBottomSheet(
      context: context,
      backgroundColor: kCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const Text(
                'Save Location As',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
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
                      width: 80,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: kSurface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Column(
                        children: [
                          Icon(icons[label], color: kSpotifyGreen, size: 28),
                          const SizedBox(height: 8),
                          Text(
                            label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  selected = null;
                  Navigator.pop(ctx);
                },
                child: const Text(
                  'Skip',
                  style: TextStyle(color: kMuted, fontSize: 14),
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
    return Scaffold(
      backgroundColor: kBg,
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
                const SizedBox(height: 12),
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
          const Positioned(
            right: 16,
            bottom: 220,
            child: GpsButton(),
          ),

          // ─── BOTTOM SHEET ───────────────────────────────────
          Align(
            alignment: Alignment.bottomCenter,
            child: MapPickerBottomCard(
              addressPreview: const AddressPreview(),
              confirmButton: ConfirmButton(
                onConfirm: () async {
                  if (widget.isSelectOnly) {
                    // Don't save, just return the selected location
                    Navigator.pop(context, _mapsCtrl.currentLocation.value);
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
