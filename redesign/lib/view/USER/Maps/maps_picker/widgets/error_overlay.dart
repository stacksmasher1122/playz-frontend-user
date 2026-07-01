import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/view/USER/Maps/maps_constants.dart';

class ErrorOverlay extends StatelessWidget {
  const ErrorOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final mapsCtrl = Get.find<MapsController>();

    return Obx(() {
      if (!mapsCtrl.hasError.value) return const SizedBox.shrink();
      return Positioned(
        left: 16,
        right: 16,
        bottom: 200,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2C1010),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.orangeAccent,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mapsCtrl.errorMessage.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: kSpotifyGreen,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          mapsCtrl.errorMessage.value.contains('Settings')
                              ? 'Open Settings'
                              : 'Retry',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
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
                child: const Icon(Icons.close, color: Colors.white38, size: 20),
              ),
            ],
          ),
        ),
      );
    });
  }
}
