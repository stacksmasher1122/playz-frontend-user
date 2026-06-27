import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/view/USER/Maps/maps_constants.dart';

class ConfirmButton extends StatelessWidget {
  final VoidCallback onConfirm;

  const ConfirmButton({
    super.key,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final mapsCtrl = Get.find<MapsController>();

    return Obx(() {
      final canConfirm =
          mapsCtrl.isLocationResolved.value &&
          !mapsCtrl.isLoading.value &&
          !mapsCtrl.isDragging.value;

      return GestureDetector(
        onTap: canConfirm ? onConfirm : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 55,
          width: double.infinity,
          decoration: BoxDecoration(
            color: canConfirm ? kSpotifyGreen : kSpotifyGreen.withOpacity(0.3),
            borderRadius: BorderRadius.circular(30),
            boxShadow: canConfirm
                ? [
                    BoxShadow(
                      color: kSpotifyGreen.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: mapsCtrl.isLoading.value
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.black,
                    ),
                  )
                : Text(
                    "Confirm Location",
                    style: TextStyle(
                      color: canConfirm ? Colors.black : Colors.black38,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
      );
    });
  }
}
