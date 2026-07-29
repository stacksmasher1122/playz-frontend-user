import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

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
    ResponsiveHelper.init(context);
    final mapsCtrl = Get.find<MapsController>();

    return Obx(() {
      if (mapsCtrl.searchResults.isEmpty) return const SizedBox.shrink();
      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: context.widthPct(4),
          vertical: context.heightPct(0.5),
        ),
        constraints: BoxConstraints(maxHeight: context.heightPct(30).clamp(200.0, 280.0)),
        decoration: BoxDecoration(
          color: AppColors.card.withValues(alpha: 0.97),
          borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
          border: Border.all(color: AppColors.borderDark),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: mapsCtrl.searchResults.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: AppColors.textPrimary.withValues(alpha: 0.05),
            ),
            itemBuilder: (_, i) {
              final result = mapsCtrl.searchResults[i];
              return ListTile(
                dense: true,
                leading: const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.accent,
                  size: 20,
                ),
                title: Text(
                  result.description,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(13),
                  ),
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
