import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/view/USER/Maps/maps_constants.dart';
import 'package:redesign/theme/responsive_helper.dart';


class CurrentLocationCard extends StatelessWidget {
  CurrentLocationCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final ctrl = Get.find<MapsController>();
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: kSpotifyGreen, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.w(10)),
            decoration: BoxDecoration(
              color: kSpotifyGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
            ),
            child: Obx(() {
              if (ctrl.isLoading.value) {
                return SizedBox(
                  width: ResponsiveHelper.w(22),
                  height: ResponsiveHelper.h(22),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: kSpotifyGreen,
                  ),
                );
              }
              return Icon(
                Icons.my_location,
                color: kSpotifyGreen,
                size: 22,
              );
            }),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Use Current Location",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: ResponsiveHelper.sp(15),
                  ),
                ),
                SizedBox(height: 4),
                Obx(() {
                  final loc = ctrl.displayLocality.value;
                  return Text(
                    loc.isNotEmpty ? loc : "Detect your location automatically",
                    style: TextStyle(color: kMuted, fontSize: 12),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
