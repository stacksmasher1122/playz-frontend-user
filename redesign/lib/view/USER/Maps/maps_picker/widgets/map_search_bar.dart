import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/view/USER/Maps/maps_constants.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MapPickerSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final FocusNode searchFocus;

  MapPickerSearchBar({
    super.key,
    required this.searchController,
    required this.searchFocus,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final mapsCtrl = Get.find<MapsController>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      child: Container(
        height: ResponsiveHelper.h(50),
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
        decoration: BoxDecoration(
          color: kSurface.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(30)),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: kMuted),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: searchController,
                focusNode: searchFocus,
                cursorColor: kSpotifyGreen,
                style: TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Search turfs, areas, or streets...",
                  hintStyle: TextStyle(color: kMuted, fontSize: 13),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(11)),
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
                  child: Icon(Icons.close, color: kMuted, size: 20),
                );
              }
              return SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
