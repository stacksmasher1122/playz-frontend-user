import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/view/USER/Maps/maps_constants.dart';

class GpsButton extends StatelessWidget {
  const GpsButton({super.key});

  @override
  Widget build(BuildContext context) {
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
              color: Colors.black.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Obx(() {
          if (mapsCtrl.isLoading.value) {
            return const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: kSpotifyGreen,
              ),
            );
          }
          return const Icon(Icons.my_location, color: Colors.white);
        }),
      ),
    );
  }
}
