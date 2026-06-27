import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/view/USER/Maps/maps_constants.dart';

class MapPickerSearchResults extends StatelessWidget {
  final TextEditingController searchController;
  final FocusNode searchFocus;

  const MapPickerSearchResults({
    super.key,
    required this.searchController,
    required this.searchFocus,
  });

  @override
  Widget build(BuildContext context) {
    final mapsCtrl = Get.find<MapsController>();

    return Obx(() {
      if (mapsCtrl.searchResults.isEmpty) return const SizedBox.shrink();
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        constraints: const BoxConstraints(maxHeight: 250),
        decoration: BoxDecoration(
          color: kCard.withOpacity(0.97),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: mapsCtrl.searchResults.length,
            separatorBuilder: (_, __) =>
                Divider(height: 1, color: Colors.white.withOpacity(0.05)),
            itemBuilder: (_, i) {
              final result = mapsCtrl.searchResults[i];
              return ListTile(
                dense: true,
                leading: const Icon(
                  Icons.location_on_outlined,
                  color: kSpotifyGreen,
                  size: 20,
                ),
                title: Text(
                  result.description,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  HapticFeedback.selectionClick();
                  searchController.clear();
                  searchFocus.unfocus();
                  mapsCtrl.selectSearchResult(result);
                },
              );
            },
          ),
        ),
      );
    });
  }
}
