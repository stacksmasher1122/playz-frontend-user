import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/view/USER/Maps/maps_constants.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ErrorOverlay extends StatelessWidget {
  ErrorOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final mapsCtrl = Get.find<MapsController>();

    return Obx(() {
      if (!mapsCtrl.hasError.value) return SizedBox.shrink();
      return Positioned(
        left: ResponsiveHelper.w(16),
        right: ResponsiveHelper.w(16),
        bottom: ResponsiveHelper.h(200),
        child: Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(16)),
          decoration: BoxDecoration(
            color: Color(0xFF2C1010),
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
            border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orangeAccent,
                size: 28,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mapsCtrl.errorMessage.value,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.sp(13),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        if (mapsCtrl.errorMessage.value.contains('Settings')) {
                          mapsCtrl.openAppSettings();
                        } else {
                          mapsCtrl.hasError.value = false;
                          mapsCtrl.detectCurrentLocation();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: kSpotifyGreen,
                          borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
                        ),
                        child: Text(
                          mapsCtrl.errorMessage.value.contains('Settings')
                              ? 'Open Settings'
                              : 'Retry',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: ResponsiveHelper.sp(12),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => mapsCtrl.hasError.value = false,
                child: Icon(Icons.close, color: Colors.white38, size: 20),
              ),
            ],
          ),
        ),
      );
    });
  }
}
