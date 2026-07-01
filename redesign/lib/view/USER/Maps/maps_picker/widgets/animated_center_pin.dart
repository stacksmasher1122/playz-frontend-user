import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/view/USER/Maps/maps_constants.dart';

class AnimatedCenterPin extends StatelessWidget {
  const AnimatedCenterPin({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<MapsController>();
    return Obx(() {
      final dragging = ctrl.isDragging.value;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: dragging ? 0.0 : 1.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                "MOVE MAP TO ADJUST LOCATION",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: kBg,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Animated pin
          AnimatedScale(
            scale: dragging ? 1.2 : 1.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: kSpotifyGreen.withValues(alpha: dragging ? 0.8 : 0.5),
                    blurRadius: dragging ? 40 : 25,
                    spreadRadius: dragging ? 8 : 3,
                  ),
                ],
              ),
              child: const Icon(
                Icons.location_on,
                color: kSpotifyGreen,
                size: 50,
              ),
            ),
          ),
          // Shadow dot (below pin)
          AnimatedScale(
            scale: dragging ? 0.5 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              width: 12,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      );
    });
  }
}
