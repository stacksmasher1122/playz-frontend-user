import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/view/USER/Maps/maps_constants.dart';
import 'package:redesign/theme/responsive_helper.dart';

class GpsButton extends StatelessWidget {
  GpsButton({super.key});

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
          color: kCard,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(ResponsiveHelper.w(14)),
        child: Obx(() {
          if (mapsCtrl.isLoading.value) {
            return SizedBox(
              width: ResponsiveHelper.w(24),
              height: ResponsiveHelper.h(24),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: kSpotifyGreen,
              ),
            );
          }
          return Icon(Icons.my_location, color: Colors.white);
        }),
      ),
    );
  }
}
