import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class GpsButton extends StatelessWidget {
  const GpsButton({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final mapsCtrl = Get.find<MapsController>();

    return GestureDetector(
      onTap: () {
        mapsCtrl.useCurrentLocation();
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.borderDark),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(context.widthPct(3.5)),
        child: Obx(() {
          if (mapsCtrl.isLoading.value) {
            return SizedBox(
              width: context.widthPct(6),
              height: context.widthPct(6),
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.accent,
              ),
            );
          }
          return const Icon(Icons.my_location, color: AppColors.textPrimary);
        }),
      ),
    );
  }
}
