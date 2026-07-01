import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/view/USER/Maps/maps_constants.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MapPickerSearchResults extends StatelessWidget {
  final TextEditingController searchController;
  final FocusNode searchFocus;

  MapPickerSearchResults({
    super.key,
    required this.searchController,
    required this.searchFocus,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final mapsCtrl = Get.find<MapsController>();

    return Obx(() {
      if (mapsCtrl.searchResults.isEmpty) return SizedBox.shrink();
      return Container(
        margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(4)),
        constraints: BoxConstraints(maxHeight: 250),
        decoration: BoxDecoration(
          color: kCard.withValues(alpha: 0.97),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
          border: Border.all(color: Colors.white10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: mapsCtrl.searchResults.length,
            separatorBuilder: (_, __) =>
                Divider(height: ResponsiveHelper.h(1), color: Colors.white.withValues(alpha: 0.05)),
            itemBuilder: (_, i) {
              final result = mapsCtrl.searchResults[i];
              return ListTile(
                dense: true,
                leading: Icon(
                  Icons.location_on_outlined,
                  color: kSpotifyGreen,
                  size: 20,
                ),
                title: Text(
                  result.description,
                  style: TextStyle(color: Colors.white, fontSize: 13),
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
