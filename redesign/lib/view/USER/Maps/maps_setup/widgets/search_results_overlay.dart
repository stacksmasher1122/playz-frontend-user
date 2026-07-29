import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/view/USER/Maps/maps_picker/maps_picker_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SearchResultsOverlay extends StatelessWidget {
  final TextEditingController searchController;
  final MapsController mapsCtrl;

  const SearchResultsOverlay({
    super.key,
    required this.searchController,
    required this.mapsCtrl,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Obx(() {
      if (mapsCtrl.searchResults.isEmpty) {
        return const SizedBox.shrink();
      }
      return Positioned(
        top: 130 + MediaQuery.of(context).padding.top,
        left: context.widthPct(4),
        right: context.widthPct(4),
        child: Container(
          constraints: BoxConstraints(maxHeight: context.heightPct(35).clamp(220.0, 320.0)),
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
                  onTap: () async {
                    HapticFeedback.selectionClick();
                    searchController.clear();
                    mapsCtrl.searchResults.clear();
                    await mapsCtrl.selectSearchResult(result);
                    if (!context.mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MapPickerScreen(),
                      ),
                    );
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
