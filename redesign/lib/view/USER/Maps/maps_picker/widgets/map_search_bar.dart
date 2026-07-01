import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/view/USER/Maps/maps_constants.dart';

class MapPickerSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final FocusNode searchFocus;

  const MapPickerSearchBar({
    super.key,
    required this.searchController,
    required this.searchFocus,
  });

  @override
  Widget build(BuildContext context) {
    final mapsCtrl = Get.find<MapsController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: kSurface.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: kMuted),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: searchController,
                focusNode: searchFocus,
                cursorColor: kSpotifyGreen,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: "Search turfs, areas, or streets...",
                  hintStyle: TextStyle(color: kMuted, fontSize: 13),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 11),
                ),
                onChanged: (query) {
                  HapticFeedback.selectionClick();
                  mapsCtrl.searchPlaces(query);
                },
              ),
            ),
            Obx(() {
              if (mapsCtrl.searchResults.isNotEmpty) {
                return GestureDetector(
                  onTap: () {
                    searchController.clear();
                    mapsCtrl.searchResults.clear();
                    searchFocus.unfocus();
                  },
                  child: const Icon(Icons.close, color: kMuted, size: 20),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
