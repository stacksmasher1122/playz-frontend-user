import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/view/USER/Maps/maps_picker/maps_picker_screen.dart';
import 'package:redesign/view/USER/Maps/maps_constants.dart';
import 'package:redesign/theme/responsive_helper.dart';


class SearchResultsOverlay extends StatelessWidget {
  final TextEditingController searchController;
  final MapsController mapsCtrl;

  SearchResultsOverlay({
    super.key,
    required this.searchController,
    required this.mapsCtrl,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Obx(() {
      if (mapsCtrl.searchResults.isEmpty) {
        return SizedBox.shrink();
      }
      return Positioned(
        top: 130 + MediaQuery.of(context).padding.top,
        left: ResponsiveHelper.w(16),
        right: ResponsiveHelper.w(16),
        child: Container(
          constraints: BoxConstraints(maxHeight: 300),
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
              separatorBuilder: (_, __) => Divider(
                height: ResponsiveHelper.h(1),
                color: Colors.white.withValues(alpha: 0.05),
              ),
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
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.sp(13),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    HapticFeedback.selectionClick();
                    searchController.clear();
                    mapsCtrl.searchResults.clear();
                    // Navigate to map picker with selected place
                    mapsCtrl.selectSearchResult(result).then((_) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MapPickerScreen(),
                        ),
                      );
                    });
                  },
                );
              },
            ),
          ),
        ),
      );
    });
  }
}
