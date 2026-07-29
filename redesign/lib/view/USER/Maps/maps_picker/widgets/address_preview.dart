import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class AddressPreview extends StatelessWidget {
  const AddressPreview({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final mapsCtrl = Get.find<MapsController>();

    return Obx(() {
      final isDrag = mapsCtrl.isDragging.value;
      final loading = mapsCtrl.isLoading.value;
      final resolved = mapsCtrl.isLocationResolved.value;

      String title;
      String subtitle;

      if (isDrag || (loading && !resolved)) {
        title = 'Fetching location...';
        subtitle = 'Move map to adjust';
      } else {
        final city = mapsCtrl.displayCity.value;
        final locality = mapsCtrl.displayLocality.value;
        final landmark = mapsCtrl.displayLandmark.value;
        final address = mapsCtrl.displayAddress.value;

        title = locality.isNotEmpty
            ? locality
            : (city.isNotEmpty ? city : 'Unknown');
        subtitle = landmark.isNotEmpty && landmark != locality
            ? 'Near $landmark · $address'
            : address.isNotEmpty
            ? address
            : 'Tap GPS to detect location';
      }

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Column(
          key: ValueKey('$title-${subtitle.hashCode}'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(18),
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: context.heightPct(0.4)),
            Text(
              subtitle,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.muted,
                fontSize: context.responsiveFont(12),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    });
  }
}
