import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/view/USER/Maps/maps_constants.dart';
import 'package:redesign/theme/responsive_helper.dart';

class AnimatedCenterPin extends StatelessWidget {
  AnimatedCenterPin({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final ctrl = Get.find<MapsController>();
    return Obx(() {
      final dragging = ctrl.isDragging.value;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label
          AnimatedOpacity(
            duration: Duration(milliseconds: 200),
            opacity: dragging ? 0.0 : 1.0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(14), vertical: ResponsiveHelper.h(6)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                "MOVE MAP TO ADJUST LOCATION",
                style: TextStyle(
                  fontSize: ResponsiveHelper.sp(11),
                  fontWeight: FontWeight.w600,
                  color: kBg,
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          // Animated pin
          AnimatedScale(
            scale: dragging ? 1.2 : 1.0,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
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
              child: Icon(
                Icons.location_on,
                color: kSpotifyGreen,
                size: 50,
              ),
            ),
          ),
          // Shadow dot (below pin)
          AnimatedScale(
            scale: dragging ? 0.5 : 1.0,
            duration: Duration(milliseconds: 200),
            child: Container(
              width: ResponsiveHelper.w(12),
              height: ResponsiveHelper.h(4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
              ),
            ),
          ),
        ],
      );
    });
  }
}
