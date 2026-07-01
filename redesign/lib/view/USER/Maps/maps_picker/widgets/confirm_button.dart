import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/view/USER/Maps/maps_constants.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ConfirmButton extends StatelessWidget {
  final VoidCallback onConfirm;

  ConfirmButton({
    super.key,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final mapsCtrl = Get.find<MapsController>();

    return Obx(() {
      final canConfirm =
          mapsCtrl.isLocationResolved.value &&
          !mapsCtrl.isLoading.value &&
          !mapsCtrl.isDragging.value;

      return GestureDetector(
        onTap: canConfirm ? onConfirm : null,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: ResponsiveHelper.h(55),
          width: double.infinity,
          decoration: BoxDecoration(
            color: canConfirm ? kSpotifyGreen : kSpotifyGreen.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(30)),
            boxShadow: canConfirm
                ? [
                    BoxShadow(
                      color: kSpotifyGreen.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: mapsCtrl.isLoading.value
                ? SizedBox(
                    width: ResponsiveHelper.w(24),
                    height: ResponsiveHelper.h(24),
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
                      fontSize: ResponsiveHelper.sp(16),
                    ),
                  ),
          ),
        ),
      );
    });
  }
}
