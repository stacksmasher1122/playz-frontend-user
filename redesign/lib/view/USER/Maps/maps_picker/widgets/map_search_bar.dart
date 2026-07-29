import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

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
    ResponsiveHelper.init(context);
    final mapsCtrl = Get.find<MapsController>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      child: Container(
        height: context.heightPct(6).clamp(46.0, 54.0),
        padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(context.minDimensionPct(8)),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: AppColors.muted),
            SizedBox(width: context.widthPct(2.5)),
            Expanded(
              child: TextField(
                controller: searchController,
                focusNode: searchFocus,
                cursorColor: AppColors.accent,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(14),
                ),
                decoration: InputDecoration(
                  hintText: "Search turfs, areas, or streets...",
                  hintStyle: AppTypography.bodySm.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(13),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: context.heightPct(1.2)),
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
                  child: const Icon(Icons.close, color: AppColors.muted, size: 20),
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
